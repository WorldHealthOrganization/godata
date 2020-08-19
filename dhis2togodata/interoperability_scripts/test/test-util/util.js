
const R = require('ramda')
const { v4: uuid } = require('uuid')

function createUUIDs () {
  const uuids = {}
  return (key) => {
    if (uuids[key] != null) {
      return uuids[key]
    } else {
      uuids[key] = uuid()
      return uuids[key]
    }
  }
}

module.exports = {
  createUUIDs
}

