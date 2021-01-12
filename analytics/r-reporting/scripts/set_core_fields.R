# script to define all required columns for cases and contacts

# this is necessary because JSON output drops columns where there were 0 observations
# not ideal if data completion varies heavily across deployments

case_columns <- c(
  "firstName","gender","isDateOfOnsetApproximate","wasContact","outcomeId","safeBurial","classification",
  "riskLevel","riskReason","transferRefused","vaccinesReceived","pregnancyStatus","id","outbreakId",
  "visualId","lastName","dob","occupation","documents","dateOfReporting","isDateOfReportingApproximate",
  "dateOfLastContact","dateOfInfection","dateOfOnset","dateBecomeCase","classificationHistory","dateOfOutcome",
  "hasRelationships","relationshipsRepresentation","usualPlaceOfResidenceLocationId","createdAt","createdBy","updatedAt",
  "updatedBy","deleted","middleName","notDuplicatesIds","wasCase","active",
  "followUpHistory","age.years","age.months","followUp.originalStartDate","followUp.startDate","followUp.endDate",
  "followUp.status","addresses","dateRanges"
)


###############################################################

contact_columns <- c(
  "firstName","gender","riskLevel",
  "riskReason","safeBurial","wasCase",
  "active","vaccinesReceived","pregnancyStatus",
  "id","outbreakId","visualId",
  "middleName","lastName","dob",
  "occupation","documents","addresses",
  "dateOfReporting","isDateOfReportingApproximate","dateOfLastContact",
  "followUpHistory","followUpTeamId","hasRelationships",
  "relationshipsRepresentation","usualPlaceOfResidenceLocationId","createdAt",
  "createdBy","updatedAt","updatedBy",
  "deleted","age.years","age.months",
  "followUp.originalStartDate","followUp.startDate","followUp.endDate",
  "followUp.status"
  )


###############################################################

followups_columns <- c(
  'uuid',
  'date_of_followup',
  'contact_id',
  'contact_uuid',
  'person_id',
  'followup_status',
  'followup_number',
  'team_id',
  'date_of_data_entry',
  'location_id',
  'performed',
  'seen'
)


###############################################################

contacts_of_contacts_columns <- c(
  "firstName","gender","riskLevel","riskReason",
  "safeBurial","active","vaccinesReceived","pregnancyStatus",
  "id","outbreakId","visualId","middleName",
  "lastName","dob","occupation","documents",
  "addresses","dateOfReporting","isDateOfReportingApproximate","dateOfLastContact",
  "hasRelationships","relationshipsRepresentation","usualPlaceOfResidenceLocationId","createdAt",
  "createdBy","updatedAt","updatedBy","createdOn",
  "deleted","age.years","age.months"  
)


#############################################################

relationships_columns <- c(
  'uuid',
  'source_uuid',
  'source_visualid',
  'source_gender',
  'source_age',
  'target_uuid',
  'target_visualid',
  'target_gender',
  'target_age',
  'exposure_type',
  'context_of_exposure',
  'exposure_frequency',
  'certainty_level',
  'exposure_duration',
  'relation_detail',
  'cluster',
  'is_contact_date_estimated',
  'comment',
  'created_by',
  'date_of_data_entry'
)


###############################################################

lab_results_columns <- c(
  "personId",
  "personType",
  "dateSampleTaken",
  "dateSampleDelivered",
  "dateTesting",
  "dateOfResult",
  "labName",
  "sampleIdentifier",
  "sampleType",
  "testType",
  "result",
  "quantitativeResult",
  "status",
  "outbreakId",
  "testedFor",
  "createdAt",
  "createdBy",
  "updatedAt",
  "updatedBy",
  "deleted",
  "id",
  "questionnaireAnswers.lab_question_1",
  "person.type",
  "person.firstName",
  "person.wasContact",
  "person.safeBurial",
  "person.classification",
  "person.transferRefused",
  "person.vaccinesReceived",
  "person.outbreakId",
  "person.visualId",
  "person.lastName",
  "person.documents",
  "person.addresses",
  "person.dateOfReporting",
  "person.isDateOfReportingApproximate",
  "person.dateOfOnset",
  "person.dateRanges",
  "person.classificationHistory",
  "person.hasRelationships",
  "person.createdAt",
  "person.createdBy",
  "person.updatedAt",
  "person.updatedBy",
  "person.deleted",
  "person.relationshipsRepresentation",
  "person.dateOfLastContact",
  "person.dob",
  "person.dateBecomeCase",
  "person.dateOfInfection",
  "person.usualPlaceOfResidenceLocationId",
  "person.id",
  "person.questionnaireAnswers.case_question_1",
  "person.age.years",
  "person.age.months",
  "person.age.id"
)

###############################################################

events_columns <- c(
  "name",
  "outbreakId",
  "date",
  "createdAt",
  "updatedBy",
  "address.typeId",
  "address.postalCode",
  "address.date",
  "address.geoLocation.lng",
  "description",
  "dateOfReporting",
  "hasRelationships",
  "createdBy",
  "createdOn",
  "address.city",
  "address.locationId",
  "address.phoneNumber",
  "id",
  "isDateOfReportingApproximate",
  "usualPlaceOfResidenceLocationId",
  "updatedAt",
  "deleted",
  "address.addressLine1",
  "address.geoLocationAccurate",
  "address.geoLocation.lat"
  
)


###############################################################

locations_columns <- c(
  "location_id",
  "admin_level",
  "name",
  "code",
  "parent_location_id",
  "population_density",
  "lat",
  "long",
  "admin_0_location_id",
  "admin_0_admin_level",
  "admin_0_name",
  "admin_0_code",
  "admin_0_parent_location_id",
  "admin_0_population_density",
  "admin_0_lat",
  "admin_0_long"
)


###############################################################

users_columns <- c(
  'uuid',
  'firstname',
  'lastname',
  'email'
)



################################################################

address_columns <- c(
  "id",
  "addresses_typeid",
  "addresses_country",
  "addresses_city",
  "addresses_addressline1",
  "addresses_postalcode",
  "addresses_locationid",
  "addresses_geolocationaccurate",
  "addresses_date",
  "addresses_phonenumber",
  "addresses_emailaddress",
  "addresses_geolocation_lat",
  "addresses_geolocation_lng"
)
