#############################################################################
# Investigation de Cas - tableau
#############################################################################
## Follow this same logic and add however many vars you want, per case, and output using formattable package for easier reading
## case linelist, past 21 days
ls(current_clean_cases)


case_linelist <- current_clean_cases %>%
  #filter(date_of_reporting >= prev_21_date) %>%
 # mutate(date_of_outcome = case_when(!is.na(date_of_death) ~ date_of_death,
 #                         TRUE ~ date_of_outcome)) %>%
 # mutate(safeburial = case_when(safeburial == "TRUE" ~ "oui",
 #                                safeburial == "FALSE" ~ "non",
 #                          TRUE ~ NA)) %>%
  select(
        cas_id = case_id,
        nom = full_name,
        sexe = gender,
        age = age,
        classe_age = age_class,
        occupation,
        #telephone = phone,
        classification,
        resultat = outcome_id,
        # nombre_de_contacts = contacts_per_case,
        # cas_source_connu = source_case_known,
        # cas_source_id = source_case_contact_id,
        #  contact_connu = known_contact,
        etait_contact = was_contact,
        #date_dernier_contact = date_of_last_contact,
        #date_devenir_cas = date_become_case,
        date_du_rapport = date_of_reporting,
        #date_of_data_entry_go_data = date_of_data_entry,
        date_debut_symptomes = date_of_onset,
        date_du_resultat = date_of_outcome,
        #date_isolement = date_of_isolation,
        # nom_du_centre = center_name,
        #date_decede = date_of_death,
        #enterrement_securise = safeburial,
        #date_enterrement = date_of_burial,
        #voyage = patient_travel,
        #lien_parent = parent_link,
        #statut_vaccinal = vaccinated,
        #transfert_refuse = transferrefused,
        #raison_risque = risk_reason,
        #participer_funerailles = participate_funeral,
        #lat,
        #long,
        #cellule,
        #quartier,
        aire = sous_prefecture )#,
        #zone,
        #adresse = address,
        #ville = city,
        #endroit_patient_est_tombe = location_fell_ill)

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
        #nombre_de_contacts,
        #cas_source_connu,
        #contact_connu,
        #date_dernier_contact,
        #date_devenir_cas,
        #date_debut_symptomes,
        # date_du_resultat,
        #date_isolement,
        #date_decede,
        fardeau_syndromique,
        # enterrement_securise,
        #lien_parent,
        #statut_vaccinal,
        #lat,
        #long,
        aire, # = sous_prefecture,
        #endroit_patient_est_tombe
        ) 

case_linelist_essential$total_na <- 
  apply(case_linelist_essential,
                MARGIN = 1, function(x) sum(is.na(x)))

## Format for Prettier Output


tab_case_data_completion <- case_linelist_essential %>%
  mutate(aire = str_to_title(aire)) %>%
  mutate(cas_id = str_replace_all(cas_id, "_", "-")) %>%
  mutate(occupation = str_replace_all(occupation, "_", " ")) %>%
  mutate(occupation = tolower(occupation)) %>%
  mutate(fardeau_syndromique = str_replace_na(fardeau_syndromique, replacement = "--" )) %>%
  #mutate(nombre_de_contacts = str_replace_na(nombre_de_contacts, replacement = "--" )) %>%
  mutate(cas_id = str_replace_na(cas_id, replacement = "-" )) %>%
  mutate(perc_complete = 100- (total_na * 100 / 20)) %>%
  arrange(desc(date_du_rapport)) %>%
  #mutate(isolement = case_when(!is.na(date_isolement) ~ "oui", TRUE ~ "non")) %>%
  mutate(perc_complete = paste0(perc_complete,"%")) %>%
  select(
          # `Aire de Santé` = aire, 
    
          `Date du rapport` = date_du_rapport,
          `Cas ID` = cas_id, 
          `Nom` = nom, 
          `Age` = age, 
          `Sexe` = sexe, 
          `Profession` = occupation, 
          `Sous prefecture` = aire,
          #`% de variables complèts` = perc_complete,
          #`Fardeau syndromique` = fardeau_syndromique,
          #`Isolée` = isolement,
          # `Enterrement securisé` = enterrement_securise,
          #`Nombre de contacts répertoriés` = nombre_de_contacts
          ) 

format_tab_demographics <- tab_case_data_completion %>%
  mutate(
        `Quartier` = formatter("span", style = ~ formattable::style(
                            color = "grey",font.weight = "bold",font.style = "italic"))(`Quartier`),
        #`% de variables complèts`= color_tile("white","green")(`% de variables complèts`),
        #`Isolée` = formatter("span", style = ~ formattable::style(
        #                               color = ifelse(`Isolée` == "non", "red", "green")))(`Isolée`)
        # `Enterrement securisé` = formatter("span", style = ~ formattable::style(
        #               color = ifelse(`Enterrement securisé` == "non", "red", "green")))(`Enterrement securisé`)
            ) %>%
  kable("html", escape = F, align =c("l","c","c", "c","c","c","c")) %>%
  kable_styling("hover", full_width = F) 

format_tab_demographics  
