
const R = require('ramda')
const { v4: uuid } = require('uuid')

const locationActions = require('../../actions/location')
const config = require('../../config')
const constants = require('../../config/constants')

const { orgUnits } = require('../test-util/mocks')

const prop = R.curry((prop, i) => R.path([i, prop], orgUnits))
const id = prop('id')
const parentLocationId = R.pipe(prop('parent'), R.prop('id'))
const name = prop('name')
const GEOLOCATION = { lat: 0, lng: 0 }
const geographicalLevelId = R.pipe(prop('level'), constants.geographicalLevelId)
const updatedAt = prop('lastUpdated')
const createdAt = prop('created')
const location = i => ({
  id: id(i),
  parentLocationId: parentLocationId(i),
  name: name(i),
  geoLocation: { lat: 0, lng: 0 },
  geographicalLevelId: geographicalLevelId(i),
  updatedAt: updatedAt(i),
  createdAt: createdAt(i),
  active: true,
  deleted: false,
  identifiers: [],
  synonyms: []
})

// WARNING -> the order in children is important for the test to pass
// TODO -> find a way to do this with a consistent order
test('locationActions.copyOrganisationUnits', async () => {
  const stringify = R.identity
  const writeFileSync = jest.fn()
  const fs = { writeFileSync }
  const getOrganisationUnitsFromParent = jest.fn().mockReturnValue(orgUnits)
  const dhis2 = { getOrganisationUnitsFromParent }
  const godata = {}
  const outputFile = uuid()
  
  await locationActions.copyOrganisationUnits(
    dhis2, godata, config, { fs, stringify })(outputFile)

  expect(getOrganisationUnitsFromParent).toHaveBeenCalledWith(config.rootID)
  const expected = [{
    location: location(0),
    children: [
      { location: location(2), children: [] },
      {
        location: location(1),
        children: [ { location: location(3), children: [] } ]
      }
    ]
  }]
})

