#############################################################################
# Investigation de Cas - tableau
#############################################################################
## Follow this same logic and add however many vars you want, per case, and output using formattable package for easier reading

## case linelist, past 21 days

case_linelist <- current_clean_cases %>%
  filter(date_of_reporting >= prev_21_date) %>%
  mutate(date_of_outcome = case_when(!is.na(date_of_death) ~ date_of_death,
                          TRUE ~ date_of_outcome)) %>%
  mutate(safeburial = case_when(safeburial == "TRUE" ~ "oui",
                                 safeburial == "FALSE" ~ "non",
                           TRUE ~ NA)) %>%
  select(
        cas_id = visualid,
        nom = name,
        sexe = gender,
        age = age_years,
        classe_age = age_class,
        occupation,
        telephone = phone,
        classification,
        resultat = outcome_id,
        nombre_de_contacts = contacts_per_case,
        cas_source_connu = source_case_known,
        cas_source_id = source_case_contact_id,
        contact_connu = known_contact,
        etait_contact = was_contact_godata,
        date_dernier_contact = date_of_last_contact,
        date_devenir_cas = date_become_case,
        date_du_rapport = date_of_reporting,
        date_of_data_entry_go_data = date_of_data_entry,
        date_debut_symptomes = date_of_onset,
        date_du_resultat = date_of_outcome,
        date_isolement = date_of_isolation,
        # nom_du_centre = center_name,
        date_decede = date_of_death,
        enterrement_securise = safeburial,
        date_enterrement = date_of_burial,
        voyage = patient_travel,
        lien_parent = parent_link,
        statut_vaccinal = vaccinated,
        transfert_refuse = transferrefused,
        raison_risque = risk_reason,
        participer_funerailles = participate_funeral,
        lat,
        long,
        cellule,
        quartier,
        aire,
        zone,
        adresse = address,
        ville = city,
        endroit_patient_est_tombe = location_fell_ill)

### you can use this to calc % data completion; by listing in this "essential" dataframe all that you would except to be filled
### unless you can think of another way to do it.

case_linelist_essential <- case_linelist %>% 
  mutate_all(as.character) %>%
  # mutate_if(is_character, funs(na_if(.,""))) %>%
  mutate(fardeau_syndromique = difftime(date_du_resultat,date_debut_symptomes, units = "day")) %>%
      select(
        date_du_rapport,
        cas_id,
        nom,
        sexe,
        age,
        occupation,
        classification,
        resultat,
        nombre_de_contacts,
        cas_source_connu,
        contact_connu,
        date_dernier_contact,
        date_devenir_cas,
        date_debut_symptomes,
        # date_du_resultat,
        date_isolement,
        date_decede,
        fardeau_syndromique,
        # enterrement_securise,
        lien_parent,
        statut_vaccinal,
        lat,
        long,
        aire = ville,
        endroit_patient_est_tombe) 

case_linelist_essential$total_na <- 
  apply(case_linelist_essential,
                MARGIN = 1, function(x) sum(is.na(x)))

## Format for Prettier Output

tab_case_data_completion <- case_linelist_essential %>%
  mutate(aire = str_to_title(aire)) %>%
  mutate(cas_id = str_replace_all(cas_id, "_", "-")) %>%
  mutate(fardeau_syndromique = str_replace_na(fardeau_syndromique, replacement = "--" )) %>%
  mutate(nombre_de_contacts = str_replace_na(nombre_de_contacts, replacement = "--" )) %>%
  mutate(cas_id = str_replace_na(cas_id, replacement = "-" )) %>%
  mutate(perc_complete = 100- (total_na * 100 / 20)) %>%
  arrange(desc(date_du_rapport)) %>%
  mutate(isolement = case_when(!is.na(date_isolement) ~ "oui", TRUE ~ "non")) %>%
  mutate(perc_complete = paste0(perc_complete,"%")) %>%
  select(
          # `Aire de Santé` = aire, 
          `Location` = aire,
          `Date du rapport ` = date_du_rapport,
          `Cas ID` = cas_id, 
          `% de variables complèts` = perc_complete,
          `Fardeau syndromique` = fardeau_syndromique,
          `Isolée` = isolement,
          # `Enterrement securisé` = enterrement_securise,
          `Nombre de contacts répertoriés` = nombre_de_contacts) 

