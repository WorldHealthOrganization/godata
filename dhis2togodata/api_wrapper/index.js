
// Thrid-party libraries
const fetch = require('node-fetch')
const R = require('ramda')

// Project modules
const Base = require('./src/base')
const { autoLogin } = require('./src/middleware')
const ENDPOINTS = require('./config/endpoints')

module.exports = class {
  constructor (opts = {}) {
    this.baseURL = opts.baseURL || ''
    this.credentials = opts.credentials || {}
    this.fetch = opts.fetch || fetch
    this._base = opts._base || new Base({ baseURL: this.baseURL, fetch: this.fetch })
    this._Date = opts._Date || Date
  }

  createRequest (config) {
    config.api = this
    config.token = this.token
    return config
  }

  async login (credentials = {}) {
    const email = credentials.email || this.credentials.email
    const password = credentials.password || this.credentials.password
    const request = this.createRequest({
      body: { email, password }
    })

    const response = await this._base.post(ENDPOINTS.USERS.LOGIN(), request)
    this.token = {
      value: response.id,
      ttl: response.ttl,
      lastRefresh: this._Date.now()
    }
    return response
  }

  getUsers () {
    const request = this.createRequest({
      middleware: [ autoLogin ]
    })
    return this._base.get(ENDPOINTS.USERS.USERS(), request)
  }

  getLocations () {
    const request = this.createRequest({
      middleware: [ autoLogin ]
    })
    return this._base.get(ENDPOINTS.LOCATIONS.LOCATIONS(), request)
  }

  createLocation (body) {
    const request = this.createRequest({
      middleware: [ autoLogin ],
      body
    })
    return this._base.post(ENDPOINTS.LOCATIONS.CREATE_LOCATION(), request)
  }

  deleteLocation (id) {
    const request = this.createRequest({
      middleware: [ autoLogin ]
    })
    return this._base.delete(ENDPOINTS.LOCATIONS.DELETE_LOCATION(id), request)
  }

  getOutbreaks () {
    const request = this.createRequest({
      middleware: [ autoLogin ]
    })
    return this._base.get(ENDPOINTS.OUTBREAKS.OUTBREAKS(), request)
  }

  createOutbreak (body) {
    const request = this.createRequest({
      middleware: [ autoLogin ],
      body
    })
    return this._base.post(ENDPOINTS.OUTBREAKS.CREATE_OUTBREAK(), request)
  }

  async deleteOutbreak (outbreakID) {
    const users = await this.getUsers()
    await Promise.all(R.map((user) => {
      if (user.activeOutbreakId === outbreakID) {
        return this.removeActiveOutbreakFromUser(user.id)
      }
    }, users))

    const request = this.createRequest({
      middleware: [ autoLogin ]
    })
    return this._base.delete(ENDPOINTS.OUTBREAKS.DELETE_OUTBREAK(outbreakID), request)
  }
 
  activateOutbreakForUser (userID, outbreakID) {
    const request = this.createRequest({
      middleware: [ autoLogin ],
      body: {
        activeOutbreakId: outbreakID
      }
    })
    return this._base.patch(ENDPOINTS.USERS.PATCH_USER(userID), request)
  }

  removeActiveOutbreakFromUser (userID) {
    const request = this.createRequest({
      middleware: [ autoLogin ],
      body: {
        activeOutbreakId: null
      }
    })
    return this._base.patch(ENDPOINTS.USERS.PATCH_USER(userID), request)
  }

  getOutbreakCases (outbreakID) {
    const request = this.createRequest({
      middleware: [ autoLogin ]
    })
    return this._base.get(ENDPOINTS.CASES.OUTBREAK_CASES(outbreakID), request)
  }

  getOutbreakCase (outbreakID, caseID) {
    const request = this.createRequest({
      middleware: [ autoLogin ]
    })
    return this._base.get(ENDPOINTS.CASES.OUTBREAK_CASE(outbreakID, caseID), request)
  }

  createOutbreakCase (outbreakID, case_) {
    const request = this.createRequest({
      middleware: [ autoLogin ],
      body: case_
    })
    return this._base.post(ENDPOINTS.CASES.CREATE_OUTBREAK_CASE(outbreakID), request)
  }

  deleteOutbreakCase (outbreakID, caseID) {
    const request = this.createRequest({
      middleware: [ autoLogin ]
    })
    return this._base.delete(ENDPOINTS.CASES.DELETE_OUTBREAK_CASE(outbreakID, caseID), request)
  }
}

