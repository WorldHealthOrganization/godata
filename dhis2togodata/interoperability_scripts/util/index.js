
const R = require('ramda')

const getIDFromDisplayName = R.curry((arr, displayName) => {
  return R.pipe(
    R.find(R.propEq('displayName', displayName)),
    R.prop('id')
  )(arr)
})

const completeSchema = R.curry((schema, model) => {
  const completedSchema = {}

  if (typeof schema === 'object') {
    for (let prop in schema) {
      if (typeof schema[prop] === 'function') {
        completedSchema[prop] = schema[prop](model)
      } else if (schema[prop] == null) {
        completedSchema[prop] = schema[prop]
      } else if (R.is(Array, schema[prop])) {
        completedSchema[prop] = R.map(completeSchema(R.__, model), schema[prop])
      } else if (R.is(Date, schema[prop])) {
        completedSchema[prop] = schema[prop]
      } else if (typeof schema[prop] === 'object') {
        completedSchema[prop] = completeSchema(schema[prop], model)
      } else {
        completedSchema[prop] = schema[prop]
      }
    }
    return completedSchema
  } else {
    return completeSchema({ schema }, model).schema
  }
})

module.exports = { getIDFromDisplayName, completeSchema }

