
const R = require('ramda')

const base = require('./config.base')
const prod = require('./config')
const dev = require('./config.dev')

const env = process.env.NODE_ENV

module.exports = R.pipe(
  R.mergeDeepLeft(env === 'dev' ? dev : {}),
  R.mergeDeepLeft(env !== 'dev' ? prod : {})
)(base)

