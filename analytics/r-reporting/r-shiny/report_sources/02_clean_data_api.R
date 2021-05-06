####################################################################################################################################################
## Go.Data Cleaning Scripts of collections retrieved directly from API
# 
#       Before running this Script, please first run 01_data_import_api.R
#
#       This script is for cleaning the Go.Data data for COVID - core variables ONLY (i.e. does not retrieve from custom questionnaire as this varies across instances
#       You can adapt these relatively easily if you need to add in variables from your questionnaire.
#       Script authored and maintained by Go.Data team (godata@who.int): Sara Hollis (holliss@who.int); James Fuller (fullerj@who.int)

####################################################################################################################################################


##########################################################################
## CLEAN LOCATIONS
## 
## rearrange via joins to get into more usable hierarchy format
## these can then be joined to cases, contacts, etc
##########################################################################

#This generates a warning, but it can be ignored

locations_clean <- locations %>%
  filter(deleted == FALSE | is.na(deleted)) %>%
  filter(active == TRUE | is.na(active)) %>%
  mutate(admin_level = sub(".*LEVEL_", "", geographicalLevelId)) %>%
  unnest(identifiers, keep_empty=TRUE) %>%
  select(location_id = id,
         admin_level,
         name,
         code,
         parent_location_id = parentLocationId,
         population_density = populationDensity,
         lat = geoLocation.lat,
         long = geoLocation.lng
  ) %>%
  filter(!is.na(admin_level))

max.admin.level <- max(as.numeric(locations_clean$admin_level))
for (i in 0:max.admin.level) {
  admin_i <- locations_clean %>% filter(admin_level==i)
  names(admin_i) <- paste0("admin_",i,"_",names(admin_i))
  admin_i$location_id <- pull(admin_i, paste0("admin_",i,"_location_id"))
  admin_i$parent_location_id <- pull(admin_i, paste0("admin_",i,"_parent_location_id"))
  assign(paste0("admin_",i), admin_i)
}
admin_0$parent_location_id <- NULL
for (i in max.admin.level:1) {
  
  print(paste0("*****Starting Admin ", i, "*****"))
  
  admin_i <- get(paste0("admin_",i))
  
  for (x in 1:i) {
    print(paste0("*Joining Admin ", i-x, "*"))
    admin_ix <- get(paste0("admin_",i-x))
    admin_i <- left_join(admin_i, admin_ix, by=c("parent_location_id" = "location_id"))
    admin_i$parent_location_id <- admin_i$parent_location_id.y
    admin_i$parent_location_id.y <- NULL
    assign(paste0("admin_",i), admin_i)
  }
  admin_i$parent_location_id <- NULL
  assign(paste0("admin_",i), admin_i)
}

full <- admin_0
for (i in 1:max.admin.level) {
  admin_i <- get(paste0("admin_",i))
  full <- full %>% bind_rows(admin_i)
}
locations_clean <- locations_clean %>% left_join(full, by="location_id")

##########################################################################
### Clean & Un-nest CASES
##########################################################################

# Unnest pertinent list fields:

# Unnest Addresses and have a standalone table with all addresses even if more than 1 per person
cases_address_history_clean <- cases %>%
  filter(deleted == FALSE | is.na(deleted)) %>%
  select(id, addresses) %>%
  unnest(addresses, names_sep = "_") %>%
  select_all(~gsub("\\.","_",tolower(.))) %>%
  select_if(negate(is.list)) %>%
  mutate(addresses_typeid = sub("LNG_REFERENCE_DATA_CATEGORY_ADDRESS_TYPE_","",addresses_typeid)) %>%
  left_join(locations_clean, by=c("addresses_locationid" = "location_id")) 

# add in any missing address fields
missing_columns_cases_addresses <- setdiff(address_columns, names(cases_address_history_clean))
cases_address_history_clean[missing_columns_cases_addresses] <- NA

