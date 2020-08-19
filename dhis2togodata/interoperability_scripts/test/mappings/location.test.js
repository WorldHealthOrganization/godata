
const { v4: uuid } = require('uuid')

const locationMappings = require('../../mappings/location')
const constants = require('../../config/constants')

test('locationMappings.organisationUnitToLocation', () => {
  const model = {
    id: uuid(),
    parent: { id: uuid() },
    name: 'Trainingland',
    level: 1,
    lastUpdated: new Date().toString(),
    created: new Date().toString(),
    noise: uuid()
  }

  expect(locationMappings.organisationUnitToLocation(model)).toStrictEqual({
    id: model.id,
    parentLocationId: model.parent.id,
    name: model.name,
    geoLocation: { lat: 0, lng: 0 },
    geographicalLevelId: constants.geographicalLevelId(1),
    updatedAt: model.lastUpdated,
    createdAt: model.created,
    active: true,
    deleted: false,
    identifiers: [],
    synonyms: [],
    children: []
  })
})

