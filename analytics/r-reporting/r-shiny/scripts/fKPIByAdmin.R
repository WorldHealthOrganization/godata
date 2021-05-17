fKPIByAdmin <- function(variable = input$variable){
  
  tab_contact_status <- contact_linelist_status %>%
    # filter(!is.na(admin_2_name)) %>%
    group_by(.data[[variable]]) %>%
    summarize(
      total_reg_contacts = n(),
      contact_reg_last7d = sum(date_of_reporting >= prev_7_date),
      contact_reg_prev_last7d = sum(date_of_reporting >= before_prev_7_date & date_of_reporting < prev_7_date), # add perc:change
      total_contacts_became_case = sum(contact_status == "BECAME_CASE"), # % Became case
      total_active_contacts = sum(contact_status == "UNDER_FOLLOW_UP"),
      seen = sum(seen_with_signs + seen_without_signs), # add perc_seen
      # seen_with_signs = sum(seen_with_signs), 
      # seen_without_signs = sum(seen_without_signs),
      # missed = sum(missed),
      # no_action = sum(no_action),
      # second_week = sum(second_week_followup),
      # first_week = sum(first_week_followup),
      lost_to_followup = sum(lost_to_followup), # add perc_seen
      never_seen = sum(never_seen) # add perc_never_seen
    ) %>%
    mutate(
      perc_change_7d_contacts = round((contact_reg_last7d - contact_reg_prev_last7d)/contact_reg_prev_last7d*100,digits=1),
      perc_became_case = round(total_contacts_became_case*100 / total_reg_contacts,digits=1),
      perc_seen = round(seen*100 / total_active_contacts,digits=1),
      perc_not_yet_seen = round(never_seen*100 / total_active_contacts,digits=1),
      perc_lost_to_followup = round(lost_to_followup*100 / total_active_contacts,digits=1)) %>%
    arrange(variable) %>%
    select(
      `Admin` = variable,
      `Total Registered contacts` = total_reg_contacts,
      `% Became case` = perc_became_case,
      `New Contacts, Last 7d` = contact_reg_last7d,
      `% Weekly Change` = perc_change_7d_contacts,
      `Active contacts` = total_active_contacts,
      `% Followed` = perc_seen,
      `% Followed within 48hrs` = perc_seen,
      `% Not yet followed` = perc_not_yet_seen,
      `% Lost to follow up` = perc_lost_to_followup
    ) 
  
  tab_contact_status %>%
      mutate(
      `Admin` = formatter("span", style = ~ formattable::style(
        color = ifelse(`Admin` == "Non rapporté", "red", "grey"),
        font.weight = "bold",font.style = "italic"))(`Admin`),
      `New Contacts, Last 7d` = color_bar("#79C5FF")(`New Contacts, Last 7d`),
      `% Became case`= color_tile("white", "grey")(`% Became case`),
      `% Lost to follow up`= color_tile("white", "orange")(`% Lost to follow up`),
      `% Followed`= color_tile("white", "#E3FCEE")(`% Followed`), 
      `% Not yet followed`= color_tile("white", "#ff7f7f")(`% Not yet followed`)
    ) %>%
    # select(`Superviseur`, everything()) %>%
    kable("html", escape = F, align =c("l","c","c","c","c","c","c","c","c","c")) %>%
    kable_styling("hover", full_width = FALSE) %>%
    add_header_above(c(" " = 2, 
                       "Contact registration" = 4,
                       "Contact follow-up" = 4))
}