# Unnest Date Ranges - Isolation / Hospitalizaton History
# here we assume that if time frame is over 14d and no end date, it has already completed
cases_hosp_history_clean <- cases %>%
  filter(deleted == FALSE | is.na(deleted)) %>%
  unnest(dateRanges, names_sep = "_") %>%
  select_at(vars(id, starts_with("dateRanges"),-dateRanges_dateRanges), tolower) %>%
  mutate(dateranges_typeid = sub(".*TYPE_", "", dateranges_typeid)) %>%
  mutate_at(vars(dateranges_startdate, dateranges_enddate), as.Date) %>%
  mutate(dateranges_enddate = case_when(!is.na(dateranges_enddate) ~ dateranges_enddate,
                                        TRUE ~ dateranges_startdate + 14)) %>%
  mutate(dateranges_status = case_when(dateranges_enddate <= Sys.Date() ~ "completed",
                                       dateranges_enddate >= Sys.Date() ~ "ongoing",
                                       TRUE ~ "date_missing")) 

################################################################################  


cases_clean <- cases %>%
  filter(deleted == FALSE | is.na(deleted)) %>%
  # Remove all nested fields
  select_if(negate(is.list)) %>%
  # take out all that are not core variables
  select(-contains("questionnaireAnswers"))

# force variables that are unused for this project - otherwise they are dropped from JSON
missing_columns_cases <- setdiff(case_columns, names(cases_clean))
cases_clean[missing_columns_cases] <- NA
cases_clean <- cases_clean[case_columns]
cases_clean[cases_clean == "NA"] <- NA


# specify which fields are dates, for formatting
date_fields_cases <- c("dob","dateOfReporting","dateOfLastContact","dateOfOnset","dateOfOutcome","dateOfInfection","createdAt","dateBecomeCase","followUp.startDate","followUp.endDate")


cases_clean <- cases_clean %>%
  #join in current address from address history
  left_join(cases_address_history_clean %>% filter(addresses_typeid=="USUAL_PLACE_OF_RESIDENCE"), by="id") %>%
  #join in isolation date/location from hospitalization history
  left_join(cases_hosp_history_clean %>% filter(dateranges_typeid=="ISOLATION"), by="id") %>%
  rename_at(vars(starts_with("dateranges")), funs(str_replace(., "dateranges", "isolation"))) %>%
  left_join(cases_hosp_history_clean %>% filter(dateranges_typeid=="HOSPITALIZATION"), by="id") %>%
  rename_at(vars(starts_with("dateranges")), funs(str_replace(., "dateranges", "hospitalization"))) %>%
  # if there happen to be any duplicate column names, rename them here
  rename_at(vars(ends_with(".x")),
            ~str_replace(., "\\..$","")) %>% 
  select_at(vars(-ends_with(".y"))) %>%
  #clean up all character fields
  mutate_if(is_character, funs(na_if(.,""))) %>%
  #format dates
  mutate_at(vars(all_of(date_fields_cases)), list(~ as.Date(substr(., 1, 10)))) %>%
  mutate(date_of_reporting = dateOfReporting,
         date_of_data_entry = createdAt,
         date_of_infection = dateOfInfection,
         date_of_onset = dateOfOnset,
         date_of_outcome = dateOfOutcome, 
         date_of_last_contact = dateOfLastContact,
         date_of_followup_start = followUp.startDate,
         date_of_followup_end = followUp.endDate,
         date_become_case = dateBecomeCase) %>%
  
  
  # force NA ages to appear as NA, not as 0 like sometimes occurs  
  mutate(age_years = as.numeric(age.years)) %>%
  mutate(age_years = na_if(age_years,0)) %>%
  mutate(age_months = as.numeric(age.months)) %>%
  mutate(age_months = na_if(age_months,0)) %>%
  
  # standardize age vars into just one var
  mutate(age = case_when(!is.na(age_months) ~  age_months / 12,
                         TRUE ~ age_years)) %>%
  
  # WHO recommended age categories, updated Sept 2020
  mutate(
    age_class = factor(
      case_when(
        age <= 4 ~ "0-4",
        age <= 9 ~ "5-9",
        age <= 14 ~ "10-14",
        age <= 19 ~ "15-19",
        age <= 29 ~ "20-29",
        age <= 39 ~ "30-39",
        age <= 49 ~ "40-49",
        age <= 59 ~ "50-59",
        age <= 64 ~ "60-64",
        age <= 69 ~ "65-69",
        age <= 74 ~ "70-74",
        age <= 79 ~ "75-79",
        is.finite(age) ~ "80+",
        TRUE ~ "unknown"
      ), levels = c(
        "0-4",
        "5-9",
        "10-14",
        "15-19",
        "20-29",
        "30-39",
        "40-49",
        "50-59",
        "60-64",
        "65-69",
        "70-74",
        "75-79",
        "80+",
        "unknown"
      )),
    age_class = factor(
      age_class,
      levels = rev(levels(age_class)))) %>%
  
  select(
    uuid = id,
    case_id = visualId,
    location_id = addresses_locationid,
    lat = addresses_geolocation_lat,
    long = addresses_geolocation_lng,
    geo_location_accurate = addresses_geolocationaccurate,
    address = addresses_addressline1,
    postal_code = addresses_postalcode,
    city = addresses_city,
    firstName,
    middleName,
    lastName,
    gender,
    age,
    age_class,
    occupation,
    classification,
    telephone = addresses_phonenumber,
    email = addresses_emailaddress,
    outcome_id = outcomeId,
    pregnancy_status = pregnancyStatus,
    date_of_reporting,
    date_of_data_entry,
    date_of_infection,
    date_of_onset,
    date_of_outcome,
    date_of_last_contact,
    date_become_case,
    date_of_followup_start,
    date_of_followup_end,
    date_of_onset_approximate = isDateOfOnsetApproximate,
    transfer_refused = transferRefused,
    risk_level = riskLevel,
    risk_reason = riskReason,
    has_relationships = hasRelationships,
    was_contact = wasContact,
    starts_with("isolation"),
    starts_with("hospitalization"),
    starts_with("admin"),
    createdBy
    
  ) %>%
  
  mutate(classification = sub(".*CLASSIFICATION_", "", classification)) %>%
  mutate(gender = sub(".*GENDER_", "", gender)) %>%
  mutate(occupation = sub(".*OCCUPATION_", "", occupation)) %>%
  mutate(outcome_id = sub(".*OUTCOME_", "", outcome_id)) %>%
  mutate(pregnancy_status = sub(".*STATUS_", "", pregnancy_status)) %>%
  mutate(risk_level = sub(".*LEVEL_", "", risk_level)) 


