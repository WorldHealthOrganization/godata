
const { v4: uuid } = require('uuid')

const API = require('../index.js')
const { autoLogin } = require('../src/middleware')
const ENDPOINTS = require('../config/endpoints')

test('API is created correctly', () => {
  const { APIConfig, api } = createAPI()
  expect(api.baseURL).toBe(APIConfig.baseURL)
  expect(api.credentials.email).toBe(APIConfig.credentials.email)
  expect(api.credentials.password).toBe(APIConfig.credentials.password)
  expect(api._base.baseURL).toBe(APIConfig.baseURL)
})

test('API createRequest should add extra info to config', () => {
  const { APIConfig, api } = createAPI()
  const request = api.createRequest({})
  expect(request.api).toBe(api)
  expect(request.token).toBe(undefined)
})

test('login with api credentials', loginTest(null))

test('login with other credentials', loginTest({ email: uuid(), password: uuid() }))

test('Get users', simpleRouteTest({
  apiHandler: 'getUsers',
  path: ENDPOINTS.USERS.USERS
}))

test('Get locations', simpleRouteTest({
  apiHandler: 'getLocations',
  path: ENDPOINTS.LOCATIONS.LOCATIONS
}))

test('Create location', simpleRouteTest({
  apiHandler: 'createLocation',
  path: ENDPOINTS.LOCATIONS.CREATE_LOCATION,
  verb: 'post',
  body: '__body__',
  requestConfig: { body: '__body__' }
}))

test('Delete location', simpleRouteTest({
  apiHandler: 'deleteLocation',
  path: ENDPOINTS.LOCATIONS.DELETE_LOCATION,
  verb: 'delete',
  id: uuid()
}))

test('Get outbreaks', simpleRouteTest({
  apiHandler: 'getOutbreaks',
  path: ENDPOINTS.OUTBREAKS.OUTBREAKS
}))

test('Create outbreak', simpleRouteTest({
  apiHandler: 'createOutbreak',
  path: ENDPOINTS.OUTBREAKS.CREATE_OUTBREAK,
  verb: 'post',
  body: '__outbreak__',
  requestConfig: { body: '__outbreak__' }
}))

test('Delete outbreak', async () => {
  const returnValue = uuid()
  const outbreakID = uuid()
  const userID = uuid()
  const get = jest.fn().mockReturnValue(Promise.resolve([
    { id: userID, activeOutbreakId: outbreakID } ]))
  const patch = jest.fn().mockReturnValue(Promise.resolve())
  const delete_ = jest.fn().mockReturnValue(returnValue)
  const base = { get, patch, delete: delete_ }
  const { api } = createAPI(base)
  const id = uuid()

  const response = await api.deleteOutbreak(outbreakID)

  expect(response).toBe(returnValue)
  expect(get).toHaveBeenCalledWith(ENDPOINTS.USERS.USERS(), {
    api,
    token: undefined,
    middleware: [ autoLogin ]
  })
  expect(patch).toHaveBeenCalledWith(ENDPOINTS.USERS.PATCH_USER(userID), {
    api,
    token: undefined,
    middleware: [ autoLogin ],
    body: { activeOutbreakId: null }
  })
  expect(delete_).toHaveBeenCalledWith(ENDPOINTS.OUTBREAKS.DELETE_OUTBREAK(outbreakID), {
    api,
    token: undefined,
    middleware: [ autoLogin ]
  })
})

test('Activate outbreak for user', simpleRouteTest({
  apiHandler: 'activateOutbreakForUser',
  path: ENDPOINTS.USERS.PATCH_USER,
  verb: 'patch',
  id: uuid(),
  body: '__outbreakID__',
  requestConfig: { body: { activeOutbreakId: '__outbreakID__' } }
}))

test('Remove active outbreak from user', simpleRouteTest({
  apiHandler: 'removeActiveOutbreakFromUser',
  path: ENDPOINTS.USERS.PATCH_USER,
  verb: 'patch',
  id: uuid(),
  requestConfig: { body: { activeOutbreakId: null } }
}))

