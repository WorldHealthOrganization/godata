
const R = require('ramda')

const { completeSchema } = require('../util')
const constants = require('../config/constants')

const caseOutbreakSelector = R.prop('outbreak')
const caseLocationIDSelector = R.prop('orgUnit')
const caseDateOfReportingSelector = R.prop('created')
const caseClassificationSelector = R.pipe(
  R.prop('caseClassification'),
  constants.caseClassification
)
const caseAttributeSelector = (attributeID) => R.pipe(
  R.prop('attributes'),
  R.find(R.propEq('attribute', attributeID)),
  R.prop('value'))

const trackedEntityToCase = (config) => completeSchema({
  outbreak: caseOutbreakSelector,
  firstName: caseAttributeSelector(config.dhis2KeyAttributes.firstName),
  lastName: caseAttributeSelector(config.dhis2KeyAttributes.surname),
  gender: R.pipe(caseAttributeSelector(config.dhis2KeyAttributes.sex), constants.gender),
  ocupation: constants.ocupation(),
  dateOfReporting: caseDateOfReportingSelector,
  riskLevel: constants.riskLevel(),
  vaccinesReceived: () => [],
  documents: () => [],
  addresses: [{
    typeID: constants.addressTypeID,
    locationId: caseLocationIDSelector,
    address: caseAttributeSelector(config.dhis2KeyAttributes.address)
  }],
  classification: caseClassificationSelector,
  dateRanges: [],
  questionnaireAnswers: {},
  dateOfBirth: caseAttributeSelector(config.dhis2KeyAttributes.dateOfBirth),
  dob: null
})

module.exports = { trackedEntityToCase }

