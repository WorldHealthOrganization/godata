fpltCompletionOverTime <- function(){
  
  completion_rate_by_week <- case_linelist_essential %>%
    filter(date_of_reporting <= prev_7_date) %>%
    mutate(week_of_reporting = cut(date_of_reporting, breaks = "week")) %>%
    mutate(week_of_reporting = as.Date(week_of_reporting)) %>%
    group_by(week_of_reporting) %>%
    summarize(mean_case_completion = round(mean(100-perc_na),digits=1)) %>%
    ungroup() 

  completion_rates_by_week <- contact_linelist_essential %>%
    filter(date_of_reporting > "2020-01-01") %>%
    filter(date_of_reporting < prev_7_date) %>%
    mutate(week_of_reporting = cut(date_of_reporting, breaks = "2 weeks")) %>%
    mutate(week_of_reporting = as.Date(week_of_reporting)) %>%
    group_by(week_of_reporting) %>%
    summarize(mean_contact_completion = round(mean(100-perc_na),digits=1))  %>%
    ungroup() %>%
    inner_join(completion_rate_by_week, by = "week_of_reporting") %>%
    rename(contact_registration = mean_contact_completion,
           case_registration = mean_case_completion) %>%
    pivot_longer(-week_of_reporting, names_to = "type", values_to = "mean")
  
  ggplot(completion_rates_by_week, aes(x = week_of_reporting,  y = mean, color = type )) +
    geom_line(size = 1.3) +
    scale_x_date(date_labels = "%b-%d",
                 date_breaks = "2 weeks") +
    ylim(0,100) +
    theme_classic() +
    labs(x = "",
         y = "Avg % Data Completion",
         x = "Week of Reporting",
         # title = "Data Completion Over Time",
         subtitle = "Avg across core case contact variables") +
    theme(
      legend.position = "right",
      legend.title = element_text(size=10, face = "bold"),
      plot.title = element_text(size=12, face = "bold"),
      plot.subtitle = element_text(size=11),
      plot.caption = element_text(size = 8, face = "italic"),
      axis.text.x = element_text(angle = 45, hjust = 1)) 
}