format_tab_case_data_completion <- tab_case_data_completion %>%
  mutate(
        `Location` = formatter("span", style = ~ formattable::style(
                            color = "grey",font.weight = "bold",font.style = "italic"))(`Location`),
        `% de variables complèts`= color_tile("white","green")(`% de variables complèts`),
        `Isolée` = formatter("span", style = ~ formattable::style(
                                       color = ifelse(`Isolée` == "non", "red", "green")))(`Isolée`)
        # `Enterrement securisé` = formatter("span", style = ~ formattable::style(
        #               color = ifelse(`Enterrement securisé` == "non", "red", "green")))(`Enterrement securisé`)
            ) %>%
  kable("html", escape = F, align =c("l","c","c", "c","c","c","c")) %>%
  kable_styling("hover", full_width = F) 

 format_tab_case_data_completion  


#############################################################################
# Statut de contacts par xxxx level (i.e. Superviseur) - tableau
#############################################################################

# Base Linelists for Follow Ups, Contacts & Cases 

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


### Calculating some statuses by scanning entire FU list, and then joining these to contact linelist

contacts_seen_ever <- daily_follow_up_linelist_21d %>%
  subset(seen == TRUE) %>%
  filter(!(contact_id == "")) %>%
  arrange(contact_id, desc(updated_at)) %>%
  distinct(contact_id, .keep_all = TRUE) %>%
  select(contact_id, date_of_followup, seen)

contacts_vaccinated_ever <- daily_follow_up_linelist_21d %>%
  subset(vaccinated == "oui") %>%
  filter(!(contact_id == "")) %>%
  arrange(contact_id, desc(updated_at)) %>%
  distinct(contact_id, .keep_all = TRUE) %>%
  select(contact_id, date_of_followup, vaccinated)
  

## Final contact linelist that has summarized statuses across all their follow ups
 
active_contacts_full_linelist <- contact_status_linelist %>%
  mutate(sup = str_replace_all(sup, "_", " ")) %>%
  mutate(sup = str_replace_all(sup, "sup", "")) %>%
  mutate(sup = str_to_title(sup)) %>%
  mutate(aire = str_to_title(aire)) %>%
  mutate(days_since_followup = difftime(database_date,date_dernier_visite, units = "day")) %>%
  mutate(days_since_exp = difftime(database_date,date_dernier_contact, units = "day")) %>%
  mutate(vu_avec_signes = case_when(
                                  statut_dernier_visite == "seen_with_signs" 
                                & date_dernier_visite == database_date ~ TRUE, 
                                  TRUE ~ FALSE)) %>%
  mutate(non_vu = case_when(
                                  statut_dernier_visite == "not_seen" 
                                & date_dernier_visite == database_date ~ TRUE, 
                                  TRUE ~ FALSE)) %>%
  mutate(pas_d_action = case_when(
                                  statut_dernier_visite == "not_performed" 
                                & date_dernier_visite == database_date ~ TRUE, 
                                  TRUE ~ FALSE)) %>%
  mutate(vaccine = (contact_status_linelist$contact_id %in% contacts_vaccinated_ever$contact_id)) %>%
  mutate(vu_sans_signes = case_when(
                                  statut_dernier_visite == "seen_no_signs" 
                                & date_dernier_visite == database_date ~ TRUE, 
                                  TRUE ~ FALSE)) %>%
  mutate(etait_cas = case_when(
                                  etait_cas == TRUE 
                                & date_dernier_visite == database_date ~ TRUE,
                                  TRUE ~ FALSE)) %>%
  mutate(perdu_vue = case_when(
                                  days_since_followup >= 3 ~ TRUE,
                                  TRUE ~ FALSE)) %>%
  mutate(deuxieme_semaine = case_when(
                                  days_since_exp < 15
                                  & days_since_exp >= 8 ~ TRUE,
                                  TRUE ~ FALSE)) %>%
  mutate(premiere_semaine = case_when(
                                  days_since_exp < 8 ~ TRUE,
                                  TRUE ~ FALSE)) %>%
  mutate(enterrement_securise = case_when(
                                  enterrement_securise == TRUE 
                                  & date_dernier_visite == database_date ~ TRUE, 
                                  TRUE ~ FALSE)) %>%
  mutate(jamais_vue = !(contact_status_linelist$contact_id %in% contacts_seen_ever$contact_id)) %>%
  mutate(decede = case_when(
                                  statut_dernier_visite == "decede"
                                & date_dernier_visite == database_date ~ TRUE,
                                   TRUE ~ FALSE)) %>%
  select(
    contact_id,
    nom,
    sexe,
    age,
    telephone,
    reco,
    sup,
    aire,
    zone,
    date_dernier_contact,
    deuxieme_semaine,
    premiere_semaine,
    date_contact_liste,
    date_dernier_visite,
    statut_dernier_visite,
    vu_avec_signes,
    vu_sans_signes,
    non_vu,
    pas_d_action,
    decede,
    vaccine,
    etait_cas,
    perdu_vue,
    jamais_vue,
    enterrement_securise
        )

