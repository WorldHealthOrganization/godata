
module.exports = {
  GoDataAPIConfig: {
    baseURL: 'http://localhost:8000/api',
    credentials: {
      email: 'test@who.int',
      password: '123412341234'
    }
  },
  DHIS2APIConfig: {
    baseURL: 'https://covid19.dhis2.org/demo/api',
    credentials: {
      user: 'COVID',
      password: 'StopCovid19!'
    },
    debug: true
  },
  countries: [ 'Trainingland' ],
  rootID: 'GD7TowwI46c'
}

