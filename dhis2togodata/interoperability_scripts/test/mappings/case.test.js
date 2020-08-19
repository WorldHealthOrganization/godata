
const { v4: uuid } = require('uuid')

const caseMappings = require('../../mappings/case')
const config = require('../../config')
const constants = require('../../config/constants')

test('caseMappings.trackedEntityToCase', () => {
  const model = {
    outbreak: uuid(),
    orgUnit: uuid(),
    created: '01-08-20',
    caseClassification: 'suspect',
    attributes: [
      { attribute: config.dhis2KeyAttributes.firstName, value: '__name__' },
      { attribute: config.dhis2KeyAttributes.surname, value: '__surname__' },
      { attribute: config.dhis2KeyAttributes.sex, value: '__sex__' },
      { attribute: config.dhis2KeyAttributes.address, value: '__address__' },
      { attribute: config.dhis2KeyAttributes.dateOfBirth, value: '__dob__' }
    ]
  }

  expect(caseMappings.trackedEntityToCase(config)(model)).toStrictEqual({
    outbreak: model.outbreak,
    firstName: '__name__',
    lastName: '__surname__',
    gender: constants.gender('__sex__'),
    ocupation: constants.ocupation(),
    dateOfReporting: model.created,
    riskLevel: constants.riskLevel(),
    vaccinesReceived: [],
    documents: [],
    addresses: [{
      typeID: constants.addressTypeID,
      locationId: model.orgUnit,
      address: '__address__'
    }],
    classification: constants.caseClassification('suspect'),
    dateRanges: [],
    questionnaireAnswers: {},
    dateOfBirth: '__dob__',
    dob: null
  })
})

