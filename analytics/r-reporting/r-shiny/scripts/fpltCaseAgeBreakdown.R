fpltCaseAgeBreakdown <- function(casepath){
  
  cases <- readRDS(casepath)

  # ==========================================================================================================================
  # Case age breakdown over time
  cases$date_of_reporting <- as.Date(cases$date_of_reporting)
  
  cases_per_week <- cases %>%
    filter(age_class != "unknown") %>%
    mutate(iso_week = isoweek(date_of_reporting)) %>%
    # filter(iso_week < database_week & iso_week >= 20) %>% # TODO: removed for testing purposes
    group_by(iso_week) %>%
    summarise(weekly_total = n()) 
  
  cases$age_class_v2 <- fct_collapse(cases$age_class, 
                                     "0-4" = c("0-4"), 
                                     "5-14" = c("5-9", "10-14"), 
                                     "15-39" = c("15-19", "20-29","30-39"), 
                                     "40-64" = c("40-49", "50-59","60-64"), 
                                     "65-79" = c("65-69", "70-74","75-79"),
                                     "80+" = "80+")
  
  case_age_breakdown_over_time <- cases %>%
    mutate(iso_week = isoweek(date_of_reporting)) %>%
    filter(age_class != "unknown",
           iso_week < database_week) %>%
    # iso_week >= (database_week-15)) %>%
    mutate(week_of_reporting = as.Date(cut(date_of_reporting, breaks = "week"))) %>%
    group_by(week_of_reporting, iso_week, age_class_v2) %>%
    summarise(count = n()) %>%
    ungroup() %>%
    inner_join(cases_per_week, by = "iso_week") %>%
    mutate(prop = count/weekly_total*100)
  
  ggplot(case_age_breakdown_over_time, aes(x = week_of_reporting, y = count, fill = age_class_v2)) +
    geom_line(size = 1.3) +
    geom_area(aes(fill = age_class_v2), colour = "white") +
    scale_fill_viridis(discrete = T, option = "magma") +
    scale_x_date(date_breaks = "2 weeks",
                 date_labels = "%b %d",
                 limits = c(min(case_age_breakdown_over_time$week_of_reporting), max(case_age_breakdown_over_time$week_of_reporting))) +
    ylim(0,NA) +
    theme_minimal() +
    labs(x = "",
         y = "",
         fill = "Age group",
         # title = "Age breakdown of COVID-19 cases by reporting week",
         subtitle = paste0("n = ", case_unknown_age, " with no age recorded")
    ) + 
    theme(
      legend.title = element_text(size=10, face = "bold"),
      plot.title = element_text(size=12, face = "bold"),
      axis.ticks.y.left = element_line(size = 0.5, colour = "grey"),
      axis.ticks.x = element_blank(),
      axis.title.y = element_text(size = 12),
      axis.text.x = element_text(angle = 45, hjust = 1),
      plot.subtitle = element_text(size=11),
      plot.caption = element_text(size = 8, face = "italic"),
      panel.grid.major.y = element_line(size = 0.2, colour = "grey"),
      panel.grid = element_blank())
}
