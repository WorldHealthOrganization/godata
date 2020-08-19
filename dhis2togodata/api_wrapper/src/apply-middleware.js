
// Third-party libraries
const R = require('ramda')

module.exports = function applyMiddleware (middleware, method, path, config, base) {
  const next = (middleware) => (err, ctx) => {
    if (err == null) {
      if (middleware.length > 0) {
        return middleware[0](next(R.slice(1, middleware.length, middleware)), ctx)
      } else {
        return base._request(method, path, ctx.config)
      }
    } else {
      throw err
    }
  }

  const ctx = { method, path, config, base }

  return next(middleware)(null, ctx)
}