#Pull out all cases that used to be contacts
contacts_becoming_cases <- cases_clean %>%
  filter(was_contact == TRUE) %>%
  # select(-contains("questionnaireAnswers")) %>%
  # unnest(followUpHistory, names_sep = "_") %>%
  mutate(contact_status = "BECAME_CASE",
         active = FALSE,
         was_case=NA) %>%
  select(
    uuid,
    contact_id = case_id,
    active,
    contact_status,
    location_id, lat, long, geo_location_accurate, address, postal_code, city, telephone, email,
    firstName, lastName, gender, age, age_class, occupation, pregnancy_status, 
    date_of_reporting, date_of_data_entry, 
    date_of_last_contact, 
    date_of_followup_start, 
    date_of_followup_end,
    risk_level, risk_reason, was_case,
    starts_with("admin_"),
    createdBy
  )


##########################################################################
### Clean & Un-nest CONTACTS
##########################################################################

##### un nesting pertinent list fields ###############################################################################################

# Unnest Addresses and have a standalone table with all addresses even if more than 1 per person
contacts_address_history_clean <- contacts %>%
  filter(deleted == FALSE | is.na(deleted)) %>%
  select(id, addresses) %>%
  unnest(addresses, names_sep = "_") %>%
  select_all(~gsub("\\.","_",tolower(.))) %>%
  select_if(negate(is.list)) %>%
  mutate(addresses_typeid = sub("LNG_REFERENCE_DATA_CATEGORY_ADDRESS_TYPE_","",addresses_typeid)) %>%
  left_join(locations_clean, by=c("addresses_locationid" = "location_id"))

# add in any missing fields
missing_columns_contacts_addresses <- setdiff(address_columns, names(contacts_address_history_clean))
contacts_address_history_clean[missing_columns_contacts_addresses] <- NA


# if you have a question about quarantine in your questionnaire, could unnest that here and then do a left join later to join this to main table

#####################################################################################################################################################################


contacts_clean <- contacts %>%
  filter(deleted == FALSE | is.na(deleted)) %>%
  # Remove all nested fields
  select_if(negate(is.list)) %>%
  # take out all that are not core variables
  select(-contains("questionnaireAnswers"))

