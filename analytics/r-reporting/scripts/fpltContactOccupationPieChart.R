fpltContactOccupationPieChart <- function(contactpath){
  
  contacts <- readRDS(contactpath)

  contacts$occupation <- as.factor(contacts$occupation)
  contact_unknown_occupation <- sum(is.na(contacts$occupation) | contacts$occupation == "UNKNOWN")
  contact_other_occupation <- sum(contacts$occupation == "OTHER", na.rm = TRUE)   ### why is this not working?? EO: need na.rm
  
  contact_occupation_breakdown <- contacts %>%
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
  
  color_count <- length(unique(contacts$occupation))
    getPalette <- colorRampPalette(brewer.pal(9, "Set1"))
  
  ggplot(subset(contact_occupation_breakdown, !is.na(occupation) & !(occupation == "OTHER")), aes(x = "", y = n, fill = occupation)) +
    geom_bar(width = 1, stat = "identity") +
    coord_polar("y", start = 0) +
    theme_minimal() +
    scale_fill_manual(values = getPalette(color_count)) +
    labs(
      fill = "Occupation",
      # title = "Occupational breakdown of COVID-19 contacts",
      subtitle = paste0("n = ", contact_unknown_occupation," without occupation recorded,", " n = ", contact_other_occupation," where 'OTHER'")
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