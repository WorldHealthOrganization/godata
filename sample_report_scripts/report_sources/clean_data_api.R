## This script is for cleaning the Go data data for COVID - core variables


# check to see which of these are actually needed, take out those that are not.
path_to_functions <- here::here("scripts")
scripts_files <- dir(path_to_functions, pattern = ".R$", full.names=TRUE)
for (file in scripts_files) source(file, local = TRUE)

## Load data from API R tibbles

## We use rio package (r input output) for reading in the data

database_date <- Sys.Date()

followups <- followups %>%
  as_tibble()

cases <- cases %>%
  as_tibble()


contacts <- contacts %>%
  as_tibble()

relationships <- relationships %>%
  as_tibble()

teams <- teams %>%
  as_tibble()

users <- users %>%
  as_tibble()

## follow up data, under follow up, active, not deleted, also unnest all nested fields, only select necessary var

followups_clean <- followups %>%
  filter(deleted == FALSE) %>%
  filter(contact.active == TRUE) %>%
  unnest(c(
    contact.addresses,
    contact.followUpHistory,
    contact.vaccinesReceived
    ), 
          
            keep_empty = TRUE, names_sep = "_")  %>%
  clean_data(guess_dates = FALSE) %>%
  select(
    date_of_followup = date,
    createdat,
    visual_id = contact_visualid,
    uuid = id,
    contact_id,
    person_id = personid,
    statusid,
    follow_up_number = index,
    team_id = teamid,
    updated_at = updatedat,
    location_id = contact_addresses_locationid
    # vaccinated = contact_vaccinesreceived_contact_vaccinesreceived, not working for now

  ) %>%
  
  mutate(date_of_followup = guess_dates(date_of_followup),
         date_of_data_entry = guess_dates(createdat)
         ) %>%
  mutate(status = case_when(
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_decede" ~ "decede",
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_missed" ~ "not_seen",
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_not_seen" ~ "not_seen",
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_not_attempted" ~ "not_performed",
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_not_performed" ~ "not_performed",
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_seen_not_ok" ~ "seen_with_signs",
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_seen_ok" ~ "seen_no_signs"
  )) %>%
  mutate(performed = case_when(
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_decede" ~ "TRUE",
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_missed" ~ "TRUE",
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_not_seen" ~ "TRUE",
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_seen_not_ok" ~ "TRUE",
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_seen_ok" ~ "TRUE",
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_not_attempted" ~ "FALSE",
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_not_performed" ~ "FALSE"
  )) %>%
  mutate(seen = case_when(
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_decede" ~ "TRUE",
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_missed" ~ "FALSE",
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_not_seen" ~ "FALSE",
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_seen_not_ok" ~ "TRUE",
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_seen_ok" ~ "TRUE",
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_not_attempted" ~ "FALSE",
    statusid == "lng_reference_data_contact_daily_follow_up_status_type_not_performed" ~ "FALSE"
  ))


  
## cases data, under follow up, active, not deleted, 
## also unnest all nested fields
## also bring in only reg fields we need

#   classe_age = age_class,
#   nombre_de_contacts = contacts_per_case,
#   cas_source_connu = source_case_known,
#   contact_connu = known_contact,

#   date_isolement = date_of_isolation,
#   date_decede = date_of_death,

#   voyage = patient_travel,
#   lien_parent = parent_link,
#   statut_vaccinal = vaccinated,
#   raison_risque = risk_reason,
#   participer_funerailles = participate_funeral,

#   endroit_patient_est_tombe = location_fell_ill)