# force bind other core vars in case they are missing in JSON from having never been answered
missing_columns_contacts <- setdiff(contact_columns, names(contacts_clean))
contacts_clean[missing_columns_contacts] <- NA
contacts_clean <- contacts_clean[contact_columns]
contacts_clean[contacts_clean == "NA"] <- NA

date_fields_contacts <- c("dateOfReporting","dateOfLastContact","createdAt","followUp.startDate","followUp.endDate")


contacts_clean <- contacts_clean %>%
  #join in current address from address history
  left_join(contacts_address_history_clean %>% filter(addresses_typeid=="USUAL_PLACE_OF_RESIDENCE"), by="id") %>%
  # if there happen to be any duplicate column names, rename them here
  rename_at(vars(ends_with(".x")),
            ~str_replace(., "\\..$","")) %>% 
  select_at(vars(-ends_with(".y"))) %>%
  #clean up all character fields
  mutate_if(is_character, funs(na_if(.,""))) %>%
  # clean date formats
  mutate_at(vars(all_of(date_fields_contacts)), list(~ as.Date(substr(., 1, 10)))) %>%
  mutate(date_of_reporting = dateOfReporting,
         date_of_data_entry = createdAt,
         date_of_last_contact = dateOfLastContact, 
         date_of_followup_start = followUp.startDate,
         date_of_followup_end = followUp.endDate) %>%
  # format and combine age variables
  mutate(age_years = as.numeric(age.years)) %>%
  mutate(age_years = na_if(age_years,0)) %>%
  mutate(age_months = as.numeric(age.months)) %>%
  mutate(age_months = na_if(age_months,0)) %>%
  mutate(age = case_when(
    is.na(age_years) & !is.na(age_months) ~  age_months / 12,
    TRUE ~ age_years)) %>%
  
  mutate(
    age = as.numeric(age),
    age_class = factor(
      case_when(
        age <= 4 ~ "0-4",
        age <= 9 ~ "5-9",
        age <= 14 ~ "10-14",
        age <= 19 ~ "15-19",
        age <= 29 ~ "20-29",
        age <= 39 ~ "30-39",
        age <= 49 ~ "40-49",
        age <= 59 ~ "50-59",
        age <= 64 ~ "60-64",
        age <= 69 ~ "65-69",
        age <= 74 ~ "70-74",
        age <= 79 ~ "75-79",
        is.finite(age) ~ "80+",
        TRUE ~ "unknown"
      ), levels = c(
        "0-4",
        "5-9",
        "10-14",
        "15-19",
        "20-29",
        "30-39",
        "40-49",
        "50-59",
        "60-64",
        "65-69",
        "70-74",
        "75-79",
        "80+",
        "unknown"
      )),
    age_class = factor(
      age_class,
      levels = rev(levels(age_class)))) %>%
  
  # select only core variables
  select(
    uuid = id,
    contact_id = visualId,
    active,
    contact_status = followUp.status,
    location_id = addresses_locationid,
    lat = addresses_geolocation_lat,
    long = addresses_geolocation_lng,
    geo_location_accurate = addresses_geolocationaccurate,
    address = addresses_addressline1,
    postal_code = addresses_postalcode,
    city = addresses_city,
    telephone = addresses_phonenumber,
    email = addresses_emailaddress,
    # team_id = followUpTeamId,
    firstName,
    lastName,
    gender,
    age,
    age_class,
    occupation,
    pregnancy_status = pregnancyStatus,
    date_of_reporting,
    date_of_data_entry,
    date_of_last_contact,
    date_of_followup_start,
    date_of_followup_end,
    risk_level = riskLevel,
    risk_reason = riskReason,
    was_case = wasCase,
    starts_with("quarantine_"),
    starts_with("admin_"),
    createdBy
    
  ) %>%
  
  mutate(gender = sub(".*GENDER_", "", gender)) %>%
  mutate(occupation = sub(".*OCCUPATION_", "", occupation)) %>%
  mutate(contact_status = sub(".*TYPE_", "", contact_status)) %>%
  mutate(pregnancy_status = sub(".*STATUS_", "", pregnancy_status)) %>%
  mutate(risk_level = sub(".*LEVEL_", "", risk_level)) %>%
  mutate(address = case_when(address == "NA" ~ NA)) %>%
  mutate(address = case_when(postal_code == "NA" ~ NA)) %>%
  
  #Join in cases that used to be contacts
  bind_rows(contacts_becoming_cases) 
  
  
  ##########################################################################
