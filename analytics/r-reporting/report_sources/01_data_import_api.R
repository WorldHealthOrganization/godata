###################################################################################################

url <- "https://sampleURL.int/"                   # <--------------------- insert instance url here, don't forget the slash at end !
username <- "username"                           # <--------------------- insert your username for signing into Go.Data webapp here
password <- "password"                           # <--------------------- insert your password for signing into Go.Data webapp here
outbreak_id <- "xxxxxx-xxxx-xxxx-xxxx-xxxxxxx"   # <--------------- insert your outbreak ID here! (find it in URL when you have selected outbreak)

###################################################################################################

# SCRIPT TO PULL IN COLLECTIONS ACROSS ANY GO.DATA INSTANCE #

###################################################################################################
# read in from Go.Data API, using your updated log-in credentials by Clicking "Source"
# no need to modify the below unless you would like to bring in additional API endpoints used in the dashboards in webapp, etc!
# Script authored and maintained by Go.Data team (godata@who.int): Sara Hollis (holliss@who.int); James Fuller (fullerj@who.int)
###################################################################################################

# this script currently returns: 
#                                     cases, 
#                                     contacts,
#                                     contacts of contacts,
#                                     events
#                                     follow ups, 
#                                     lab results,
#                                     locations,
#                                     relationships,
#                                     teams,
#                                     users

###################################################################################################
# source required scripts, including packages that need to be installed
#       this includes set_core_fields.R script, which ensures that collections have all the columns they need and set to NA those that don't exist
#       otherwise, the JSON drops it if these questions were consistently not answered, which can break the scripts if its a core variable
###################################################################################################

source(here::here("scripts", "aaa_load_packages.R"))
source(here::here("scripts", "set_core_fields.R"))

###################################################################################################
# get access token
###################################################################################################

url_request <- paste0(url,"api/oauth/token?access_token=123")

response <- POST(url=url_request,  
                 body = list(
                   username = username,                                          
                   password = password),                                       
                 encode = "json")

content <-
  content(response, as = "text") %>%
  fromJSON(flatten = TRUE) %>%
  glimpse()

access_token <- content$access_token                 ## this is your access token !!! that allows API calls

###################################################################################################
# specify date ranges, for follow up filters - if your volume of follow up gets too large 
#     see below commented out code in Follow Ups section for an example
#     date_now <- format(Sys.time(), "%Y-%m-%dT23:59:59.999Z")                  
#     date_21d_ago <- format((Sys.Date()-21), "%Y-%m-%dT23:59:59.999Z")
###################################################################################################

###################################################################################################
# IMPORT ALL RELEVANT API COLLECTIONS BELOW 
###################################################################################################

# import contact follow-ups (could filter last 21 days only to avoid system time-out)
response_followups <- GET(paste0(
  url,
  "api/outbreaks/",
  outbreak_id,
  "/follow-ups"
  # /?filter={%22where%22:{%22and%22:[{%22date%22:{%22between%22:[%22",
  # date_21d_ago,
  # "%22,%22",
  # date_now,
  # "%22]}}]}}"
    ),
  add_headers(Authorization = paste("Bearer", access_token, sep = " ")))
json_followups <- content(response_followups, as="text")
followups <- as_tibble(fromJSON(json_followups, flatten = TRUE)) 
rm(response_followups)



# import outbreak Cases 
response_cases <- GET(paste0(url,"api/outbreaks/",outbreak_id,"/cases"), 
                      add_headers(Authorization = paste("Bearer", access_token, sep = " "))
)
json_cases <- content(response_cases, as = "text")
cases <- as_tibble(fromJSON(json_cases, flatten = TRUE))
rm(response_cases)

# import oubtreak Contacts 
response_contacts <- GET(paste0(url,"api/outbreaks/",outbreak_id,"/contacts"), 
                         add_headers(Authorization = paste("Bearer", access_token, sep = " "))
)
json_contacts <- content(response_contacts, as = "text")
contacts <- as_tibble(fromJSON(json_contacts, flatten = TRUE))
rm(response_contacts)

