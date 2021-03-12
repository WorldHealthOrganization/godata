#############################################################################
# Bar Charts showing FU status by diff admin levels 
#############################################################################
## Very simple ggplot but mostly just formatting here in case you want to re-use

## Set Databsae date to yesterday (or today)
database_date <- Sys.Date() -1 

## Set FU Status Columns so they are not dropped if they don't appear
statuscols <- c(decede = 0, 
                seen_with_signs = 0, 
                seen_no_signs = 0,
                not_seen = 0,
                not_performed = 0)
                

## Set FU Status Color & Labeling for Graphs
scale_status <- scale_fill_manual(
    "Statut",
    values = c(seen            = "#71CA97",
               not_seen        = "#5d6d75",
               not_performed   = "#D3C9C6",
               seen_no_signs   = "#A0E2BD",
               seen_with_signs = "#E94B25",
               decede          = "#020202"),
                
    labels = c(seen            = "Vu",
               not_seen        = "Non Vu",
               not_performed   = "Pas d'action",
               seen_no_signs   = "Vu sans signes",
               seen_with_signs = "Vu avec signes",
               decede          = "Décédé"))
                

## daily follow ups, past 21 days
daily_follow_up_linelist_21d <- current_clean_followups %>%
  arrange(desc(date_of_followup)) %>%
  select(date_of_followup,
         contact_id = visual_id,
         status,
         seen,
         reco,
         sup,
         team,
         cellule,
         quartier,
         aire,
         zone,
         follow_up_number,
         updated_at,
         vaccinated
         )
         
## FUs from today or yesterday only, which we will use for tables otherwise so many rows and not performant
fu_subset <- daily_follow_up_linelist_21d %>%
  filter(date_of_followup == database_date |
         date_of_followup == prev_1_date) %>%
  arrange(contact_id, desc(updated_at)) %>%
  distinct(contact_id, .keep_all = TRUE) 

## contact linelist, active (follow up end date equal to or after database_date)
contact_status_linelist <- 
  left_join(current_clean_contacts,fu_subset, by = c("visualid" = "contact_id")) %>%
  select(
    contact_id = visualid,
    statut_followup = followup_status,
    nom = name,
    sexe = gender,
    age = age_years,
    classe_age = age_class,
    occupation,
    telephone = phone,
    date_dernier_contact = date_of_last_contact,
    date_dernier_visite = date_of_followup,
    date_contact_liste = date_of_data_entry,
    reco = reco.x,
    sup = sup.x,
    aire = aire.x,
    zone = zone.x,
    enterrement_securise = safeburial,
    statut_dernier_visite = status,
    statut_vaccinal = vaccinated,
    etait_cas = wascase) 

## By Aire:

contact_status_by_aire <- contact_status_linelist %>%
  mutate(aire = str_to_title(aire)) %>%
  filter(date_dernier_visite == database_date) %>%
  group_by(aire, statut_dernier_visite) %>%
  tally() %>%
  pivot_wider(names_from = statut_dernier_visite, values_from = n, values_fill = list(n=0)) %>%
  add_column(!!!statuscols[!names(statuscols)%in% names(.)]) %>%                                      ## forcing in status columns that might have been dropped
  gather("daily_status", "n", -aire) %>%
  arrange(aire, daily_status) 


graph_contact_status_by_aire <-
    contact_status_by_aire %>%
    ggplot(aes(x = reorder(aire, n), y = n, fill = daily_status, label = ifelse(n>0, n, NA))) +
    geom_col(position = "stack") +
    coord_flip() +
    theme_classic() +
    labs(x = "",
         y = "Nombre de contacts",
         title = "Statut de contacts quotidien, par aire",
         subtitle = paste0("Donnees jusq'a ", database_date, "\n")) +
  theme(plot.title = element_text(face = "bold", color = "#011822", size = 14),
        plot.subtitle = element_text(size = 11, color = "#011822")
        # ,legend.position = "top"
        ) +
  geom_text(size = 3, position = position_stack(vjust = 0.5), color = "white", check_overlap = TRUE, fontface = "bold") +
  scale_status +
    # scale_x_discrete(drop = TRUE) +
    # facet_wrap(~aire, strip.position = "right", scales = "free_y", ncol = 1) +
    # facet_grid(.~zone, scales = "free_y", space = "free", drop = TRUE) +
    theme(panel.spacing = unit(1, "lines"), 
         strip.background = element_blank(),
         strip.placement = "outside")  

graph_contact_status_by_aire