cases_clean <- cases %>%
  filter(deleted == FALSE) %>%
  select(-questionnaireAnswers.LienDeParente) %>%
  unnest(c(
    addresses,
    dateRanges
    # questionnaireAnswers.numeroIDcasIndex,
    # questionnaireanswers_liendeparente
    ), 
    
    keep_empty = TRUE, names_sep = "_") %>%
  clean_data(guess_dates = FALSE) %>%
  mutate(name = paste0(firstname, "_", lastname)) %>%
  mutate_at(vars(contains("date")), as.character) %>%
  mutate(date_of_reporting = guess_dates(dateofreporting),
         date_of_data_entry = guess_dates(createdat),
         date_of_onset = guess_dates(dateofonset),
         date_of_outcome = guess_dates(dateofoutcome), 
         date_of_last_contact = guess_dates(dateoflastcontact), 
         date_become_case = guess_dates(datebecomecase)) %>%
  mutate(age_years = case_when(
    is.na(age_years) && !is.na(age_months) ~  as.integer(age_months / 12),
    is.na(age_years) && is.na(age_months) ~  NA_integer_,
    TRUE ~ age_years)) %>%
  select(
    uuid = id,
    location_id = addresses_locationid,
    address = addresses_addressline1,
    city = addresses_city,
    visual_id = visualid,
    name,
    gender,
    age_years,
    occupation,
    classification,
    telephone = addresses_phonenumber,
    outcome_id = outcomeid,
    source_case_contact_id = questionnaireanswers_numeroidcasindex,
    pregnancy_status = pregnancystatus,
    was_contact_godata = wascontact,
    date_of_reporting,
    date_of_data_entry,
    date_of_onset,
    date_of_outcome,
    date_of_last_contact,
    date_become_case,
    outcome = dateranges_typeid,
    date_of_hosp_isolation_start = dateranges_startdate,
    date_of_hosp_isolation_end = dateranges_enddate,
    transferrefused,
    safe_burial = safeburial,
    risk_level = risklevel
  ) %>%
  filter(classification != "lng_reference_data_category_case_classification_not_a_case_discarded") %>%
  mutate(classification = case_when(
    classification == "lng_reference_data_category_case_classification_confirmed" ~ "confirmed",
    classification == "lng_reference_data_category_case_classification_suspect"  ~ "suspect",
    classification == "lng_reference_data_category_case_classification_probable" ~ "probable"
  )) %>%
  mutate(gender = case_when(
    gender == "lng_reference_data_category_gender_female" ~ "femme",
    gender == "lng_reference_data_category_gender_male" ~ "homme"
  )) %>%
  mutate(occupation = case_when(
    occupation == "lng_reference_data_category_occupation_business_person" ~ "business_person",
    occupation == "lng_reference_data_category_occupation_child" ~ "child",
    occupation == "lng_reference_data_category_occupation_civil_servant" ~ "civil_servant",
    occupation == "lng_reference_data_category_occupation_health_laboratory_worker" ~ "laboratory_worker",
    occupation == "lng_reference_data_category_occupation_farmer" ~ "farmer",
    occupation == "lng_reference_data_category_occupation_health_care_worker" ~ "health_care_worker",
    occupation == "lng_reference_data_category_occupation_housewife" ~ "housewife",
    occupation == "lng_reference_data_category_occupation_miner" ~ "miner",
    occupation == "lng_reference_data_category_occupation_other" ~ "other",
    occupation == "lng_reference_data_category_occupation_religious_leader" ~ "religous_leader",
    occupation == "lng_reference_data_category_occupation_student" ~ "student",
    occupation == "lng_reference_data_category_occupation_taxi_driver" ~ "taxi_driver",
    occupation == "lng_reference_data_category_occupation_unknown" ~ "unknown"
  )) %>%
  mutate(outcome_id = case_when(
    outcome_id == "lng_reference_data_category_outcome_alive" ~ "vivant",
    outcome_id == "lng_reference_data_category_outcome_deceased" ~ "decede",
    outcome_id == "lng_reference_data_category_outcome_guerison_virologique" ~ "virologique"
  )) %>%
  
  mutate(risk_level = case_when(
    risk_level == "lng_reference_data_category_risk_level_1_low" ~ "low",
    risk_level == "lng_reference_data_category_risk_level_2_medium" ~ "medium",
    risk_level == "lng_reference_data_category_risk_level_3_high" ~ "high"
  )) %>%
  
  mutate(outcome = case_when(
    outcome == "lng_reference_data_category_person_date_type_hospitalization" ~ "hospitalization",
    outcome == "lng_reference_data_category_person_date_type_isolement_a_domicile" ~ "isolation_home",
    outcome == "lng_reference_data_category_person_date_type_isolation" ~ "isolation",
    TRUE ~ as.character(NA)

  ))
  # mutate(epiweek_report_label = aweek::date2week(date_of_reporting,
  #                                                week_start = "Monday",
  #                                                floor_day = TRUE),
  #        epiweek_report = aweek::week2date(epiweek_report_label,
  #                                          week_start = "Monday")) 
  # mutate(
  #   age = as.numeric(age_years),
  #   age_class = factor(
  #     case_when(
  #       age <= 5 ~ "<=5",
  #       age <= 10 ~ "6-10",
  #       age <= 17 ~ "11-17",
  #       age <= 25 ~ "18-25",
  #       age <= 35 ~ "26-35",
  #       age <= 45 ~ "36-45",
  #       age <= 55 ~ "46-55",
  #       age <= 65 ~ "56-65",
  #       is.finite(age) ~ "66+",
  #       TRUE ~ "unknown"
  #     ), levels = c(
  #       "<=5",
  #       "6-10",
  #       "11-17",
  #       "18-25",
  #       "26-35",
  #       "36-45",
  #       "46-55",
  #       "56-65",
  #       "66+",
  #       "unknown"
  #     )),
  #   age_class_plot = factor(
  #     age_class,
  #     levels = rev(levels(age_class))))
  

