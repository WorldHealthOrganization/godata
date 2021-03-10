# Automated R Reporting Using Go.Data API for EVD Guinée

![](https://github.com/WorldHealthOrganization/godata/blob/master/docs/assets/R_reporting_workflow.PNG)

Below we will outline instructions for running R scripts to produce field-level dashboards to display EVD Contact Tracing Performance using R, connected to the Go.Data API.
This process will provide you with cleaned, flattened excel files and HTML dashboard outputs that can be adapted for various audiences or settings. 

## NOTE: this builds on already existing SOP [here](https://github.com/WorldHealthOrganization/godata/blob/master/analytics/r-reporting/README.md). Other prerequisites are:
- Download R (version 3.6.1 or higher is recommended) here: https://www.r-project.org/
- Obtain valid Go.Data login credentials for the instance you are accessing, with the minimum permissions to _view_ data collections you are trying to extract (i.e if you want to extract laboratory data, you need the "Laboratory Personnel" role)
- Create folder directory on your local machine matching what is outlined in the SOP in an easily accessible place on your computer (i.e. Desktop)

## [DOCUMENTATION](https://docs.google.com/spreadsheets/d/1QIUKMPgbu98IrvDI2atdgTybA4CzbbPbr7NPTtQwZ3M/edit#gid=1896084498)
- Contains Data Dictionary for EVD Go.Data outbreak
- Contains Indicator Dictionary (indicator definitions, variables required for each calculation)
- Assumptions, inclusion/exclusion criteria for calculations if any
- Mockups of Time Periods & Levels of Granularity Breakdowns
- Breakdown of R tasks

## Please follow the following steps in order to use the data and the dashboard

   ## Step 1. Replicate folder directory to your local machine
In order for the scripts to work it is essential for you to have the same folder hierarchy and contents. Your folder directory should include:
- data (_a place for csv and rds file outputs to be stored_)
- scripts (_containing starter scripts and parameters, like necessary packages to be loaded or formatting, that are sourced in the report sources scripts_).
- report_sources (_contains script to import; script to clean; script to product dashboard_)
- reprt_outputs (_a place for dashboard outputs to be stored_)
- R project (_double click here to open R; so that each time your working directory is properly set_)

![](https://github.com/WorldHealthOrganization/godata/blob/joaquin_b/analytics/country_use_cases/godata-evd/R_folder_hierarchy.PNG)
