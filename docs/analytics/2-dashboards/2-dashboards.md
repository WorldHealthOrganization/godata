---
layout: page
title: Data Visualization
parent: Analytics & Dashboards
nav_order: 2
permalink: /dashboards/
has_children: true
---

# Dashboards/Visualizations connected to Go.Data Instance
There are a number of options for connectors and technical resources to viusalize your data outside of the application if more advanced analysis is required above and beyond the basic in-app dashboards. See the pages below to find more information.

![](../assets/analytics_connectors.PNG)

## R
### RMarkdown Dashboards using `flexdashboard`
- [See the R Reporting page](https://github.com/WorldHealthOrganization/godata/blob/master/analytics/r-reporting) documentation which contains a script to easily connect to API and extract relevant database collections directly into your R console 

![r-reporting-workflow](../assets/R_reporting_workflow.PNG)

### R Shiny App
Coming soon
{: .label .label-yellow }
- [See this repo](https://github.com/WorldHealthOrganization/godata/tree/master/analytics/r-reporting/r-shiny) for in-progress reference RShiny app to provide more interactive components for filtering and drilling down into data on a more granular basis.The template 
- This serves to provide an example so that countries who would like host it on their Go.Data server can take it and adapt it with minimal updates required.

### R Capacity Building
- For more resources on how to learn and use R for outbreak analysis, you can refer to the *The Epidemiologist R Handbook* - [https://epirhandbook.com/](https://epirhandbook.com/)
- Written for epidemiologists by epidemiologists, this free, open-access manual provides sample R code and tutorials addressing a wide variety of data management and visualization tasks with practical epidemiological examples. It is available in an offline version for use in settings with low internet-connectivity, and is great for those looking to transition to R from SAS, Stata, SPSS or Excel.
- Regardless of tool used for data capture, management and analysis, we believe it can be an excellent resource for those doing field-level epidemiological analysis.
- Of note, this handbook includes how-to steps on how you might visualize Contact Tracing using sample Go.Data output, in the "Contact Tracing" page. It also discusses how you could connect to the Go.Data API in the "Import and Export" page.

## PowerBI
Coming soon
{: .label .label-yellow }
-The soon-to-be-published PowerBI manual and .pbxix files are intended to guide Go.Data users on how to connect to your Go.Data instance to generate tailormade dashboards.
 
![powerbi-1-cases](../assets/powerbi_dash1_cases.png)

## Google Data Studio
Country use case
{: .label .label-purple }
For monitoring of COVID-19 cases and contact tracing in Kosovo, Google DataStudio was used (outputs below)
![](../assets/googledatastudio-kosovo-1.png)

Purpose/ objectives: 
1.	To contribute to informing the general public on the current COVID-19 epidemiological situation.
2.	Contribute to information sharing with the general public and other stakeholders to support decision making for the COVID-19 response activities

The pipeline involved:
1. Query Go.Data API with Python script
2. Recode, clean, filter, aggregrate, in Python
3. Store aggregated output in private Google Spreadsheet
4. Add necessary information manually, not collected in Go.Data
5. Push to Google DataStudio

![](../assets/kosovo-data-flow.png)

To view full resources and scripts, please view the repo [here](https://github.com/WorldHealthOrganization/godata/tree/master/analytics/country_use_cases/godata-Kosovo)

## Tableau
Country use case
{: .label .label-purple }
For monitoring of COVID-19 cases and contact tracing at UT Austin, Talbeau is used as a data visualization and performance monitoring tool.

To view full resources and scripts, please view the repo [here](https://github.com/WorldHealthOrganization/godata/tree/master/analytics/country_use_cases/godata-universityoftexas)

## PandasGUI 
Country use case
{: .label .label-purple }
The team at Canton Vaud developed a Python/Pandas interface for their Go.Data implementation to more easily fetch data from Go.Data and use it as a Pandas dataframe.

See Github directory:[https://github.com/WorldHealthOrganization/pygodata](https://github.com/WorldHealthOrganization/pygodata)

## Excel
Coming soon
{: .label .label-yellow }