test('Get outbreak\'s cases', simpleRouteTest({
  apiHandler: 'getOutbreakCases',
  path: ENDPOINTS.CASES.OUTBREAK_CASES,
  id: uuid()
}))

test('Get outbreak case', async () => {
  const mockReturnValue = uuid()
  const mock = jest.fn().mockReturnValue(Promise.resolve(mockReturnValue))
  const base = { get: mock }
  const outbreakID = uuid()
  const caseID = uuid()
  const { api } = createAPI(base)

  const response = await api.getOutbreakCase(outbreakID, caseID)

  expect(response).toStrictEqual(mockReturnValue)
  expect(mock).toHaveBeenCalledWith(ENDPOINTS.CASES.OUTBREAK_CASE(outbreakID, caseID), {
    api,
    token: undefined,
    middleware: [ autoLogin ]
  })
})

test('Create outbreak case', simpleRouteTest({
  apiHandler: 'createOutbreakCase',
  path: ENDPOINTS.CASES.CREATE_OUTBREAK_CASE,
  verb: 'post',
  id: uuid(),
  body: '__case__',
  requestConfig: { body: '__case__' }
}))

test('Get outbreak case', async () => {
  const mockReturnValue = uuid()
  const mock = jest.fn().mockReturnValue(Promise.resolve(mockReturnValue))
  const base = { delete: mock }
  const outbreakID = uuid()
  const caseID = uuid()
  const { api } = createAPI(base)

  const response = await api.deleteOutbreakCase(outbreakID, caseID)

  expect(response).toStrictEqual(mockReturnValue)
  expect(mock).toHaveBeenCalledWith(ENDPOINTS.CASES.OUTBREAK_CASE(outbreakID, caseID), {
    api,
    token: undefined,
    middleware: [ autoLogin ]
  })
})

function simpleRouteTest ({
  apiHandler,
  path,
  verb = 'get',
  body,
  id,
  requestConfig = {}
} = {}) {
  return async () => {
    const mockReturnValue = uuid()
    const mock = jest.fn().mockReturnValue(Promise.resolve(mockReturnValue))
    const base = { [verb]: mock }
    const { api } = createAPI(base)

    const response = body == null
      ? id == null
        ? await api[apiHandler]()
        : await api[apiHandler](id)
      : id == null
        ? await api[apiHandler](body)
        : await api[apiHandler](id, body)

    expect(response).toStrictEqual(mockReturnValue)
    expect(mock).toHaveBeenCalledWith(id != null ? path(id) : path(), {
      api,
      token: undefined,
      middleware: [ autoLogin ],
      ...requestConfig
    })
  }
}

function loginTest (credentials) {
  return async () => {
    const loginResponse = { id: uuid(), ttl: 600 }
    const post = jest.fn().mockReturnValue(loginResponse)
    const base = { post }
    const date = Date.now()
    const { APIConfig, api } = createAPI(base, {
      now: () => date
    }, credentials)

    const request = {
      body: credentials != null ? credentials : APIConfig.credentials,
      api,
      token: undefined
    }

    const response = await api.login()

    expect(post).toHaveBeenCalledWith(ENDPOINTS.USERS.LOGIN(), request)
    expect(response).toBe(loginResponse)
    expect(api.token).toStrictEqual({
      value: loginResponse.id,
      ttl: loginResponse.ttl,
      lastRefresh: date
    })
  }
}

function createAPI (base, _Date, credentials) {
  const APIConfig = {
    baseURL: uuid(),
    credentials: { email: uuid(), password: uuid() }
  }

  if (base != null) {
    APIConfig._base = base
  }

  if (_Date != null) {
    APIConfig._Date = _Date
  }

  if (credentials != null) {
    APIConfig.credentials = credentials
  }

  const api = new API(APIConfig)
  
  return { APIConfig, api }
}