## active contacts, currently under follow up (using follow up end date in case the status is off, as it sometimes is.); 
## also unnest all nested fields;
## also bring in only req varibles for current analysis to declutter

contacts_clean <- contacts %>%
  filter(deleted == FALSE) %>%
  filter(active == TRUE) %>%
  filter(as.Date.character(followUp.endDate) >= date(database_date)) %>%
  filter(followUp.status == "LNG_REFERENCE_DATA_CONTACT_FINAL_FOLLOW_UP_STATUS_TYPE_UNDER_FOLLOW_UP") %>%
  unnest(c(
    addresses,
    followUpHistory,
    vaccinesReceived
          ), 
  
  keep_empty = TRUE, names_sep = "_") %>%
  clean_data(guess_dates = FALSE) %>%
  mutate(name = paste0(firstname, "_", lastname)) %>%
  mutate_at(vars(contains("date")), as.character) %>%
    mutate(date_of_reporting = guess_dates(dateofreporting),
           date_of_data_entry = guess_dates(createdat),
           date_of_last_contact = guess_dates(dateoflastcontact),
           date_of_followup_start = guess_dates(followup_startdate),
           date_of_followup_end = guess_dates(followup_enddate)) %>%
  mutate(age_years = case_when(
    is.na(age_years) && !is.na(age_months) ~  as.integer(age_months / 12),
    is.na(age_years) && is.na(age_months) ~  NA_integer_,
    TRUE ~ age_years)) %>%
  select(
    contact_id = visualid,
    name,
    followup_status,
    risk_level = risklevel,
    uuid = id,
    # vaccinated = vaccinesreceived,
    age_years,
    location_id = addresses_locationid,
    city = addresses_city,
    address = addresses_addressline1,
    gender,
    occupation,
    telephone = addresses_phonenumber,
    date_of_reporting,
    date_of_data_entry,
    date_of_last_contact,
    date_of_followup_end,
    safe_burial = safeburial,
    was_case = wascase
  ) %>%
  
  mutate(followup_status = case_when(
    followup_status == "lng_reference_data_contact_final_follow_up_status_type_follow_up_completed" ~ "completed",
    followup_status == "lng_reference_data_contact_final_follow_up_status_type_under_follow_up" ~ "under_follow_up"
  )) %>%
  mutate(gender = case_when(
    gender == "lng_reference_data_category_gender_female" ~ "femme",
    gender == "lng_reference_data_category_gender_male" ~ "homme"
  )) %>%
  mutate(occupation = case_when(
    occupation == "lng_reference_data_category_occupation_business_person" ~ "business_person",
    occupation == "lng_reference_data_category_occupation_child" ~ "child",
    occupation == "lng_reference_data_category_occupation_civil_servant" ~ "civil_servant",
    occupation == "lng_reference_data_category_occupation_health_laboratory_worker" ~ "laboratory_worker",
    occupation == "lng_reference_data_category_occupation_farmer" ~ "farmer",
    occupation == "lng_reference_data_category_occupation_health_care_worker" ~ "health_care_worker",
    occupation == "lng_reference_data_category_occupation_housewife" ~ "housewife",
    occupation == "lng_reference_data_category_occupation_miner" ~ "miner",
    occupation == "lng_reference_data_category_occupation_other" ~ "other",
    occupation == "lng_reference_data_category_occupation_religious_leader" ~ "religous_leader",
    occupation == "lng_reference_data_category_occupation_student" ~ "student",
    occupation == "lng_reference_data_category_occupation_taxi_driver" ~ "taxi_driver",
    occupation == "lng_reference_data_category_occupation_unknown" ~ "unknown"
  )) %>%
  mutate(epiweek_report_label = aweek::date2week(date_of_reporting,
                                                 week_start = "Monday",
                                                 floor_day = TRUE),
         epiweek_report = aweek::week2date(epiweek_report_label,
                                           week_start = "Monday")) 
  # mutate(age = case_when(is.na(age_years) ~ NA_integer_,
  #                        TRUE ~ as.numeric(age_years))) %>%
  # mutate(
  #   age = as.numeric(age_years),
  #   age_class = factor(
  #     case_when(
  #       age <= 5 ~ "<=5",
  #       age <= 10 ~ "6-10",
  #       age <= 17 ~ "11-17",
  #       age <= 25 ~ "18-25",
  #       age <= 35 ~ "26-35",
  #       age <= 45 ~ "36-45",
  #       age <= 55 ~ "46-55",
  #       age <= 65 ~ "56-65",
  #       is.finite(age) ~ "66+",
  #       TRUE ~ "unknown"
  #     ), levels = c(
  #       "<=5",
  #       "6-10",
  #       "11-17",
  #       "18-25",
  #       "26-35",
  #       "36-45",
  #       "46-55",
  #       "56-65",
  #       "66+",
  #       "unknown"
  #     )),
  #   age_class_plot = factor(
  #     age_class,
  #     levels = rev(levels(age_class))))