### Clean & Un-nest FOLLOW-UPS
##########################################################################


date_fields_followups <- c("date","createdAt","updatedAt")
#took out address.date

followups_clean <- followups %>%
  filter(deleted == FALSE | is.na(deleted)) %>%
  select_if(negate(is.list)) %>%
  # take out all that are not core variables
  select(-contains("questionnaireAnswers")) %>%
  #remove contact variables
  rename(contact_id = contact.visualId,
         contact_uuid = contact.id) %>%
  select(-starts_with("contact.")) %>%
  select(-starts_with("address")) %>%
  
  #join in current address from address history
  left_join(contacts_address_history_clean %>% filter(addresses_typeid=="USUAL_PLACE_OF_RESIDENCE"), by=c("contact_uuid" = "id")) %>%
  
  # # clean date formats
  mutate_at(vars(all_of(date_fields_followups)), list(~ as.Date(substr(., 1, 10)))) %>%  
  mutate(date_of_followup = date,
         date_of_data_entry = createdAt) %>%
  # mutate(location_id = str_replace_na(address.locationId, replacement = "")) %>%
  select(
    uuid = id,
    contact_id,
    contact_uuid,
    followup_status = statusId,
    followup_number = index,
    date_of_data_entry,
    date_of_followup,
    team_id = teamId, # why is this sometimes blank?
    location_id = addresses_locationid,
    lat = addresses_geolocation_lat,
    long = addresses_geolocation_lng,
    geo_location_accurate = addresses_geolocationaccurate,
    address = addresses_addressline1,
    postal_code = addresses_postalcode,
    city = addresses_city,
    telephone = addresses_phonenumber,
    email = addresses_emailaddress,
    starts_with("admin_"),
    createdBy
    
  ) %>%
  # 
  # #Join in location hierarchy
  # left_join(locations_clean, by="location_id") %>%
  
  # recode categorical variables to be read-able here
  mutate(followup_status = sub(".*TYPE_", "", followup_status)) %>%
  ## sometimes it will take you thinking through some logic
  mutate(performed = case_when(
    followup_status == "MISSED" ~ TRUE,
    followup_status == "SEEN_NOT_OK" ~ TRUE,
    followup_status == "SEEN_OK" ~ TRUE,
    followup_status == "NOT_PERFORMED" ~ FALSE)) %>%
  mutate(seen = case_when(
    followup_status == "SEEN_OK" ~ TRUE,
    followup_status == "SEEN_NOT_OK" ~ TRUE,
    TRUE ~ FALSE))


