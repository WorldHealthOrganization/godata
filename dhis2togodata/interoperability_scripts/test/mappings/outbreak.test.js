
const R = require('ramda')
const { v4: uuid } = require('uuid')

const outbreakMappings = require('../../mappings/outbreak')
const config = require('../../config')
const constants = require('../../config/constants')

test('outbreakMappings.createOutbreakMapping', () => {
  const model = {
    orgUnit: {
      id: uuid(),
      name: 'Trainingland',
      level: 1,
      noise: uuid() 
    },
    mergedLocationsIDs: [ uuid(), uuid() ],
    trackedEntities: [
      { id: uuid(), created: '02-05-2020' },
      { id: uuid(), created: '03-05-2020' }
    ]
  }

  const testConfig = R.mergeDeepRight(config, {
    countries: [ 'Trainingland' ]
  })

  expect(outbreakMappings.createOutbreakMapping(config)(model)).toStrictEqual({
    ...config.outbreakConfig,
    name: model.orgUnit.name,
    disease: constants.disease(config.disease),
    startDate: '02-05-2020',
    endDate: null,
    countries: [ { id: constants.country(config.countries[0]) } ],
    locationIds: [ model.orgUnit.id, ...model.mergedLocationsIDs ],
    reportingGeographicalLevelId: constants.geographicalLevelId(model.orgUnit.level),
    generateFollowUpsTeamAssignmentAlgorithm: constants.followupAssignmentAlgorithm(0),
    caseInvestigationTemplate: [],
    contactFollowUpTemplate: [],
    labResultsTemplate: [],
    arcGisServers: []
  })
})