# relationships
relationships_clean <- relationships %>%
  filter(Deleted == FALSE)  %>%  ## check to see why variable names are diff here even directly from api, that is super annoying
  clean_data(guess_dates = FALSE)


## locations - rearrange via joins to get into more usable hierarchy format
locations_clean <- locations %>%
  filter(deleted == FALSE) %>%
  clean_data(guess_dates = FALSE) %>%
  select(location_id = id,
         admin_level = geographicallevelid,
         name,
         parent_location_id = parentlocationid
  )

## teams
teams_clean <- teams %>%
  filter(deleted == FALSE) %>%
  unnest(userIds, keep_empty = TRUE) %>%
  unnest(locationIds, keep_empty = TRUE) %>%
  clean_data(guess_dates = FALSE) %>%
  select(uuid = id,
         name,
         userids,
         locationids
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


## user list (something wrong with outbreak IDs here, they are not of common type) (will same contact tracers be doing both ebola and COVID? )
users_clean <- users %>%
  filter(deleted == FALSE) %>%
  # filter(activeOutbreakId == outbreak_id) %>%
  unnest(roleIds, keep_empty = TRUE) %>%
  clean_data(guess_dates = FALSE) %>%
  select(uuid = id,
         firstname,
         lastname
  )


## some other modifications

contacts_per_case <- relationships_clean %>%
  group_by(source_case_contact_id, source_uid) %>%
  tally() %>%
  select(source_case_contact_id, 
         source_uid,
         contacts_per_case = n)



cases_clean <- cases_clean %>%
            left_join(contacts_per_case, by = c("uuid" = "source_uid")) %>%
            # left_join(contacts_per_case, by = c("visual_id" = "source_case_contact_id")) %>%
            select(
              -source_case_contact_id.x,
                -source_case_contact_id.y) %>%
              # -(38:47)) %>%
            left_join(select(relationships_clean, source_uid, target_uid, source_case_contact_id), by = c("uuid" = "target_uid"))
              

  
#################################################################

## Clean locations
## Look in clean_locations script for this

clean_locations <- here::here('scripts/clean_locations.R')
source(clean_locations)


###############################################################

followups_join <- followups_join %>%
  select(-visual_id.x) %>%
  rename(visual_id = visual_id.y)


## Save files with a date of database
clean_folder <- here::here("data", "clean")


## export cases file as csv
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


## export team file as csv
teams_csv_file_name <- sprintf(
  "%sclean_%s.csv",
  "teams_",
  format(database_date, "%Y-%m-%d"))

teams_csv_file_name
rio::export(teams_clean,
            file.path(clean_folder, teams_csv_file_name))