# import oubtreak Events 
response_events <- GET(paste0(url,"api/outbreaks/",outbreak_id,"/events"), 
                         add_headers(Authorization = paste("Bearer", access_token, sep = " "))
)
json_events <- content(response_events, as = "text")
events <- as_tibble(fromJSON(json_events, flatten = TRUE))
rm(response_events)

# import oubtreak Contact of Contacts 
response_contacts_of_contacts <- GET(paste0(url,"api/outbreaks/",outbreak_id,"/contacts-of-contacts"), 
                       add_headers(Authorization = paste("Bearer", access_token, sep = " "))
)
json_contacts_of_contacts <- content(response_contacts_of_contacts, as = "text")
contacts_of_contacts <- as_tibble(fromJSON(json_contacts_of_contacts, flatten = TRUE))
rm(response_contacts_of_contacts)

# import oubtreak Lab Results 
response_lab_results <- GET(paste0(url,"api/outbreaks/",outbreak_id,"/lab-results/aggregate"), 
                                     add_headers(Authorization = paste("Bearer", access_token, sep = " "))
)
json_lab_results <- content(response_lab_results, as = "text")
lab_results <- as_tibble(fromJSON(json_lab_results, flatten = TRUE))
rm(response_lab_results)


# import outbreak Relationships
response_relationships <- GET(paste0(url,"api/outbreaks/",outbreak_id,"/relationships/export"), 
                              add_headers(Authorization = paste("Bearer", access_token, sep = " "))
)
json_relationships <- content(response_relationships, as = "text")
relationships <- as_tibble(fromJSON(json_relationships, flatten = TRUE))
rm(response_relationships)


# import location hierarchy (outbreak agnostic)
response_locations <- GET(paste0(url,"api/locations"), 
                          add_headers(Authorization = paste("Bearer", access_token, sep = " "))
)
json_locations <- content(response_locations, as = "text")
locations <- as_tibble(fromJSON(json_locations, flatten = TRUE))
rm(response_locations)


# import Teams (outbreak agnostic)
response_teams <- GET(paste0(url,"api/teams"), 
                      add_headers(Authorization = paste("Bearer", access_token, sep = " "))
)
json_teams <- content(response_teams, as = "text")
teams <- as_tibble(fromJSON(json_teams, flatten = TRUE))
rm(response_teams)

# import Users (outbreak agnostic)
response_users <- GET(paste0(url,"api/users"), 
                      add_headers(Authorization = paste("Bearer", access_token, sep = " "))
)
json_users <- content(response_users, as = "text")
users <- as_tibble(fromJSON(json_users, flatten = TRUE))
rm(response_users)


################################################################################################
# Create empty data frames if needed
################################################################################################

#Locations
if (nrow(locations) == 0) {
  locations <- data.frame(matrix(ncol=15))
  colnames(locations) <- c("name","identifiers","active","populationDensity","parentLocationId","geographicalLevelId","id","createdAt","createdBy","updatedAt","updatedBy","deleted","synonyms","geoLocation.lat","geoLocation.lng")
}

