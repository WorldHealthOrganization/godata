
const R = require('ramda')

const { loadTrackedEntityInstances } = require('./common')
const { getIDFromDisplayName } = require('../util')
const { trackedEntityToCase } = require('../mappings/case')

const copyCases = (dhis2, godata, config, _ = {
  loadTrackedEntityInstances
}) => async () => {
  const [ programs, programStages, dataElements, attributes, organisationUnits, outbreaks ] = await Promise.all([
    dhis2.getPrograms(),
    dhis2.getProgramStages(),
    dhis2.getDataElements(),
    dhis2.getTrackedEntitiesAttributes(),
    dhis2.getOrganisationUnitsFromParent(config.rootID),
    godata.getOutbreaks()])

  const casesProgramID = getIDFromDisplayName(programs, config.dhis2CasesProgram)
  const [ labRequestID, labResultsID, symptomsID ] = R.map(getIDFromDisplayName(programStages), [
    config.dhis2KeyProgramStages.labRequest,
    config.dhis2KeyProgramStages.labResults,
    config.dhis2KeyProgramStages.symptoms
  ])
  const confirmedTestConditions = R.map(
    R.adjust(0, getIDFromDisplayName(dataElements)),
    config.dhis2DataElementsChecks.confirmedTest)
  // Change TrackedEntitiesAttributes names to ids
  config = R.over(
    R.lensProp('dhis2KeyAttributes'),
    R.mapObjIndexed((value) => {
      return R.find(R.propEq('displayName', value), attributes).id
    }),
    config)

  return await R.pipe(
    R.flatten,
    R.map(assignOutbreak(outbreaks, organisationUnits)),
    R.map(R.pipe(
      addLabResultStage(labResultsID),
      addLabRequestStage(labRequestID),
      addLabResult(confirmedTestConditions),
      addCaseClassification(config)
    )),
    R.map(trackedEntityToCase(config)),
    sendCasesToGoData(godata)
  )(await _.loadTrackedEntityInstances(dhis2, organisationUnits, casesProgramID))
}

function findOutbreackForCase (available, orgUnits, locationID) {
  if (available[locationID] != null) {
    return R.path([locationID, 0, 'id'], available)
  } else {
    return findOutbreackForCase(available, orgUnits, R.find(R.propEq('id', locationID), orgUnits).parent.id)
  }
}

function assignOutbreak (outbreaks, orgUnits) {
  const locationsAvaliable = R.pipe(
    R.reduceBy((acc, el) => R.append(el, acc), [], R.path(['locationIds', 0]))
  )(outbreaks)
  return (trackedEntity) => R.assoc(
    'outbreak',
    findOutbreackForCase(locationsAvaliable, orgUnits, trackedEntity.orgUnit),
    trackedEntity)
}

function addLabRequestStage (labRequestID) {
  return (te) =>
    R.assoc('labRequestStage', R.find(R.propEq('programStage', labRequestID), te.events), te)
}

// TODO: one tracked entity can have more than one event of this kind
// This is not handled right now
function addLabResultStage (labResultsID) {
  return (te) =>
    R.assoc('labResultStage', R.find(R.propEq('programStage', labResultsID), te.events), te)
}

function findDataValueByID (dataValues, id) {
  return R.find(R.propEq('dataElement', id), dataValues || [])
}

function checkDataValue (dataValues, dataElement, value) {
  return R.propEq(
    'value',
    value,
    findDataValueByID(dataValues, dataElement) || {}
  )
}

function checkDataValuesConditions (conditions) {
  return R.allPass(
    R.map(
      ([dataElement, value]) => te => 
        checkDataValue(R.path(['labResultStage', 'dataValues'], te), dataElement, value),
      conditions
    ))
}

// TODO: support for 'inconclusive', 'not performed'... results
function addLabResult (confirmedTestConditions) {
  return (te) => R.ifElse(
    R.has('labResultStage'),
    R.assoc('labResult',
      checkDataValuesConditions(confirmedTestConditions)(te) ? 'POSITIVE' : 'NEGATIVE'
    ),
    R.identity()
  )(te)
}

function addCaseClassification () {
  return (te) => R.assoc('caseClassification',
    te.labResult === 'POSITIVE'
      ? 'CONFIRMED'
      : te.labResult === 'NEGATIVE' && te.labResultStage != null
        ? 'NOT_A_CASE_DISCARDED'
        : te.labResultStage == null && te.labRequestStage != null
          ? 'PROBABLE'
          : 'SUSPECT',
    te)
}

function sendCasesToGoData (godata) {
  return R.pipe(
    R.groupBy(R.prop('outbreak')),
    async (outbreaks) => {
      const user = await godata.login()
      for (let outbreak in outbreaks) {
        const cases = outbreaks[outbreak]
        await godata.activateOutbreakForUser(user.userId, outbreak)
        await Promise.all(R.map(case_ => godata.createOutbreakCase(outbreak, R.dissoc('outbreak', case_)), cases))
      }
    }
  )
}

module.exports = { copyCases }

