
const { v4: uuid } = require('uuid')
const R = require('ramda')

const { autoLogin } = require('../src/middleware')

const basicCTX = {
  config: {
    query: {},
    token: null
  }
}

const createToken = (date) => ({
  value: uuid(),
  ttl: 600,
  lastRefresh: date || Date.now()
})

test('autoLogin, valid token => change query and continue', async () => {
  const MOCK_RESPONSE_VALUE = uuid()
  const next = jest.fn().mockReturnValue(MOCK_RESPONSE_VALUE)
  
  const token = createToken()
  const ctx = R.assocPath(['config', 'token'], token, basicCTX)

  const response = await autoLogin(next, ctx)

  expect(response).toBe(MOCK_RESPONSE_VALUE)
  expect(next).toHaveBeenCalledWith(null,
    R.assocPath(['config', 'query', 'access_token'], token.value, ctx))
})

test('autoLogin, no token => login and continue', wrongTokenTest(null))

test('autoLogin, token expired => login and continue',
  wrongTokenTest(createToken(Date.now() - 601 * 1000)))

test('autoLogin, on login error catch and pass next', async () => {
  const MOCK_RESPONSE_VALUE = uuid()
  const next = jest.fn().mockReturnValue(MOCK_RESPONSE_VALUE)
  
  const error = new Error('test error')
  const api = { login: jest.fn().mockRejectedValue(error) }
  const ctx = R.assocPath(['config', 'api'], api, basicCTX)

  const response = await autoLogin(next, ctx)

  expect(response).toBe(MOCK_RESPONSE_VALUE)
  expect(api.login).toHaveBeenCalled()
  expect(next).toHaveBeenCalledWith(error)
})

function wrongTokenTest (token) {
  return async () => {
    const MOCK_RESPONSE_VALUE = uuid()
    const next = jest.fn().mockReturnValue(MOCK_RESPONSE_VALUE)
    const newToken = createToken()
    const loginResponse = Promise.resolve({
      id: newToken.value,
      ttl: newToken.ttl,
      foo: 'bar'
    })
    const api = { login: jest.fn().mockReturnValue(loginResponse) }
    const ctx = R.assocPath(['config', 'api'], api, basicCTX)
    const responseCTX = R.pipe(
      R.assocPath(['config', 'token'], newToken),
      R.assocPath(['config', 'query', 'access_token'], newToken.value)
    )(ctx)

    // injection of lastRefresh to mock the dependency on Date.now()
    const response = await autoLogin(next, ctx, { date: newToken.lastRefresh })
    expect(response).toBe(MOCK_RESPONSE_VALUE)
    expect(api.login).toHaveBeenCalled()
    expect(next).toHaveBeenCalledWith(null, responseCTX)
  }
}