##########################################################################
# Clean & Un-nest EVENTS
##########################################################################
if (nrow(events)==0) {
  events_clean <- data.frame(matrix(ncol=length(events_columns_final)))
  colnames(events_clean) <- events_columns_final
} else {
  
  
  ## unnest events to get contacts and exposures
  # events_relationship_history <- events %>%
  #   select(id, name, relationshipsRepresentation) %>%
  #   unnest(relationshipsRepresentation, names_sep = "_", keep_empty = TRUE) %>%
  #   mutate(other_participant_type = sub(".*TYPE_", "", relationshipsRepresentation_otherParticipantType)) %>%
  #   mutate(relationship_type = case_when(
  #     relationshipsRepresentation_source == TRUE  ~ "CONTACT",
  #     relationshipsRepresentation_target == TRUE  ~ "EXPOSURE",
  #   )) 
  # 
  # events_relationship_history_counts <- events_relationship_history %>%
  #   select(
  #     id,
  #     name,
  #     relationship_type,
  #     other_participant_type,
  #     other_participant_id = relationshipsRepresentation_otherParticipantId) %>%
  #   group_by(id, relationship_type) %>%
  #   tally()
  
  
  date_fields_events <- c("dateOfReporting",
                              # "dateOfLastContact",
                          "createdAt","updatedAt","date")
  
  events_clean <- events %>%
    filter(deleted==FALSE) %>%
    mutate_if(is_character, funs(na_if(.,""))) %>%
    # clean date formats
    mutate_at(vars(all_of(date_fields_events)), list(~ as.Date(substr(., 1, 10)))) %>%
    rename(event_name = name) %>%
    mutate(date_of_reporting = dateOfReporting,
           date_of_data_entry = createdAt,
           # date_of_last_contact = dateOfLastContact, 
           date_of_event = date) %>%
    left_join(locations_clean, by=c("address.locationId" = "location_id")) %>%
    #join in count of contacts per event 
    # left_join(events_relationship_history_counts %>% filter(relationship_type=="CONTACT"), by="id") %>% rename(number_of_contacts = n) %>%
    # #join in count of exposures per event
    # left_join(events_relationship_history_counts %>% filter(relationship_type=="EXPOSURE"), by="id") %>% rename(number_of_exposures = n) %>%
    # mutate(number_of_contacts = replace(number_of_contacts, is.na(number_of_contacts),0)) %>%
    # mutate(number_of_exposures = replace(number_of_exposures, is.na(number_of_exposures),0)) %>%
    
    select(
      uuid = id,
      event_name,
      description,
      # number_of_contacts,
      # number_of_exposures,
      date_of_event,
      date_of_reporting,
      date_of_data_entry,
      location_id = address.locationId,
      lat = address.geoLocation.lat,
      long = address.geoLocation.lng,
      geo_location_accurate = address.geoLocationAccurate,
      # address = address.addressLine1, # EO: not found in data
      # postal_code = address.postalCode,
      city = address.city,
      starts_with("admin_"),
      createdBy
    )
  
  
  
}


