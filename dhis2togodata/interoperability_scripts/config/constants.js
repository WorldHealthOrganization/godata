
const config = require('./')

module.exports = {
  geographicalLevelId: (_) => `LNG_REFERENCE_DATA_CATEGORY_LOCATION_GEOGRAPHICAL_LEVEL_ADMIN_LEVEL_${Number(_) - 1}`,
  followupAssignmentAlgorithm: (index) => `LNG_REFERENCE_DATA_CATEGORY_FOLLOWUP_GENERATION_TEAM_ASSIGNMENT_ALGORITHM_${
    config.followupAssignmentAlgorithms[index]}`,
  disease: (_ = '') => `LNG_REFERENCE_DATA_CATEGORY_DISEASE_${_.toUpperCase()}`,
  country: (country) => `LNG_REFERENCE_DATA_CATEGORY_COUNTRY_${country.toUpperCase()}`,
  gender: (gender = 'NONE') => `LNG_REFERENCE_DATA_CATEGORY_GENDER_${gender.toUpperCase()}`,
  ocupation: (ocupation = 'UNKNOWN') => `LNG_REFERENCE_DATA_CATEGORY_OCCUPATION_${ocupation.toUpperCase()}`,
  riskLevel: (level = 'NONE') => `LNG_REFERENCE_DATA_CATEGORY_RISK_LEVEL_${level.toUpperCase()}`,
  addressTypeID: 'LNG_REFERENCE_DATA_CATEGORY_ADDRESS_TYPE_USUAL_PLACE_OF_RESIDENCE',
  caseClassification: (classification = 'SUSPECT') => `LNG_REFERENCE_DATA_CATEGORY_CASE_CLASSIFICATION_${classification.toUpperCase()}`,
  OUTBREAK_CREATION_MODE: {
    GROUP: 0,
    EXPAND: 1
  }
}

