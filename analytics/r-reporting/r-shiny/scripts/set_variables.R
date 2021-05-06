# ========================================================================================================================== 
# IMPORT
cases <- readRDS(here("data/cases_clean.rds"))
contacts <- readRDS(here("data/contacts_clean.rds"))
relationships <- readRDS(here("data/relationships_clean.rds"))
followups <- readRDS(here("data/followups_clean.rds"))
users <- readRDS(here("data/users_clean.rds"))

# ========================================================================================================================== 
# TIME PERIODS
database_date <- Sys.Date()  
database_week <- lubridate::isoweek(database_date) 
prev_1_date <- database_date - 1
prev_7_date <- prev_1_date - 7
before_prev_7_date <- prev_7_date - 7

# ========================================================================================================================== 
# GRAPHIC THEMES
custom_green0 = "#E3FCEE"
custom_green = "#71CA97"
custom_red0 = "#FFAAAA"
custom_red = "#ff7f7f"
custom_grey0 = "#ADADAD"
custom_grey = "#818181"
custom_orange0 = "#FFD6CA"
custom_orange = "#FF9270"
custom_blue0 = "#79C5FF"
custom_blue = "#004F8B"
godata_orange = "#ff884d"
godata_green = "#4db0a0"

scale_status <- scale_fill_manual(
  "Statut",
  values = c(seen            = "#71CA97",
             not_seen        = "#5d6d75",
             not_performed   = "#D3C9C6",
             seen_no_signs   = "#A0E2BD",
             seen_with_signs = "#E94B25",
             missed          = "#020202"),
  
  labels = c(seen            = "Vu",
             not_seen        = "Absent",
             not_performed   = "Pas d'action",
             seen_no_signs   = "Vu sans signes",
             seen_with_signs = "Vu avec signes",
             missed          = "Décédé"))

statuscols <- c(missed = 0, 
                seen_with_signs = 0, 
                seen_no_signs = 0,
                not_seen = 0,
                not_performed = 0)

completioncols <- c(completed = 0,
                    partial = 0,
                    not_attempted = 0)

scale_completion <- scale_fill_manual(
  name = "Completed",
  values = c("#E94B25",
             "#ABADAB"),
  labels = c("Incomplete",
             "Completed"))

scale_risk_factors <- scale_fill_manual(
  name = "Status",
  values = c("#ff5c33",
             "#c2d6d6",
             custom_grey0),
  labels = c("Yes",
             "No",
             "Unknown"))

# ========================================================================================================================== 
# Case line list
data_collector_names <- users %>%
  mutate(data_collector_name = paste0(firstname, " ", lastname)) %>%
  select(uuid,data_collector_name)
### case linelist core vars that are not required
### here, we have 19 essential vars that are not required....
case_linelist_essential <- cases %>%
  # filter(classification != "NOT_A_CASE_DISCARDED") %>%
  # mutate(source_case_known = case_when(
  #             is.na(source_visualid) ~ FALSE,
  #             source_visualid == "" ~ FALSE,
  #             TRUE ~ TRUE)) %>%
  mutate_if(is_character, funs(na_if(.,""))) %>%
  select(
    uuid,
    # case_id,
    # classification,
    # gender,
    age,
    # age_class,
    occupation,
    pregnancy_status,
    # was_contact,
    risk_level,
    # risk_reason,
    outcome = outcome_id,
    # contacts_per_case,
    # source_case_known,
    source_case_id = source_visualid,
    date_of_last_contact,
    # date_become_case,
    date_of_reporting,
    # date_of_data_entry,
    date_of_infection,
    date_of_onset,
    admin_1_name,
    admin_2_name,
    admin_3_name,
    # lat,
    # long,
    address,
    telephone,
    email,
    city,
    postal_code,
    hospitalization_status,
    isolation_status,
    createdBy
  ) %>%
  left_join(data_collector_names, by = c("createdBy" = "uuid")) %>%
  select(-createdBy)

