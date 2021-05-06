fpltCaseOccupationPieChart <- function(casepath){
  
  cases <- readRDS(casepath)

  cases$occupation <- as.factor(cases$occupation)
  case_unknown_occupation <- sum(is.na(cases$occupation) | cases$occupation == "UNKNOWN")
  case_other_occupation <- sum(cases$occupation == "OTHER", na.rm = TRUE)   ### why is this not working?? EO: you had some NAs in here, need to specify what to do with them
  
  case_occupation_breakdown <- cases %>%
    # filter(!is.na(occupation),
    #        occupation != "OTHER") %>%
    group_by(occupation) %>%
    count() %>%
    arrange(desc(n)) 
  # case_occupation_breakdown_plot_freq <- 
  #   ggplot(subset(case_occupation_breakdown, !is.na(occupation)), aes(x = occupation, y = n)) +
  #   geom_bar(stat = "identity") +
  #   coord_flip() +
  #   theme_classic()
  
  color_count <- length(unique(cases$occupation))
  getPalette <- colorRampPalette(brewer.pal(9, "Set1"))
  
  ggplot(subset(case_occupation_breakdown, !is.na(occupation) & !(occupation == "OTHER")), aes(x = "", y = n, fill = occupation)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start = 0) +
  theme_minimal() +
  scale_fill_manual(values = getPalette(color_count)) +
  labs(
    fill = "Occupation",
    # title = "Occupational breakdown of COVID-19 cases",
    subtitle = paste0("n = ", case_unknown_occupation," without occupation recorded,", " n = ", case_other_occupation," where 'OTHER'")
  ) +
  theme(axis.line = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        legend.position = "right",
        legend.title = element_text(size=10, face = "bold"),
        plot.title = element_text(size=12, face = "bold"),
        plot.subtitle = element_text(size=11),
        plot.caption = element_text(size = 8, face = "italic"))

}