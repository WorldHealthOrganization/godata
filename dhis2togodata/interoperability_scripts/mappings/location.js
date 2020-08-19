
const R = require('ramda')

const { completeSchema } = require('../util')
const { geographicalLevelId } = require('../config/constants')

const locationNameSelector = R.prop('name')
//const locationSynonymsSelector = R.pipe(R.prop('shortName'), _ => [ _ ]) // if name == shortName, don't add synonym
const locationParentIDSelector = R.path(['parent', 'id'])
const locationIDSelector = R.prop('id')
const locationGeoLocationSelector = _ => ({ lat: 0, lng: 0 })
const locationGeographicalLevelIDSelector = R.pipe(R.prop('level'), geographicalLevelId)
const locationUpdatedAtSelector = R.prop('lastUpdated')
const locationCreatedAtSelector = R.prop('created')

const organisationUnitToLocation = completeSchema({
  id: locationIDSelector,
  parentLocationId: locationParentIDSelector,
  name: locationNameSelector,
  //syonyms: locationSynonymsSelector,
  geoLocation: locationGeoLocationSelector,
  //populationDensity: 0,
  geographicalLevelId: locationGeographicalLevelIDSelector,
  updatedAt: locationUpdatedAtSelector,
  createdAt: locationCreatedAtSelector,
  active: true,
  deleted: false,
  identifiers: _ => [],
  synonyms: _ => [],
  children: _ => []
})

module.exports = { organisationUnitToLocation }