case_linelist_essential$total_na <- apply(case_linelist_essential, 
                                          MARGIN = 1, function(x) sum(is.na(x))) 

# calculate % NA of required
case_linelist_essential <- case_linelist_essential %>% 
  mutate(perc_na = round((total_na / 20) * 100, digits = 1))

# ========================================================================================================================== 
# Contact line list
fu_subset <- followups %>%
  # filter(date_of_followup == prev_1_date) %>%
  arrange(contact_uuid, desc(date_of_followup)) %>%
  distinct(contact_uuid, .keep_all = TRUE) 

## contact linelist, with info about last visit and who turn into cases 
## all contacts registered historically, not just currently active contacts
contact_linelist_essential <- contacts %>%
  select(
    uuid, 
    contact_id,
    contact_status,
    gender,
    age,
    # age_class,
    occupation,
    pregnancy_status,
    risk_level,
    date_of_reporting,
    date_of_last_contact,
    # date_of_followup_start,
    # date_of_followup_end,
    # date_become_case,
    admin_1_name,
    admin_2_name,
    admin_3_name,
    address,
    city,
    postal_code,
    telephone,
    email,
    createdBy
    ) %>%
  left_join(data_collector_names, by = c("createdBy" = "uuid")) %>%
  select(-createdBy)

contact_linelist_essential$total_na <- apply(contact_linelist_essential,
                                             MARGIN = 1, function(x) sum(is.na(x))) 

contact_linelist_essential <- contact_linelist_essential %>%
  mutate(perc_na = round((total_na / 20) * 100, digits = 1))

contacts_seen_ever <- followups %>%
  filter(followup_status == "SEEN_OK" | followup_status == "SEEN_NOT_OK") %>%
  arrange(contact_uuid, desc(date_of_followup)) %>%
  distinct(contact_uuid, .keep_all = TRUE) %>%
  select(uuid = contact_uuid,
         contact_id, 
         date_of_last_followup_seen = date_of_followup)

contacts_last_visit <- followups %>%
  arrange(contact_uuid, desc(date_of_followup)) %>%
  distinct(contact_uuid, .keep_all = TRUE) %>%
  select(uuid = contact_uuid,
         contact_id, 
         date_of_last_followup = date_of_followup,
         status_of_last_followup = followup_status)
# could do same thing for contacts vaccinated ever

contact_linelist_status <- contact_linelist_essential %>%
  # filter(contact_status == "UNDER_FOLLOW_UP") %>%
  left_join(select(contacts_seen_ever, uuid, date_of_last_followup_seen), by = "uuid") %>%
  left_join(select(contacts_last_visit, uuid, date_of_last_followup, status_of_last_followup), by = "uuid") %>%
  mutate_if(is_character, funs(na_if(.,""))) %>%
  mutate(days_since_followup_seen = difftime(database_date,
                                             date_of_last_followup_seen, 
                                             units = "day")) %>%
  mutate(days_since_exp = difftime(database_date,
                                   date_of_last_contact, 
                                   units = "day")) %>%
  mutate(seen_with_signs = case_when(
    status_of_last_followup == "SEEN_NOT_OK" ~ TRUE,
    # & date_of_last_followup == database_date ~ TRUE,
    TRUE ~ FALSE)) %>%
  mutate(seen_without_signs = case_when(
    status_of_last_followup == "SEEN_OK" ~ TRUE,
    # & date_of_last_followup == database_date ~ TRUE,
    TRUE ~ FALSE)) %>%
  mutate(missed = case_when(
    status_of_last_followup == "MISSED" ~ TRUE,
    # & date_of_last_followup == database_date ~ TRUE,
    TRUE ~ FALSE)) %>%
  mutate(no_action = case_when(
    (status_of_last_followup == "NOT_ATTEMPTED" |
       status_of_last_followup == "NOT_PERFORMED" ) ~ TRUE,
    # & date_of_last_followup == database_date ~ TRUE,
    TRUE ~ FALSE)) %>%
  # mutate(vaccine = (contact_status_linelist$contact_id %in% contacts_vaccinated_ever$contact_id)) %>%
  mutate(lost_to_followup = case_when(
    days_since_followup_seen >= 3 ~ TRUE,
    TRUE ~ FALSE)) %>%
  mutate(second_week_followup = case_when(
    days_since_exp < 15
    & days_since_exp >= 8 ~ TRUE,
    TRUE ~ FALSE)) %>%
  mutate(first_week_followup = case_when(
    days_since_exp < 8 ~ TRUE,
    TRUE ~ FALSE)) %>%
  mutate(never_seen = !(uuid %in% contacts_seen_ever$uuid)) 

