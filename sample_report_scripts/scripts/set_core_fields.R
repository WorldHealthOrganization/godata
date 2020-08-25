# script to define all required columns for cases and contacts

# this is necessary because JSON output drops columns where there were 0 observations
# not ideal if data completion varies heavily across deployments



case_columns <- c(
  "id",
  "visualId",
  "addresses_locationId",
  "addresses_geoLocation.lat",
  "addresses_geoLocation.lng",
  "addresses_addressLine1",
  "addresses_postalCode",
  "addresses_city",
  "addresses_phoneNumber",
  "firstName",
  "lastName",
  "gender",
  "age.years",
  "age.months",
  "occupation",
  "classification",
  "outcomeId",
  "pregnancyStatus",
  "wasContact",
  "dateOfReporting",
  "createdAt",
  "dateOfOnset",
  "dateOfOutcome",
  "dateOfLastContact",
  "dateBecomeCase",
  "isDateOfOnsetApproximate",
  "dateRanges_typeId",
  "dateRanges_locationId",
  "dateRanges_startDate",
  "dateRanges_endDate",
  "dateRanges_centerName",
  "transferRefused",
  "riskLevel",
  "riskReason",
  "hasRelationships",
  "deleted"
)


###############################################################

contact_columns <- c(
  "id",
  "visualId",
  "active",
  "followUp.status",
  "followUpTeamId",
  "addresses_locationId",
  "addresses_geoLocation.lat",
  "addresses_geoLocation.lng",
  "addresses_addressLine1",
  "addresses_postalCode",
  "addresses_city",
  "addresses_phoneNumber",
  "firstName",
  "lastName",
  "gender",
  "age.years",
  "age.months",
  "occupation",
  "pregnancyStatus",
  "wasCase",
  "dateOfReporting",
  "createdAt",
  "dateOfLastContact",
  "followUp.startDate",
  "followUp.endDate",
  "riskLevel",
  "riskReason",
  "deleted"
  
  )

