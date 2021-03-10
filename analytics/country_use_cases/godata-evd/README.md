# Automated R Reporting Using Go.Data API for EVD Guinée

![](https://github.com/WorldHealthOrganization/godata/blob/master/docs/assets/R_reporting_workflow.PNG)

Below we will outline instructions for running R scripts to produce field-level dashboards to display EVD Contact Tracing Performance using R, connected to the Go.Data API.
This process will provide you with cleaned, flattened excel files and HTML dashboard outputs that can be adapted for various audiences or settings. 

## NOTE: this builds on already existing SOP [here](https://github.com/WorldHealthOrganization/godata/blob/master/analytics/r-reporting/README.md). Other prerequisites are:
- Download R (version 3.6.1 or higher is recommended) here: https://www.r-project.org/
- Obtain valid Go.Data login credentials for the instance you are accessing, with the minimum permissions to _view_ data collections you are trying to extract (i.e if you want to extract laboratory data, you need the "Laboratory Personnel" role)
- Create folder directory on your local machine matching what is outlined in the SOP in an easily accessible place on your computer (i.e. Desktop)

## DOCUMENTATION:

### [Google Sheet with Data Dictionary & Indicator Dictionary outlining variables used, inclusion/exclusion criteria, calculations](https://docs.google.com/spreadsheets/d/1lZzfBUtMRwSVTs6IZpLxPBk0UMVXPWhAPFXRgwr11mo/edit#gid=1896084498)
