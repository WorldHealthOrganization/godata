fpltCompletionContacts <- function(){
  
completion_table_contacts <- contact_linelist_essential %>%
  transmute(
    contact_id = case_when(is.na(contact_id) ~ FALSE, TRUE ~ TRUE),
    gender = case_when(is.na(gender) ~ FALSE, TRUE ~ TRUE),
    age = case_when(is.na(age) ~ FALSE, TRUE ~ TRUE),
    occupation = case_when(is.na(occupation) ~ FALSE, TRUE ~ TRUE),
    contact_status = case_when(is.na(contact_status) ~ FALSE, TRUE ~ TRUE),
    pregnancy_status = case_when(is.na(pregnancy_status) ~ FALSE, TRUE ~ TRUE),
    risk_level = case_when(is.na(risk_level) ~ FALSE, TRUE ~ TRUE),
    date_of_last_contact = case_when(is.na(date_of_last_contact) ~ FALSE, TRUE ~ TRUE),
    admin_1 = case_when(is.na(admin_1_name) ~ FALSE, TRUE ~ TRUE),
    admin_2 = case_when(is.na(admin_2_name) ~ FALSE, TRUE ~ TRUE),
    admin_3 = case_when(is.na(admin_3_name) ~ FALSE, TRUE ~ TRUE),
    address = case_when(is.na(address) ~ FALSE, TRUE ~ TRUE),
    city = case_when(is.na(city) ~ FALSE, TRUE ~ TRUE),
    telephone = case_when(is.na(telephone) ~ FALSE, TRUE ~ TRUE),
    email = case_when(is.na(email) ~ FALSE, TRUE ~ TRUE),
    postal_code = case_when(is.na(postal_code) ~ FALSE, TRUE ~ TRUE),
    risk_level = case_when(is.na(risk_level) ~ FALSE, TRUE ~ TRUE))

completion_table_contacts_pivot <- completion_table_contacts %>%
  mtabulate() %>%
  tibble::rownames_to_column("variable") %>%
  pivot_longer(-variable, names_to = "completed", values_to = "count") %>%
  arrange(variable, desc(count))

ggplot(completion_table_contacts_pivot, aes(x = variable, y = count, fill = completed)) + 
  geom_col() +
  coord_flip() +
  labs(x = " ",
       y = "# of records",
       # title = "Overall Data completion rate across core COVID-19 contact registration variables",
       subtitle = "Not including configurable questionnaire variables") +
  theme(plot.title = element_blank(),
        plot.subtitle = element_text(size = 10)) +
  scale_completion +
  theme_minimal()   

}