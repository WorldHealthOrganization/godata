fpltCompletionCases <- function(casepath){
  
  cases <- readRDS(casepath)
  
  completion_table_cases <- cases %>%
    transmute(
      case_id = case_when(is.na(case_id) ~ FALSE, TRUE ~ TRUE),
      classification = case_when(is.na(classification) ~ FALSE, TRUE ~ TRUE),
      gender = case_when(is.na(gender) ~ FALSE, TRUE ~ TRUE),
      age = case_when(is.na(age) ~ FALSE, TRUE ~ TRUE),
      occupation = case_when(is.na(occupation) ~ FALSE, TRUE ~ TRUE),
      pregnancy_status = case_when(is.na(pregnancy_status) ~ FALSE, TRUE ~ TRUE),
      outcome = case_when(is.na(outcome_id) ~ FALSE, TRUE ~ TRUE),
      date_of_infection = case_when(is.na(date_of_infection) ~ FALSE, TRUE ~ TRUE),
      date_become_case = case_when(is.na(date_become_case) ~ FALSE, TRUE ~ TRUE),
      date_of_onset = case_when(is.na(date_of_onset) ~ FALSE, TRUE ~ TRUE),
      date_of_outcome = case_when(is.na(date_of_outcome) ~ FALSE, TRUE ~ TRUE),
      admin_1 = case_when(is.na(admin_1_name) ~ FALSE, TRUE ~ TRUE),
      admin_2 = case_when(is.na(admin_2_name) ~ FALSE, TRUE ~ TRUE),
      admin_3 = case_when(is.na(admin_3_name) ~ FALSE, TRUE ~ TRUE),
      address = case_when(is.na(address) ~ FALSE, TRUE ~ TRUE),
      city = case_when(is.na(city) ~ FALSE, TRUE ~ TRUE),
      postal_code = case_when(is.na(postal_code) ~ FALSE, TRUE ~ TRUE),
      telephone = case_when(is.na(telephone) ~ FALSE, TRUE ~ TRUE),
      isolation = case_when(is.na(isolation_typeid) ~ FALSE, TRUE ~ TRUE),
      hospitalization = case_when(is.na(hospitalization_typeid) ~ FALSE, TRUE ~ TRUE),
      risk_level = case_when(is.na(risk_level) ~ FALSE, TRUE ~ TRUE),
      source_visualid = case_when(is.na(source_visualid) ~ FALSE, TRUE ~ TRUE)
    )
  
  completion_table_cases_pivot <- completion_table_cases %>%
    qdapTools::mtabulate() %>%
    tibble::rownames_to_column("variable") %>%
    pivot_longer(-variable, names_to = "completed", values_to = "count") %>%
    arrange(variable, desc(count))
  
  ggplot(completion_table_cases_pivot, aes(x = variable, y = count, fill = completed)) + 
    geom_col() +
    coord_flip() +
    labs(x = " ",
         y = "# of records",
         # title = "Overall Data completion rate across core COVID-19 case variables",
         subtitle = "Not including configurable questionnaire variables") +
    theme(axis.line = element_blank(),
          axis.title = element_blank(),
          axis.text = element_blank(),
          legend.position = "right",
          legend.title = element_text(size=10, face = "bold"),
          plot.title = element_text(size=12, face = "bold"),
          plot.subtitle = element_text(size=11),
          plot.caption = element_text(size = 8, face = "italic")) +
    scale_completion + 
    theme_classic()
}