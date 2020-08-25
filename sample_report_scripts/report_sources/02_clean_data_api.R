## This script is for cleaning the Go.Data data for COVID - core variables ONLY.
## You can adapt these if you need to add additional questionnaire variables.


# check to see which of these are actually needed, take out those that are not.
path_to_functions <- here::here("scripts")
scripts_files <- dir(path_to_functions, pattern = ".R$", full.names=TRUE)
for (file in scripts_files) source(file, local = TRUE)


##########################################################################
### Load data from API R tibbles
##########################################################################

## We use rio package (r input output) for reading in the data

database_date <- Sys.Date()

cases <- cases %>%
  as_tibble()

contacts <- contacts %>%
  as_tibble()

followups <- followups %>%
  as_tibble()

relationships <- relationships %>%
  as_tibble()

teams <- teams %>%
  as_tibble()

users <- users %>%
  as_tibble()

locations <- locations %>%
  as_tibble()


#################################################################

## Ensure that cases and contact tables will have all req columns
#  set to NA those that were not in JSON output
## Look in set_core_fields script for this

set_core_fields <- here::here('report_sources/set_core_fields.R')
source(set_core_fields)

###############################################################


##########################################################################
### Clean & Un-nest cases
##########################################################################


## Filters out cases that have been deleted 
## also unnest all nested fields
## also bring in only required fields we need (for now excluding to non Questionnaire variables)


cases_clean <- cases %>%
  filter(deleted == FALSE) %>%
  # take out all that are not core variables
  # this can be modified if someone wants to analyze questionnaire vars
  select(-contains("questionnaireAnswers")) %>%
  # unnest commonly used core fields 
  unnest_wider(addresses, names_sep = "_") %>%
  unnest_wider(dateRanges, names_sep = "_") 
  
  missing_columns_cases <- setdiff(case_columns, names(cases_clean))
  cases_clean[missing_columns_cases] <- NA
  cases_clean <- cases_clean[case_columns]
  cases_clean[cases_clean == "NA"] <- NA
  
