fpltCaseHighRiskGroups <- function(casepath){
  
  cases <- readRDS(casepath)

  cases_high_risk <- cases %>%
    mutate(
      health_worker_yes = case_when(occupation == "HEALTH_CARE_WORKER" |
                                      occupation == "HEALTH_LABORATORY_WORKER" ~ TRUE,
                                    TRUE ~ FALSE),
      health_worker_unknown = case_when(occupation == "UNKNOWN" |
                                          is.na(occupation) ~ TRUE,
                                        TRUE ~ FALSE),
      
      pregnant_yes = case_when(str_detect(pregnancy_status, "YES_") ~ TRUE,
                               TRUE ~ FALSE),
      
      pregnant_unknown = case_when(is.na(pregnancy_status) ~ TRUE,
                                   TRUE ~ FALSE),
      
      high_risk_yes = case_when(risk_level == "3_HIGH" ~ TRUE,
                                TRUE ~ FALSE),
      
      risk_unknown = case_when(is.na(risk_level) ~ TRUE,
                               TRUE ~ FALSE)
      
    ) %>%
    summarize(health_worker_yes = sum(health_worker_yes),
              health_worker_unknown = sum(health_worker_unknown),
              pregnant_yes = sum(pregnant_yes),
              pregnant_unknown = sum(pregnant_unknown),
              high_risk_yes = sum(high_risk_yes),
              risk_unknown = sum(risk_unknown),
              total = nrow(cases)) %>%
    mutate(
      health_worker_no = total - health_worker_yes - health_worker_unknown,
      pregnant_no = total - pregnant_yes - pregnant_unknown,
      high_risk_no = total - high_risk_yes - risk_unknown) %>%
    pivot_longer(-total,
                 names_to = "category", values_to = "count") %>%
    
    mutate(risk_factor = case_when(str_detect(category,"health_worker") ~ "Health Worker",
                                   str_detect(category,"pregnant") ~ "Pregnant",
                                   str_detect(category,"risk") ~ "Risk Level = `High`")
    ) %>%
    mutate(category = case_when(str_detect(category,"_yes") ~ "Yes",
                                str_detect(category,"_no") ~ "No",
                                str_detect(category,"_unknown") ~ "Unknown")
    ) %>%
    
    mutate(prop = (count/total*100)) %>%
    arrange(risk_factor, category)
  
  cases_high_risk$category <- factor(cases_high_risk$category, levels = c('Unknown','No','Yes'), ordered = TRUE)

  ggplot(cases_high_risk, aes(x = risk_factor, y = count, fill = category)) + 
    geom_col() +
    coord_flip() +
    labs(x = " ",
         y = "# of cases",
         # title = "Groups of interest among registered cases",
         subtitle = "Proportion of records with relevant fields marked YES") +
    theme_minimal() +
    theme(plot.title = element_text(size = 12, face = "bold"),
          plot.subtitle = element_text(size = 11)) +
    scale_fill_manual(
      values = c(
        "Yes" = "#ff5c33", 
        "No" = "#c2d6d6",
        "Unknown" = "#ADADAD"),
      guide = guide_legend(reverse = TRUE))  
}