#Cases
if (nrow(cases)==0) {
  cols.cases <- c("firstName","gender","isDateOfOnsetApproximate","wasContact","outcomeId","safeBurial","classification","riskLevel","riskReason","transferRefused","vaccinesReceived","pregnancyStatus","id","outbreakId","visualId","lastName","dob","occupation","documents","dateOfReporting","isDateOfReportingApproximate","dateOfLastContact","dateOfInfection","dateOfOnset","dateBecomeCase","classificationHistory","dateOfOutcome","hasRelationships","relationshipsRepresentation","usualPlaceOfResidenceLocationId","createdAt","createdBy","updatedAt","updatedBy","deleted","middleName","notDuplicatesIds","wasCase","active","followUpHistory","age.years","age.months","followUp.originalStartDate","followUp.startDate","followUp.endDate","followUp.status")
  cases <- data.frame(matrix(ncol=length(cols.cases)))
  colnames(cases) <- cols.cases
  
  cols.cases_addresses <- c("typeId","country","city","addressLine1","postalCode","locationId","geoLocationAccurate","date","phoneNumber","emailAddress","geoLocation.lat","geoLocation.lng")
  cases_address_history <- data.frame(matrix(ncol=length(cols.cases_addresses)))
  colnames(cases_address_history) <- cols.cases_addresses
  cases <- cases %>% bind_cols(cases_address_history) %>% nest(addresses=cols.cases_addresses)
  
  cols.cases_hosp <- c("typeId","centerName","locationId","comments","startDate","endDate")
  cases_hosp <- data.frame(matrix(ncol=length(cols.cases_hosp)))
  colnames(cases_hosp) <- cols.cases_hosp
  cases <- cases %>% bind_cols(cases_hosp) %>% nest(dateRanges=cols.cases_hosp)
}

#Contacts
if (nrow(contacts)==0) {
  cols.contacts <- c("firstName","gender","riskLevel","riskReason","safeBurial","wasCase","active","vaccinesReceived","pregnancyStatus","id","outbreakId","visualId","middleName","lastName","dob","documents","dateOfReporting","isDateOfReportingApproximate","dateOfLastContact","followUpHistory","followUpTeamId","hasRelationships","relationshipsRepresentation","usualPlaceOfResidenceLocationId","createdAt","createdBy","updatedAt","updatedBy","deleted","age.years","age.months","followUp.originalStartDate","followUp.startDate","followUp.endDate","followUp.status")
  contacts <- data.frame(matrix(ncol=length(cols.contacts)))
  colnames(contacts) <- cols.contacts
  
  cols.contacts_addresses <- c("typeId","country","city","addressLine1","postalCode","locationId","geoLocationAccurate","date","phoneNumber","emailAddress","geoLocation.lat","geoLocation.lng")
  contacts_address_history <- data.frame(matrix(ncol=length(cols.contacts_addresses)))
  colnames(contacts_address_history) <- cols.contacts_addresses
  contacts <- contacts %>% bind_cols(contacts_address_history) %>% nest(addresses=cols.contacts_addresses)
}

#Follow-ups
if (nrow(followups)==0) {
  cols.followups <- c("contact.id","contact.visualId","date","statusId","index","teamId","outbreakId","targeted","createdAt","createdBy","updatedAt","updatedBy","deleted","personId","usualPlaceOfResidenceLocationId","id","createdOn","address.typeId","address.locationId","address.geoLocationAccurate","address.date","address.country","address.city","address.addressLine1","address.postalCode","address.phoneNumber","address.emailAddress","address.geoLocation.lat","address.geoLocation.lng")
  followups <- data.frame(matrix(ncol=length(cols.followups)))
  colnames(followups) <- cols.followups
}

#Teams
if (nrow(teams) == 0) {
  cols.teams <- c("name","userIds","locationIds","id","createdAt","createdBy","updatedAt","updatedBy","deleted","createdOn")
  teams <- data.frame(matrix(ncol=length(cols.teams)))
  colnames(teams) <- cols.teams 
} 

#Events
if (nrow(events)==0) {
  cols.events <- c("name","description","id","outbreakId","dateOfReporting","isDateOfReportingApproximate","date","hasRelationships","usualPlaceOfResidenceLocationId","createdAt","createdBy","updatedAt","updatedBy","createdOn","deleted","address.typeId","address.city","address.addressLine1","address.postalCode","address.locationId","address.geoLocationAccurate","address.date","address.phoneNumber","address.geoLocation.lat","address.geoLocation.lng")
  events <- data.frame(matrix(ncol=length(cols.events)))
  colnames(events) <- cols.events
  events$address.locationId <- as.character(events$address.locationId)
}

