
const fs = require('fs')

const R = require('ramda')

const { organisationUnitToLocation } = require('../mappings/location')

const stringify = JSON.stringify.bind(JSON)

const copyOrganisationUnits = (dhis2, godata, config, _ = { fs, stringify }) =>
  async (outputFile) => {
  const organisationUnits = await dhis2.getOrganisationUnitsFromParent(config.rootID)
  const locations = await sendLocationsToGoData(config, organisationUnits)
  _.fs.writeFileSync(outputFile, _.stringify(locations))
}

// HELPERS

function adaptLocationToHierarchy (location) {
  return {
    location: R.dissoc('children', location),
    children: R.map(adaptLocationToHierarchy, location.children)
  }
}

function createLocationHierarchy (config) {
  return (locations) => {
    if (locations.length === 0) return {}

    const rootID = config.rootID
    const indexedLocations = R.reduce((acc, location) => R.assoc(location.id, location, acc), {}, locations)
    return R.pipe(
      R.sortBy(R.prop('level')),
      R.reverse,
      R.reduce((indexedLocations, location) => {
        const parentID = R.prop('parentLocationId', location)
        if (parentID != null) {
          const parent = R.prop(parentID, indexedLocations)
          parent.children.push(location)
        }
        return indexedLocations
      }, indexedLocations),
      R.prop(rootID),
      adaptLocationToHierarchy
    )(locations)
  }
}

function sendLocationsToGoData (config, organisationUnits) {
  return R.pipe(
    R.map(organisationUnitToLocation),
    createLocationHierarchy(config),
    _ => [_]
  )(organisationUnits)
}

module.exports = { copyOrganisationUnits }

