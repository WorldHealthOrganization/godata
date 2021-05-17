# Original:
library(shiny); library(shinydashboard); library(ggplot2); library(survival); library(scales); library(dplyr); library(epiR)
# Additions:
library(here); library(lubridate); library(forcats); library(viridis); library(RColorBrewer); library(tidyverse)
library(kableExtra); library(formattable); library(qdapTools)

# Set up ==========================================================================================================================

# Run only when you need to import or update data. Will take a while to run, so comment out when not needed.
source(here("report_sources/01_data_import_api.R"))
source(here("report_sources/02_clean_data_api.R"))
source(here("scripts/set_variables.R"))

server <- function(input, output, server){

  # Header ==========================================================================================================================
  
  output$vboxTotalCases <- renderValueBox({
    valueBox(
      total_cases_reg,
      "Total confirmed cases",
      icon = icon("user-plus", lib = "font-awesome"),
      color = "orange"
      ) 
  })
  
  output$vboxNewCases <- renderValueBox({
    valueBox(
      cases_reg_last7d,
      "New cases, last 7d",
      color = "green" # Temp color, look into library(fresh) and adminlte_color() for customisation
    )
  })
  
  # output$vboxCasesContactList <- renderValueBox({
  #   valueBox(
  #     paste0(perc_from_known_contact, "%"),
  #     "Cases from known contacts",
  #     color = "green"
  #   )
  # })
  
  output$vboxCasesDiedRecovered <- renderValueBox({
    valueBox(
      paste0(cases %>% filter(outcome_id == "DECEASED") %>% count(),
             " / ",
             cases %>% filter(outcome_id == "RECOVERED") %>% count()),
      "Cases from known contacts",
      color = "green"
    )
  })
  
  output$vboxActiveContacts <- renderValueBox({
    valueBox(
      contact_linelist_status %>% filter(contact_status == "UNDER_FOLLOW_UP") %>% count(),
      icon = icon("users", lib = "font-awesome"),
      "Active contacts",
      color = "orange"
    )
  })
  
  # output$vboxNewContacts <- renderValueBox({
  #   valueBox(
  #     contacts %>% filter(date_of_reporting >= prev_7_date) %>% count(),
  #     "New contacts listed, last 7d",
  #     color = "green"
  #   )
  # })
  
  output$vboxContactsFollowed <- renderValueBox({
    valueBox(
      paste0(perc_contacts_active_followed, "%"),
      "Contacts followed",
      color = "green"
    )
  })
  
  output$vboxContactsLost <- renderValueBox({
    valueBox(
      paste0(perc_contacts_active_ltfu, "%"),
      "Contacts followed",
      color = "green"
    )
  })
  
  # Demographics ==========================================================================================================================

  # Case demographics
  output$pltCaseAgeBreakdown <- renderPlot({
    source(here("scripts/fpltCaseAgeBreakdown.R"))
    fpltCaseAgeBreakdown(casepath = here("data/cases_clean.rds"))
  })
  
  output$pltCaseAgeSexPyramid <- renderPlot({
    source(here("scripts/fpltCaseAgeSexPyramid.R"))
    fpltCaseAgeSexPyramid(casepath = here("data/cases_clean.rds"))
  })
  
  output$pltCaseOccupationPieChart <- renderPlot({
    source(here("scripts/fpltCaseOccupationPieChart.R"))
    fpltCaseOccupationPieChart(casepath = here("data/cases_clean.rds"))
  })
  
  output$pltCaseHighRiskGroups <- renderPlot({
    source(here("scripts/fpltCaseHighRiskGroups.R"))
    fpltCaseHighRiskGroups(casepath = here("data/cases_clean.rds"))
  })
  
  # Contact demographics
  output$pltContactAgeBreakdown <- renderPlot({
    source(here("scripts/fpltContactAgeBreakdown.R"))
    fpltContactAgeBreakdown(contactpath = here("data/contacts_clean.rds"))
  })
  
  output$pltContactAgeSexPyramid <- renderPlot({
    source(here("scripts/fpltContactAgeSexPyramid.R"))
    fpltContactAgeSexPyramid(contactpath = here("data/contacts_clean.rds"))
  })
  
  output$pltContactOccupationPieChart <- renderPlot({
    source(here("scripts/fpltContactOccupationPieChart.R"))
    fpltContactOccupationPieChart(contactpath = here("data/contacts_clean.rds"))
  })
  
  output$pltContactHighRiskGroups <- renderPlot({
    source(here("scripts/fpltContactHighRiskGroups.R"))
    fpltContactHighRiskGroups(contactpath = here("data/contacts_clean.rds"))
  })

  # KPIs ========================================================================================================================== 

  output$tblAdminArea <- reactive({
    source(here("scripts/fKPIByAdmin.R"))
    fKPIByAdmin(variable = input$variable)
  })
  
  # Data Quality ========================================================================================================================== 

  output$pltCompletionCases <- renderPlot({
    source(here("scripts/fpltCompletionCases.R"))
    fpltCompletionCases(casepath = here("data/cases_clean.rds"))
  })
  
  output$pltCompletionContacts <- renderPlot({
    source(here("scripts/fpltCompletionContacts.R"))
    fpltCompletionContacts()
  })
  
  output$pltCompletionRelationships <- renderPlot({
    source(here("scripts/fpltCompletionRelationships.R"))
    fpltCompletionRelationships(relationshippath = here("data/relationships_clean.rds"))
  })
  
  output$pltCompletionOverTime <- renderPlot({
    source(here("scripts/fpltCompletionOverTime.R"))
    fpltCompletionOverTime()
  })
}
  