##########################################################################
# Clean & Un-nest CONTACTS OF CONTACTS
##########################################################################
# if (nrow(contacts_of_contacts)==0) {
#   contacts_of_contacts_clean <- data.frame(matrix(ncol=length(contacts_of_contacts_columns_final)))
#   colnames(contacts_of_contacts_clean) <- contacts_of_contacts_columns_final
# } else {
#   
#   #Unnest Addresses
#   addresses_contacts_of_contacts <- contacts_of_contacts %>%
#     filter(deleted == FALSE) %>%
#     select(id, addresses) %>%
#     unnest(addresses, names_sep = "_") %>%
#     mutate(addresses_typeId = sub("LNG_REFERENCE_DATA_CATEGORY_ADDRESS_TYPE_","",addresses_typeId)) %>%
#     left_join(locations_clean, by=c("addresses_locationId" = "location_id"))
#   
#   
#   date_fields_contacts_of_contacts <- c("dob","dateOfReporting","dateOfLastContact","createdAt","updatedAt","createdOn")
#   
#   contacts_of_contacts_clean <- contacts_of_contacts %>%
#     filter(deleted == FALSE) %>%
#     # take out all that are not core variables, can be modified if someone wants to analyze questionnaire vars
#     select_if( !(names(.) %in% c('dateRanges','addresses','classificationHistory','vaccinesReceived','documents','relationshipsRepresentation','followUpHistory'))) %>%
#     select(-contains("questionnaireAnswers")) %>%
#     # unnest commonly used fields
#     #unnest_wider(addresses, names_sep = "_") %>%
#     #unnest_wider(followUpHistory, names_sep = "_")
#     left_join(addresses_contacts_of_contacts %>% filter(addresses_typeId=="USUAL_PLACE_OF_RESIDENCE"), by="id")  
#   
#   # force bind other core vars in case they are missing in JSON from having never been answered
#   missing_columns_contacts <- setdiff(contact_columns, names(contacts_clean))
#   contacts_clean[missing_columns_contacts] <- NA
#   contacts_clean <- contacts_clean[contact_columns]
#   contacts_clean[contacts_clean == "NA"] <- NA
#   
#   contacts_clean <- contacts_clean %>%
#     # unnest location IDs if more than 1 is documented
#     # unnest(addresses_locationId) %>%
#     # unnest(addresses_city) %>%
#     # clean date formats
#     mutate_at(vars(all_of(date_fields_contacts)), list(~substr(., 1, 10)), ~as.Date) %>%  
#     mutate(date_of_reporting = dateOfReporting,
#            date_of_data_entry = createdAt,
#            date_of_last_contact = dateOfLastContact, 
#            date_of_followup_start = followUp.startDate,
#            date_of_followup_end = followUp.endDate) %>%
#     # format and combine age variables
#     mutate(age_years = as.numeric(age.years)) %>%
#     mutate(age_years = na_if(age_years,0)) %>%
#     mutate(age_months = as.numeric(age.months)) %>%
#     mutate(age_months = na_if(age_months,0)) %>%
#     mutate(age = case_when(
#       is.na(age_years) && !is.na(age_months) ~  age_months / 12,
#       TRUE ~ age_years)) %>%
#     
#     mutate(
#       age = as.numeric(age),
#       age_class = factor(
#         case_when(
#           age <= 4 ~ "0-4",
#           age <= 9 ~ "5-9",
#           age <= 14 ~ "10-14",
#           age <= 19 ~ "15-19",
#           age <= 29 ~ "20-29",
#           age <= 39 ~ "30-39",
#           age <= 49 ~ "40-49",
#           age <= 59 ~ "50-59",
#           age <= 64 ~ "60-64",
#           age <= 69 ~ "65-69",
#           age <= 74 ~ "70-74",
#           age <= 79 ~ "75-79",
#           is.finite(age) ~ "80+",
#           TRUE ~ "unknown"
#         ), levels = c(
#           "0-4",
#           "5-9",
#           "10-14",
#           "15-19",
#           "20-29",
#           "30-39",
#           "40-49",
#           "50-59",
#           "60-64",
#           "65-69",
#           "70-74",
#           "75-79",
#           "80+",
#           "unknown"
#         )),
#       age_class = factor(
#         age_class,
#         levels = rev(levels(age_class)))) %>%
#     
#     # select only core variables
#     select(
#       uuid = id,
#       contact_id = visualId,
#       active,
#       contact_status = followUp.status,
#       location_id = addresses_locationId,
#       lat = addresses_geoLocation.lat,
#       long = addresses_geoLocation.lng,
#       address = addresses_addressLine1,
#       postal_code = addresses_postalCode,
#       team_id = followUpTeamId,
#       city = addresses_city,
#       firstName,
#       lastName,
#       gender,
#       age,
#       age_class,
#       occupation,
#       telephone = addresses_phoneNumber,
#       pregnancy_status = pregnancyStatus,
#       date_of_reporting,
#       date_of_data_entry,
#       date_of_last_contact,
#       date_of_followup_start,
#       date_of_followup_end,
#       risk_level = riskLevel,
#       risk_reason = riskReason,
#       was_case = wasCase,
#       createdBy
#       
#     ) %>%
#     
#     mutate(gender = sub(".*GENDER_", "", gender)) %>%
#     mutate(occupation = sub(".*OCCUPATION_", "", occupation)) %>%
#     mutate(contact_status = sub(".*TYPE_", "", contact_status)) %>%
#     mutate(pregnancy_status = sub(".*STATUS_", "", pregnancy_status)) %>%
#     mutate(risk_level = sub(".*LEVEL_", "", risk_level)) %>%
#     mutate(address = case_when(address == "NA" ~ NA)) %>%
#     mutate(address = case_when(postal_code == "NA" ~ NA)) %>%
#     
#     #Join in cases that used to be contacts
#     bind_rows(contacts_becoming_cases) %>%
#     
#     # join in location hierarchy
#     left_join(locations_clean %>% select(!(admin_level:long)), by="location_id")
#   
#   
#   
# }

##########################################################################
# Clean & Un-nest LAB RESULTS
##########################################################################

# can be further cleaned

if (nrow(lab_results)==0) {
  lab_results_clean <- data.frame(matrix(ncol=length(lab_results_columns_final)))
  colnames(lab_results_clean) <- lab_results_columns_final
} else {
  
  lab_results_clean <- lab_results %>%
    filter(deleted==FALSE) %>%
    select_if(negate(is.list))
  
}

##########################################################################
# Clean & Un-nest RELATIONSHIPS
##########################################################################