active_per_sup_aire <- active_contacts_full_linelist %>%
  mutate(sup = str_replace_na(sup, replacement = "aucun correctement attribué" )) %>%
  group_by(sup, aire) %>%
  count()

## Formatting for prettier ouput

tab_active_contacts_status_daily <- active_contacts_full_linelist %>%
mutate(sup = str_replace_na(sup, replacement = "aucun correctement attribué" )) %>%
  group_by(sup, aire) %>%
  summarize(
        vu_avec_signes = sum(vu_avec_signes),
        vu_sans_signes = sum(vu_sans_signes),
        non_vu = sum(non_vu),
        pas_d_action = sum(pas_d_action),
        decede = sum(decede),
        vaccine = sum(vaccine),
        deuxieme_semaine = sum(deuxieme_semaine),
        premiere_semaine = sum(premiere_semaine),
        etait_cas = sum(etait_cas),
        perdu_vue = sum(perdu_vue),
        jamais_vue = sum(jamais_vue)
        ) 
  
tab_active_contacts_status_daily_join <-
sqldf('select *
                from tab_active_contacts_status_daily as tab
                  inner join active_per_sup_aire as active on tab.sup = active.sup 
                                                  AND tab.aire = active.aire 
                  ')  %>%
  setNames(., make.names(colnames(.), unique = TRUE)) %>%
  arrange(aire, sup) %>%
 
  
  dplyr::select(`Superviseur` = sup,
         `Aire de Santé` = aire,
         `Contacts actifs` = n,
         `Vu avec signes`= vu_avec_signes,
         `Vu sans signes` = vu_sans_signes,
         `Non vu` = non_vu,
         `Pas d'action` = pas_d_action,
         `Décédé` = decede,
         `Dans premiere semaine` = premiere_semaine,
         `Dans deuxieme semaine` = deuxieme_semaine,
         # `Est devenu un cas` = etait_cas,
         `Perdu vue` = perdu_vue,
         `Jamais vue` = jamais_vue,
         `Vacciné` = vaccine
         
         # `Enterrement sécuritaire` = safe_burial
        ) 

formattable_tab_active_contacts_status_daily_join <-tab_active_contacts_status_daily_join %>%
  
mutate(
  `Superviseur` = formatter("span", style = ~ formattable::style(
                    color = ifelse(`Superviseur` == "aucun correctement attribué", "red", "grey"),
                    font.weight = "bold",font.style = "italic"))(`Superviseur`),
  `Vu avec signes`= color_tile("white", custom_orange)(`Vu avec signes`),
  # `Est devenu un cas`= color_tile("white", "grey")(`Est devenu un cas`),
  `Perdu vue`= color_tile("white", custom_orange)(`Perdu vue`), 
  `Jamais vue`= color_tile("white", custom_red)(`Jamais vue`),
  `Vacciné`= color_tile("white", custom_green0)(`Vacciné`),
  `Décédé`= color_tile("white", custom_grey)(`Décédé`),
  `Contacts actifs` = color_tile("white", "lightgrey")(`Contacts actifs`)
          ) %>%
  # select(`Superviseur`, everything()) %>%
  kable("html", escape = F, align =c("l","l","c","c","c","c","c","c","c","c","c","c","c")) %>%
  kable_styling("hover", full_width = FALSE) %>%
  add_header_above(c(" " = 3, 
                    "Statut de la visite d'aujourd'hui" = 5,
                    "De contacts actifs" = 5))

formattable_tab_active_contacts_status_daily_join