# ========================================================================================================================== 
# HEADER

# Total cases
total_cases_reg <- cases %>% count()

## New cases, last 7 days
cases_reg_last7d <- cases %>%
  filter(date_of_reporting >= prev_7_date) %>%
  count()
cases_reg_prev_last7d <- cases %>%
  filter(date_of_reporting >= before_prev_7_date & date_of_reporting < prev_7_date) %>%
  count()
perc_change_7d <- round(((cases_reg_last7d - cases_reg_prev_last7d) / cases_reg_prev_last7d)*100, digits = 0) 
perc_change_7d <- sprintf("%+3.0f %%", perc_change_7d)

# Cases from contact list
cases_from_known_contact <- cases %>%
  filter(was_contact) %>%
  count()
cases_from_known_contact_last7d <- cases %>%
  filter(date_of_reporting >= prev_7_date) %>%
  filter(was_contact) %>%
  count()
perc_from_known_contact <-
  round((cases_from_known_contact / total_cases_reg)*100, digits = 1)
perc_from_known_contact_last7d <-
  round((cases_from_known_contact_last7d / cases_reg_last7d)*100, digits = 1)

# Cases died / recovered
cases_died <- cases %>%
  filter(outcome_id == "DECEASED") %>%
  count()
cases_recovered <- cases %>%
  filter(outcome_id == "RECOVERED") %>%
  count()

# Active contacts
total_contacts_reg <- contact_linelist_status %>%
  count() 
contacts_active <- contact_linelist_status %>%
  filter(contact_status == "UNDER_FOLLOW_UP") %>%
  count() 

# New contacts listed, last 7 days
contacts_reg_last7d <- contacts %>%
  filter(date_of_reporting >= prev_7_date) %>%
  count()
contacts_reg_prev_last7d <- contacts %>%
  filter(date_of_reporting >= before_prev_7_date & date_of_reporting < prev_7_date) %>%
  count()
perc_change_7d_contacts <- round(((contacts_reg_last7d - contacts_reg_prev_last7d) / contacts_reg_prev_last7d)*100, digits = 0) 
perc_change_7d_contacts <- sprintf("%+3.0f %%", perc_change_7d_contacts)

# Contacts followed
contacts_active_followed <- contact_linelist_status %>%
  filter(contact_status == "UNDER_FOLLOW_UP") %>%
  filter(seen_with_signs | seen_without_signs) %>%
  count()
perc_contacts_active_followed <-
  round((contacts_active_followed/contacts_active)*100,digits = 1)

# Contacts lost to follow up
contacts_active_ltfu <- contact_linelist_status %>%
  filter(contact_status == "UNDER_FOLLOW_UP") %>%
  filter(lost_to_followup) %>%
  count()
perc_contacts_active_ltfu <-
  round((contacts_active_ltfu/contacts_active)*100,digits = 1)

# Case Age Breakdown
case_unknown_age <- sum(cases$age_class == "unknown")
case_unknown_sex <- sum(is.na(cases$gender))
case_with_age_and_sex <- sum(!is.na(cases$gender) & cases$age_class != "unknown") 

# Contact Age Sex pyramid
contact_unknown_age <- sum(contacts$age == "unknown")
contact_unknown_sex <- sum(is.na(contacts$gender))
contact_with_age_and_sex <- sum(!is.na(contacts$gender) & contacts$age_class != "unknown") 