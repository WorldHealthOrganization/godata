
const R = require('ramda')

const caseActions = require('../../actions/case')
const config = require('../../config')
const constants = require('../../config/constants')

const {
  orgUnits,
  programs,
  programStages,
  dataElements,
  attributes,
  trackedEntities,
  outbreaks,
  user
} = require('../test-util/mocks')

const resolve = Promise.resolve.bind(Promise)

test('caseActions.copyCases', async () => {
  const getPrograms = jest.fn().mockReturnValue(resolve(programs))
  const getProgramStages = jest.fn().mockReturnValue(resolve(programStages))
  const getDataElements = jest.fn().mockReturnValue(resolve(dataElements))
  const getTrackedEntitiesAttributes = jest.fn().mockReturnValue(resolve(attributes))
  const getOrganisationUnitsFromParent = jest.fn().mockReturnValue(resolve(orgUnits))
  const getOutbreaks = jest.fn().mockReturnValue(resolve(outbreaks))
  const login = jest.fn().mockReturnValue(resolve(user))
  const activateOutbreakForUser = jest.fn()
  const createOutbreakCase = jest.fn()
  const loadTrackedEntityInstances = jest.fn().mockReturnValue(resolve(trackedEntities))
  
  const dhis2 = {
    getPrograms,
    getProgramStages,
    getDataElements,
    getTrackedEntitiesAttributes,
    getOrganisationUnitsFromParent
  }
  const godata = {
    getOutbreaks,
    login,
    activateOutbreakForUser,
    createOutbreakCase
  }

  await caseActions.copyCases(dhis2, godata, config, {
    loadTrackedEntityInstances
  })()

  expect(getPrograms).toHaveBeenCalledWith()
  expect(getProgramStages).toHaveBeenCalledWith()
  expect(getDataElements).toHaveBeenCalledWith()
  expect(getTrackedEntitiesAttributes).toHaveBeenCalledWith()
  expect(getOrganisationUnitsFromParent).toHaveBeenCalledWith(config.rootID)
  expect(loadTrackedEntityInstances).toHaveBeenCalledWith(dhis2, orgUnits, programs[0].id)
  expect(getOutbreaks).toHaveBeenCalledWith()
  expect(login).toHaveBeenCalledWith()
  expect(login).toHaveBeenCalledTimes(1)
  expect(activateOutbreakForUser).toHaveBeenCalledTimes(1)
  expect(activateOutbreakForUser).toHaveBeenCalledWith(user.userId, outbreaks[0].id)
  expect(createOutbreakCase).toHaveBeenCalledTimes(3)
  expect(createOutbreakCase).toHaveBeenNthCalledWith(
    1,
    outbreaks[0].id,
    case_(trackedEntities[0][0], {
      classification: constants.caseClassification('confirmed')
    })
  )
  expect(createOutbreakCase).toHaveBeenNthCalledWith(
    2,
    outbreaks[0].id,
    case_(trackedEntities[1][0], {
      classification: constants.caseClassification('probable')
    })
  )
  expect(createOutbreakCase).toHaveBeenNthCalledWith(
    3,
    outbreaks[0].id,
    case_(trackedEntities[3][0], {
      classification: constants.caseClassification('NOT_A_CASE_DISCARDED')
    })
  )
})

function case_ (te, base) {
  return R.mergeDeepLeft(base, {
    firstName: te.attributes[0].value,
    lastName: te.attributes[1].value,
    gender: constants.gender(te.attributes[2].value),
    ocupation: constants.ocupation(),
    dateOfReporting: te.created,
    riskLevel: constants.riskLevel(),
    vaccinesReceived: [],
    documents: [],
    addresses: [{
      typeID: constants.addressTypeID,
      locationId: te.orgUnit,
      address: te.attributes[3].value
    }],
    dateRanges: [],
    questionnaireAnswers: {},
    dateOfBirth: te.attributes[4].value,
    dob: null
  })
}

