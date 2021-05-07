fpltCompletionRelationships <- function(relationshippath){
  
  relationships <- readRDS(relationshippath)

  completion_table_relationships <- relationships %>%
    transmute(
      source_visualid = case_when(is.na(source_visualid) ~ FALSE, TRUE ~ TRUE),
      target_visualid = case_when(is.na(target_visualid) ~ FALSE, TRUE ~ TRUE),
      exposure_type = case_when(is.na(exposure_type) ~ FALSE, TRUE ~ TRUE),
      context_of_exposure = case_when(is.na(context_of_exposure) ~ FALSE, TRUE ~ TRUE),
      exposure_frequency = case_when(is.na(exposure_frequency) ~ FALSE, TRUE ~ TRUE),
      certainty_level = case_when(is.na(certainty_level) ~ FALSE, TRUE ~ TRUE),
      exposure_duration = case_when(is.na(exposure_duration) ~ FALSE, TRUE ~ TRUE),
      date_of_last_contact = case_when(is.na(date_of_last_contact) ~ FALSE, TRUE ~ TRUE),
      relation_detail = case_when(is.na(relation_detail) ~ FALSE, TRUE ~ TRUE),
      cluster = case_when(is.na(cluster) ~ FALSE, TRUE ~ TRUE))
  
  completion_table_relationships_pivot <- completion_table_relationships %>%
    mtabulate() %>%
    tibble::rownames_to_column("variable") %>%
    pivot_longer(-variable, names_to = "completed", values_to = "count") %>%
    arrange(variable, desc(count))

  ggplot(completion_table_relationships_pivot, aes(x = variable, y = count, fill = completed)) + 
    geom_col() +
    coord_flip() +
    labs(x = " ",
         y = "# of records",
         # title = "Overall Data completion rate across core COVID-19 Relationship variables",
         subtitle = "Not including configurable questionnaire variables") +
    theme(plot.title = element_blank(),
          plot.subtitle = element_text(size = 10)) +
    scale_completion +
    theme_minimal()  
  
}