
const { v4: uuid } = require('uuid')
const R = require('ramda')

const applyMiddleware = require('../src/apply-middleware')

test('applyMiddleware should export a function', () => {
  expect(typeof applyMiddleware).toBe('function')
})

test('applyMiddleware creation without middlewares should call the api', () => {
  const middlewares = []
  const method = 'GET'
  const path = '/'
  const config = { foo: uuid() }
  const MOCK_RETURN = uuid()
  const base = { _request: jest.fn().mockReturnValue(MOCK_RETURN) }

  const response = applyMiddleware(middlewares, method, path, config, base)
  
  expect(response).toBe(MOCK_RETURN)
  expect(base._request).toHaveBeenCalledWith(method, path, config)
})

test('applyMiddleware with middlewares should go through them and call the api', () => {
  const firstMiddleware = (next, ctx) => {
    ctx.config.foo++
    return next(null, ctx)
  }

  const secondMiddleware = (next, ctx) => {
    ctx.config.foo++
    return next(null, ctx)
  }
  const middlewares = [ firstMiddleware, secondMiddleware ]
  const method = 'GET'
  const path = '/'
  const config = { foo: 0, bar: uuid() }
  const MOCK_RETURN = uuid()
  const base = { _request: jest.fn().mockReturnValue(MOCK_RETURN) }

  const response = applyMiddleware(middlewares, method, path, R.clone(config), base)

  expect(response).toBe(MOCK_RETURN)
  expect(base._request).toHaveBeenCalledWith(method, path, R.assoc('foo', 2, config))
})

test('applyMiddleware can trhows errors', () => {
  const middleware = (next, ctx) => {
    throw 'error'
  }

  const middlewares = [ middleware ]

  try {
    applyMiddleware(middlewares, 'GET', '/', {}, {})
  } catch (error) {
    expect(error).toMatch('error')
  }
})