#Contacts of Contacts
if (nrow(contacts_of_contacts)==0) {
  cols.contacts_of_contacts <- c("firstName","gender","riskLevel","riskReason","safeBurial","active","vaccinesReceived","pregnancyStatus","id","outbreakId","visualId","middleName","lastName","dob","documents","dateOfReporting","isDateOfReportingApproximate","dateOfLastContact","hasRelationships","relationshipsRepresentation","usualPlaceOfResidenceLocationId","createdAt","createdBy","updatedAt","updatedBy","deleted","age.years","age.months")
  contacts_of_contacts <- data.frame(matrix(ncol=length(cols.contacts_of_contacts)))
  colnames(contacts_of_contacts) <- cols.contacts_of_contacts
  
  cols.contacts_of_contacts_addresses <- c("typeId","city","addressLine1","postalCode","locationId","geoLocationAccurate","date","phoneNumber","geoLocation.lat","geoLocation.lng")
  contacts_of_contacts_address_history <- data.frame(matrix(ncol=length(cols.contacts_of_contacts_addresses)))
  colnames(contacts_of_contacts_address_history) <- cols.contacts_of_contacts_addresses
  contacts_of_contacts <- contacts_of_contacts %>% bind_cols(contacts_of_contacts_address_history) %>% nest(addresses=cols.contacts_of_contacts_addresses)
}

#Lab Results
if (nrow(lab_results)==0) {
  cols.lab_results <- c("personId","personType","dateSampleTaken","dateSampleDelivered","dateTesting","dateOfResult","labName","sampleIdentifier","sampleType","testType","result","quantitativeResult","status","outbreakId","testedFor","createdAt","createdBy","updatedAt","updatedBy","deleted","id")
  lab_results <- data.frame(matrix(ncol=length(cols.lab_results)))
  colnames(lab_results) <- cols.lab_results
} 

#Relationshipts
if (nrow(relationships) == 0) {
  cols.relationships <- c("ID","Created at","Created by","Updated on","Updated by","Deleted","Deleted at","Created on","Date of last contact","Is contact date estimated?","Certainty level","Exposure type","Exposure frequency","Exposure duration","Context of Exposure","Relation detail","Cluster","Comment","Source.UID","Source.Case / Contact ID","Source.Relationship type","Source.Name","Source.Last name","Source.First name","Source.Middle name","Source.Gender","Source.Date of birth","Source.Source","Source.Age.Age / Years","Source.Age.Age / Months","Target.UID","Target.Case / Contact ID","Target.Relationship type","Target.Name","Target.Last name","Target.First name","Target.Middle name","Target.Gender","Target.Date of birth","Target.Target","Target.Age.Age / Years","Target.Age.Age / Months")
  relationships <- data.frame(matrix(ncol=length(cols.relationships)))
  colnames(relationships) <- cols.relationships 
}

#Users
if (nrow(users) == 0) {
  cols.users <- c("id","firstName","lastName","roleIds","outbreakIds","activeOutbreakId","languageId","passwordChange","institutionName","loginRetriesCount","lastLoginDate","disregardGeographicRestrictions","email","createdAt","createdBy","updatedAt","updatedBy","deleted","securityQuestions","telephoneNumbers.LNG_USER_FIELD_LABEL_PRIMARY_TELEPHONE","settings.caseFields","settings.auditLogFields","settings.caseLabFields","settings.contactLabFields","settings.contactFields","settings.eventFields","settings.locationFields","settings.labResults","settings.relationshipFields","settings.outbreakFields","settings.outbreakModifyQuestionnaireFields","settings.outbreakTemplateFields","settings.outbreakTemplateModifyQuestionnaireFields","settings.contactDailyFollowUpFields","settings.caseRelatedFollowUpFields","settings.contactRelatedFollowUpFields","settings.syncUpstreamServersFields","settings.syncClientApplicationsFields","settings.syncLogsFields","settings.refDataCatEntriesFields","settings.shareRelationships","settings.userRoleFields","settings.entityNotDuplicatesFields","settings.dashboard.dashlets")
  users <- data.frame(matrix(ncol=length(cols.users)))
  colnames(users) <- cols.users 
}

rm(content)
rm(response)
