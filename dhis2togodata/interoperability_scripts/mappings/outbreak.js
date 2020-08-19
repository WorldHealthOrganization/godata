
const R = require('ramda')

const { completeSchema } = require('../util')
const { geographicalLevelId, disease, followupAssignmentAlgorithm, country } = require('../config/constants')
const config = require('../config')

const outbreakNameSelector = R.path(['orgUnit', 'name'])
const outbreakStartDateSelector = R.pipe(
  R.prop('trackedEntities'),
  R.sortBy(R.prop('created')),
  R.map(R.prop('created')),
  R.prop(0)
)
const outbreakCountriesSelector = R.map(_ => ({ id: country(_) }))
const outbreakLocationIDsSelector = _ =>
  R.prepend(R.path(['orgUnit', 'id'], _), R.prop('mergedLocationsIDs', _))
const outbreakReportingGeographicalLevelIdSeletor = R.pipe(
  R.path([ 'orgUnit', 'level' ]),
  geographicalLevelId)

const createOutbreakMapping = (config, _ = { Date }) => completeSchema({
  ...config.outbreakConfig,
  name: outbreakNameSelector,
  disease: disease(config.disease),
  startDate: R.pipe(outbreakStartDateSelector, R.defaultTo(_.Date())),
  endDate: null,
  countries: R.map(_ => ({ id: country(_) }), config.countries),
  locationIds: outbreakLocationIDsSelector,
  reportingGeographicalLevelId: outbreakReportingGeographicalLevelIdSeletor,
  generateFollowUpsTeamAssignmentAlgorithm: followupAssignmentAlgorithm(0),
  caseInvestigationTemplate: () => [],
  contactFollowUpTemplate: () => [],
  labResultsTemplate: () => [],
  arcGisServers: () => []
})

module.exports = { createOutbreakMapping }