cases_clean <- cases_clean %>%
  mutate_if(is_character, funs(na_if(.,""))) %>%
  # unnest location IDs if more than 1 is documented, find better way to do this
  unnest(addresses_locationId) %>%
  unnest(addresses_city) %>%
  # clean date formats
  mutate_at(vars(contains("date")), as.character) %>%
  mutate(date_of_reporting = guess_dates(dateOfReporting),
         date_of_data_entry = guess_dates(createdAt),
         date_of_onset = guess_dates(dateOfOnset),
         date_of_outcome = guess_dates(dateOfOutcome), 
         date_of_last_contact = guess_dates(dateOfLastContact), 
         date_become_case = guess_dates(dateBecomeCase),
         dateranges_startdate = guess_dates(dateRanges_startDate),
         dateranges_enddate = guess_dates(dateRanges_endDate)) %>%
  # format and combine age variables; and group into WHO recommended age categories
  mutate(age_years = as.numeric(age.years)) %>%
  mutate(age_months = as.numeric(age.months)) %>%
  mutate(age = case_when(
    is.na(age_years) && !is.na(age_months) ~  age_months / 12,
    TRUE ~ age_years)) %>%
  mutate(
    age = round(as.numeric(age), digits = 1),
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
  # makes sure that we do not have duplicates when location id unnesting happened
  group_by(id) %>%
  filter(row_number() == 1) %>%
  select(
    uuid = id,
    case_id = visualId,
    location_id = addresses_locationId,
    lat = addresses_geoLocation.lat,
    long = addresses_geoLocation.lng,
    address = addresses_addressLine1,
    postal_code = addresses_postalCode,
    city = addresses_city,
    firstName,
    lastName,
    gender,
    age,
    age_class,
    occupation,
    classification,
    telephone = addresses_phoneNumber,
    outcome_id = outcomeId,
    pregnancy_status = pregnancyStatus,
    was_contact = wasContact,
    date_of_reporting,
    date_of_data_entry,
    date_of_onset,
    date_of_outcome,
    date_of_last_contact,
    date_become_case,
    date_of_onset_approximate = isDateOfOnsetApproximate,
    hosp_iso_type = dateRanges_typeId,
    hosp_iso_location = dateRanges_locationId,
    date_of_hosp_iso_start = dateranges_startdate,
    date_of_hosp_iso_end = dateranges_enddate,
    hosp_iso_center_name = dateRanges_centerName,
    transfer_refused = transferRefused,
    risk_level = riskLevel,
    risk_reason = riskReason,
    has_relationships = hasRelationships
    
  ) %>%
  ## if you want to filter out discarded cases, could do that here
  mutate(classification = sub(".*CLASSIFICATION_", "", classification)) %>%
  mutate(gender = sub(".*GENDER_", "", gender)) %>%
  mutate(occupation = sub(".*OCCUPATION_", "", occupation)) %>%
  mutate(outcome_id = sub(".*OUTCOME_", "", outcome_id)) %>%
  mutate(hosp_iso_type = sub(".*TYPE_", "", hosp_iso_type)) %>%
  mutate(pregnancy_status = sub(".*STATUS_", "", pregnancy_status)) %>%
  mutate(risk_level = sub(".*LEVEL_", "", risk_level)) %>%
  mutate(address = case_when(address == "NA" ~ NA)) %>%
  mutate(address = case_when(postal_code == "NA" ~ NA)) 


##########################################################################
### Clean & Un-nest contacts
##########################################################################


## contacts (all, not just active, but could filter to see active only, or those under follow up)
## also unnest all nested fields;
## also bring in only req varibles for current analysis to declutter

contacts_clean <- contacts %>%
  filter(deleted == FALSE) %>%
  # filter(active == TRUE) %>%
  # filter(as.Date.character(followUp.endDate) >= date(database_date)) %>%
  # filter(followUp.status == "LNG_REFERENCE_DATA_CONTACT_FINAL_FOLLOW_UP_STATUS_TYPE_UNDER_FOLLOW_UP") %>%
  # take out all that are not core variables, can be modified if someone wants to analyze questionnaire vars
  select(-contains("questionnaireAnswers")) %>%
  # unnest commonly used fields
  unnest_wider(addresses, names_sep = "_") %>%
  unnest_wider(followUpHistory, names_sep = "_")

# force bind other core vars in case they are missing in JSON from having never been answered
missing_columns_contacts <- setdiff(contact_columns, names(contacts_clean))
contacts_clean[missing_columns_contacts] <- NA
contacts_clean <- contacts_clean[contact_columns]
contacts_clean[contacts_clean == "NA"] <- NA

contacts_clean <- contacts_clean %>%
  # unnest location IDs if more than 1 is documented
  unnest(addresses_locationId) %>%
  unnest(addresses_city) %>%
  # clean date formats
  mutate_at(vars(contains("date")), as.character) %>%
  mutate(date_of_reporting = guess_dates(dateOfReporting),
         date_of_data_entry = guess_dates(createdAt),
         date_of_last_contact = guess_dates(dateOfLastContact), 
         date_of_followup_start = guess_dates(followUp.startDate),
         date_of_followup_end = guess_dates(followUp.endDate)) %>%
  # format and combine age variables
  mutate(age_years = as.numeric(age.years)) %>%
  mutate(age_months = as.numeric(age.months)) %>%
  mutate(age = case_when(
    is.na(age_years) && !is.na(age_months) ~  age_months / 12,
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
  # makes sure that we do not have duplicates when location id unnesting happened
  group_by(id) %>%
  filter(row_number() == 1) %>%

  # select only core variables
  select(
    uuid = id,
    contact_id = visualId,
    active,
    contact_status = followUp.status,
    location_id = addresses_locationId,
    lat = addresses_geoLocation.lat,
    long = addresses_geoLocation.lng,
    address = addresses_addressLine1,
    postal_code = addresses_postalCode,
    team_id = followUpTeamId,
    city = addresses_city,
    firstName,
    lastName,
    gender,
    age,
    age_class,
    occupation,
    telephone = addresses_phoneNumber,
    pregnancy_status = pregnancyStatus,
    date_of_reporting,
    date_of_data_entry,
    date_of_last_contact,
    date_of_followup_start,
    date_of_followup_end,
    risk_level = riskLevel,
    risk_reason = riskReason,
    was_case = wasCase
    
  ) %>%
  
  mutate(gender = sub(".*GENDER_", "", gender)) %>%
  mutate(occupation = sub(".*OCCUPATION_", "", occupation)) %>%
  mutate(contact_status = sub(".*TYPE_", "", contact_status)) %>%
  mutate(pregnancy_status = sub(".*STATUS_", "", pregnancy_status)) %>%
  mutate(risk_level = sub(".*LEVEL_", "", risk_level)) %>%
  mutate(address = case_when(address == "NA" ~ NA)) %>%
  mutate(address = case_when(postal_code == "NA" ~ NA))  
 


##########################################################################
### Clean & Un-nest follow-ups
##########################################################################

## follow up data, not deleted (could also choose to get only active contacts)
## also unnest all nested fields, only select necessary variables

followups_clean <- followups %>%
  filter(deleted == FALSE) %>%
  # filter(contact.active == TRUE) %>%
  # take out all that are not core variables
  # this can be modified if someone wants to analyze questionnaire vars
  select(-contains("questionnaireAnswers")) %>%
  
  # # clean date formats
  mutate_at(vars(contains("date")), as.character) %>%
  mutate(date_of_followup = guess_dates(date),
         date_of_data_entry = guess_dates(createdAt)) %>%
  mutate(location_id = str_replace_na(address.locationId, replacement = "")) %>%
  select(
    uuid = id,
    date_of_followup,
    contact_id = contact.visualId,
    contact_uuid = contact.id,
    person_id = personId,
    followup_status = statusId,
    followup_number = index,
    # team_id = teamId, # why is this sometimes blank?
    date_of_data_entry,
    location_id

  ) %>%

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
  ## there are a range of other contact variables that are attached to each fu record
  ## can bring those in here, otherwise can just rely on joins later.
    

#################################################################################################################3

# relationships
relationships_clean <- relationships %>%
  filter(Deleted == FALSE)  %>%  
  mutate_at(vars(contains("Date")), as.character) %>%
  mutate(date_of_last_contact = guess_dates(`Date of last contact`),
         date_of_data_entry = guess_dates(`Created at`)
         ) %>%
  select(
    uuid = ID,
    source_uuid = Source.UID,
    source_visualid = `Source.Case / Contact ID`,
    source_gender = Source.Gender,
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
    created_by = `Created by`,
    date_of_data_entry
    
  ) %>%
  mutate_if(is.character, list(~na_if(.,"")))

relationships_clean[relationships_clean == ""] <- NA
 


## locations - rearrange via joins to get into more usable hierarchy format, in clean_locations script
locations_clean <- locations %>%
  filter(deleted == FALSE) %>%
  filter(active == TRUE) %>%
  mutate(admin_level = sub(".*LEVEL_", "", geographicalLevelId)) %>%
  select(location_id = id,
         admin_level,
         name,
         parent_location_id = parentLocationId,
         population_density = populationDensity,
         lat = geoLocation.lat,
         long = geoLocation.lng
  )

# teams
teams_clean <- teams %>%
  filter(deleted == FALSE) %>%
  unnest(userIds, keep_empty = TRUE) %>%
  unnest(locationIds, keep_empty = TRUE) %>%
  select(uuid = id,
         name,
         user_id = userIds,
         location_id = locationIds
         # locationids_0,
         # locationids_1,
         # userids_0,
         # userids_1,
         # userids_2,
         # userids_3,
         # userids_4,
         # userids_5,
         # userids_6
  )


## user list 
users_clean <- users %>%
  filter(deleted == FALSE) %>%
  # filter(activeOutbreakId == outbreak_id) %>%
  unnest_wider(roleIds, names_sep = "_") %>%
  # clean_data(guess_dates = FALSE) %>%
  select(uuid = id,
         firstname = firstName,
         lastname = lastName
  )


## some other additions for handy things to have in linelist csv

contacts_per_case <- relationships_clean %>%
  group_by(source_visualid, source_uuid) %>%
  tally() %>%
  select(source_visualid, 
         source_uuid,
         contacts_per_case = n)


# cases linelist, now with contacts per case
# should investigate why some have source_uuid but not source_visualid

cases_clean_join <- cases_clean %>%
            left_join(contacts_per_case, by = c("uuid" = "source_uuid")) %>%
            mutate(contacts_per_case = replace(contacts_per_case, is.na(contacts_per_case),0))

              

  
#################################################################

## Clean locations

## clean_locations generic

## generic hierarchy is country, 
##admin1, 
#admin2, 
#admin3
# with contact tracing at admin 3

# good to define profile of person submitting the records 
# good to define level of location of person submiting the records and if this varies ever 

contact_locations <- contacts_clean %>% 
  ungroup() %>%
  distinct(location_id) %>%
  mutate(type = "CONTACT") 

case_locations <- cases_clean %>% 
  ungroup() %>%
  distinct(location_id) %>%
  mutate(type = "CASE")

locations_join_detail <- contact_locations %>%
  full_join(case_locations, by = "location_id") %>%
  mutate(type = paste0(type.x, "_", type.y)) %>%
  mutate(both = case_when(type == "CONTACT_CASE" ~ TRUE,
                          TRUE ~ FALSE),
         case_only = case_when(type == "NA_CASE" ~ TRUE,
                               TRUE ~ FALSE),
         contact_only = case_when(type == "CONTACT_NA" ~ TRUE,
                                  TRUE ~ FALSE)
         
  ) %>%
  select(
    location_id,
    case_only,
    contact_only,
    both
  )


### Name 6
# Join on name_6 area
n_6 <- left_join(locations_join_detail, locations_clean, by = "location_id") %>%
  mutate(original_location_id = location_id) %>%
  select(original_location_id,
         id_a = location_id,
         admin_level_a = admin_level,
         name_a = name,
         parent_a = parent_location_id)

n_5 <- left_join(n_6,locations_clean, by = c("parent_a" = "location_id")) %>%
  select(original_location_id,
         id_a,
         admin_level_a,
         name_a,
         id_b = parent_a,
         admin_level_b = admin_level,
         name_b = name,
         parent_b = parent_location_id)

n_4 <- left_join(n_5,locations_clean, by = c("parent_b" = "location_id")) %>%
  select(original_location_id,
         id_a,
         admin_level_a,
         name_a,
         id_b,
         admin_level_b,
         name_b,
         id_c = parent_b,
         admin_level_c = admin_level,
         name_c = name,
         parent_c = parent_location_id)

n_3 <- left_join(n_4,locations_clean, by = c("parent_c" = "location_id")) %>%
  select(original_location_id,
         id_a,
         admin_level_a,
         name_a,
         id_b,
         admin_level_b,
         name_b,
         id_c,
         admin_level_c,
         name_c,
         id_d = parent_c,
         admin_level_d = admin_level,
         name_d = name,
         parent_d = parent_location_id)

n_2 <- left_join(n_3,locations_clean, by = c("parent_d" = "location_id")) %>%
  select(original_location_id,
         id_a,
         admin_level_a,
         name_a,
         id_b,
         admin_level_b,
         name_b,
         id_c,
         admin_level_c,
         name_c,
         id_d,
         admin_level_d,
         name_d,
         id_e = parent_d,
         admin_level_e = admin_level,
         name_e = name,
         parent_e = parent_location_id)

n_1 <- left_join(n_2,locations_clean, by = c("parent_e" = "location_id")) %>%
  select(original_location_id,
         id_a,
         admin_level_a,
         name_a,
         id_b,
         admin_level_b,
         name_b,
         id_c,
         admin_level_c,
         name_c,
         id_d,
         admin_level_d,
         name_d,
         id_e,
         admin_level_e,
         name_e,
         id_f = parent_e,
         admin_level_f = admin_level,
         name_f = name,
         parent_f = parent_location_id)


hierarchy_join_renamed <- n_1 %>%
  mutate(admin_6 = case_when(
    admin_level_a == "6" ~ name_a
  ),
  id_6 = case_when(
    admin_level_a == "6" ~ id_a
  ),
  admin_5 = case_when(
    admin_level_b == "5" ~ name_b,
    admin_level_a == "5" ~ name_a
  ),
  id_5 = case_when(
    admin_level_b == "5" ~ id_b,
    admin_level_a == "5" ~ id_a
  ),
  admin_4 = case_when(
    admin_level_c == "4" ~ name_c,
    admin_level_b == "4" ~ name_b,
    admin_level_a == "4" ~ name_a
  ),
  id_4 = case_when(
    admin_level_c == "4" ~ id_c,
    admin_level_b == "4" ~ id_b,
    admin_level_a == "4" ~ id_a
  ),
  admin_3 = case_when(
    admin_level_d == "3" ~ name_d,
    admin_level_c == "3" ~ name_c,
    admin_level_b == "3" ~ name_b,
    admin_level_a == "3" ~ name_a
  ),
  id_3 = case_when(
    admin_level_d == "3" ~ id_d,
    admin_level_c == "3" ~ id_c,
    admin_level_b == "3" ~ id_b,
    admin_level_a == "3" ~ id_a
  ),
  admin_2 = case_when(
    admin_level_e == "2" ~ name_e,
    admin_level_d == "2" ~ name_d,
    admin_level_c == "2" ~ name_c,
    admin_level_b == "2" ~ name_b,
    admin_level_a == "2" ~ name_a
  ),
  id_2 = case_when(
    admin_level_e == "2" ~ id_e,
    admin_level_d == "2" ~ id_d,
    admin_level_c == "2" ~ id_c,
    admin_level_b == "2" ~ id_b,
    admin_level_a == "2" ~ id_a
    
  ),
  
  admin_1 = case_when(
    admin_level_f == "1" ~ name_f,
    admin_level_e == "1" ~ name_e,
    admin_level_d == "1" ~ name_d,
    admin_level_c == "1" ~ name_c,
    admin_level_b == "1" ~ name_b,
    admin_level_a == "1" ~ name_a
    
  ),
  
  id_1 = case_when(
    admin_level_f == "1" ~ id_f,
    admin_level_e == "1" ~ id_e,
    admin_level_d == "1" ~ id_d,
    admin_level_c == "1" ~ id_c,
    admin_level_b == "1" ~ id_b,
    admin_level_a == "1" ~ id_a
    
    
  ))


hierarchy_join_renamed <- hierarchy_join_renamed %>%
  
  select(original_location_id,
         admin_1,
         id_1,
         admin_2,
         id_2,
         admin_3,
         id_3
         # admin_4,
         # id_4,
         # admin_5,
         # id_5,
         # admin_6,
         # id_6
  ) %>%
  inner_join(locations_join_detail, by = c("original_location_id" = "location_id"))



## now we can attach this location data to the cases, contacts and follow ups         

followups_join <- left_join(followups_clean, hierarchy_join_renamed, by = c("location_id" = "original_location_id")) %>%
  select(-case_only,-contact_only, -both)

cases_join <- left_join(cases_clean_join, hierarchy_join_renamed, by = c("location_id" = "original_location_id")) %>%
  select(-case_only,-contact_only, -both)

contacts_join <- left_join(contacts_clean, hierarchy_join_renamed, by = c("location_id" = "original_location_id")) %>%
  select(-case_only,-contact_only, -both)



###############################################################



## Save files with a date of database
clean_folder <- here::here("data", "clean")


## export cases file as .csv 
cases_csv_file_name <- sprintf(
  "%sclean_%s.csv",
  "cases_",
  format(database_date, "%Y-%m-%d"))

cases_csv_file_name
rio::export(cases_join,
            file.path(clean_folder, cases_csv_file_name))


## export contacts file as csv
contacts_csv_file_name <- sprintf(
  "%sclean_%s.csv",
  "contacts_",
  format(database_date, "%Y-%m-%d"))

contacts_csv_file_name
rio::export(contacts_join,
            file.path(clean_folder, contacts_csv_file_name))


## export followups file as csv
followups_csv_file_name <- sprintf(
  "%sclean_%s.csv",
  "followups_",
  format(database_date, "%Y-%m-%d"))

followups_csv_file_name
rio::export(followups_join,
            file.path(clean_folder, followups_csv_file_name))


## export locations file as csv
location_csv_file_name <- sprintf(
  "%sclean_%s.csv",
  "location_",
  format(database_date, "%Y-%m-%d"))

location_csv_file_name
rio::export(hierarchy_join_renamed,
            file.path(clean_folder, location_csv_file_name))


## export relationship file as csv
relationships_csv_file_name <- sprintf(
  "%sclean_%s.csv",
  "relationships_",
  format(database_date, "%Y-%m-%d"))

relationships_csv_file_name
rio::export(relationships_clean,
            file.path(clean_folder, relationships_csv_file_name))


## export all as .rds files which we will use for report scripts as it preserves language characters better

rio::export(cases_join,
            file.path(clean_folder, 
                      "cases_clean.rds"))

rio::export(contacts_join,
            file.path(clean_folder, 
                      "contacts_clean.rds"))

rio::export(followups_join,
            file.path(clean_folder, 
                      "followups_clean.rds"))

rio::export(relationships_clean,
            file.path(clean_folder, 
                      "relationships_clean.rds"))

rio::export(hierarchy_join_renamed,
            file.path(clean_folder, 
                      "locations_clean.rds"))

rio::export(users_clean,
            file.path(clean_folder, 
                      "users_clean.rds"))