#Only process data if the has more than 0 relationships, otherwise generate an empty relationships_clean dataset
if (nrow(relationships) == 0) {
  relationships_clean <- data.frame(matrix(ncol=length(relationships_columns_final)))
  colnames(relationships_clean) <- relationships_columns_final 
} else {
  
  date_fields_relationships <- c("Created at","Updated on","Deleted at","Date of last contact")
  
  relationships_clean <- relationships %>%
    filter(Deleted == FALSE)  %>%  
    mutate_at(vars(all_of(date_fields_relationships)), list(~substr(., 1, 10)), ~as.Date) %>%  
    mutate(date_of_last_contact = `Date of last contact`,
           date_of_data_entry = `Created at`) %>%
    select(
      uuid = ID,
      source_uuid = Source.UID,
      source_visualid = `Source.Case / Contact ID`,
      source_gender = Source.Gender,
      date_of_last_contact,
      date_of_data_entry,
      source_age = `Source.Age.Age / Years`,
      target_uuid = Target.UID,
      target_visualid = `Target.Case / Contact ID`,
      target_gender = Target.Gender,
      target_age = `Target.Age.Age / Years`,
      exposure_type = `Exposure type`,
      context_of_exposure = `Context of Exposure`,
      exposure_frequency = `Exposure frequency`,
      certainty_level = `Certainty level`,
      exposure_duration = `Exposure duration`,
      relation_detail = `Relation detail`,
      cluster = Cluster,
      is_contact_date_estimated = `Is contact date estimated?`,
      comment = Comment,
      createdBy = `Created by`
      
    ) %>%
    mutate_if(is.character, list(~na_if(.,"")))
  
  relationships_clean[relationships_clean == ""] <- NA
  
}


##########################################################################
# Clean & Un-nest TEAMS
##########################################################################

#Only process data if the has more than 0 teams, otherwise generate an empty teams_clean dataset
if (nrow(teams) == 0) {
  teams_clean <- data.frame(matrix(ncol=length(teams_columns_final)))
  colnames(teams_clean) <- teams_columns_final 
} else {
  
  teams_clean <- teams %>%
    filter(deleted == FALSE) %>%
    unnest(userIds, keep_empty = TRUE) %>%
    unnest(locationIds, keep_empty = TRUE) %>%
    select(uuid = id,
           name,
           user_id = userIds,
           location_id = locationIds
    )
  
}

##########################################################################
## Clean & Un-nest USERS 
##########################################################################

#Only process data if the has more than 0 teams, otherwise generate an empty teams_clean dataset
if (nrow(users) == 0) {
  users_clean <- data.frame(matrix(ncol=length(users_columns_final)))
  colnames(users_clean) <- users_columns_final 
} else {
  
  users_clean <- users %>%
    filter(deleted == FALSE) %>%
    # filter(activeOutbreakId == outbreak_id) %>%
    unnest_wider(roleIds, names_sep = "_") %>%
    # clean_data(guess_dates = FALSE) %>%
    select(uuid = id,
           firstname = firstName,
           lastname = lastName,
           email = email
    )
  
}


##########################################################################
## some other additions for handy things to have in linelist .csv
##########################################################################

contacts_per_case <- relationships_clean %>%
  group_by(source_visualid, source_uuid) %>%
  tally() %>%
  select(source_visualid, 
         source_uuid,
         contacts_per_case = n)


# cases linelist, now with contacts per case (can add other vars here as needed)

cases_clean <- cases_clean %>%
  left_join(contacts_per_case, by = c("uuid" = "source_uuid")) %>%
  mutate(contacts_per_case = replace(contacts_per_case, is.na(contacts_per_case),0))



###############################################################
## Export Dataframes(to be overwritten each time script is run) 
###############################################################

rm(contacts_address_history_clean)
rm(cases_address_history_clean)
rm(cases_hosp_history_clean)

## Specify location to save files
data_folder <- here::here("data")

## specify data frames to export
mydfs<- ls(pattern = "_clean")
mydfs

## export files as .csv
for (i in 1:length(mydfs)){
  savefile<-paste0(data_folder,"/", mydfs[i], ".csv")
  write.csv(get(mydfs[i]), file=savefile, fileEncoding = "UTF-8", na="", row.names = F)
  
  print(paste("Dataframe Saved:", mydfs[i]))
}

## export all as .rds files which we will use for report scripts as it preserves language characters better
for (i in 1:length(mydfs)){
  savefile<-paste0(data_folder,"/", mydfs[i], ".rds")
  saveRDS(get(mydfs[i]), file=savefile)
  print(paste("Dataframe Saved:", mydfs[i]))
}
