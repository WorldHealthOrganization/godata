---
layout: page
parent: Data Visualization
grand_parent: Analytics & Dashboards
title: R
nav_order: 1
permalink: /R/
---

# Go.Data dashboards in R

## General R resources for field epidemiology analyses
- We are thrilled to have supported the development of The Epidemiologist R Handbook for use in applied epidemiology and public health: https://epirhandbook.com/
- Written for epidemiologists by epidemiologists, this free, open-access manual provides sample R code and tutorials addressing a wide variety of data management and visualization tasks with practical epidemiological examples. It is available in an offline version for use in settings with low internet-connectivity, and is great for those looking to transition to R from SAS, Stata, SPSS or Excel.
- Regardless of tool used for data capture, management and analysis, we believe it can be an excellent resource for those doing field-level epidemiological analysis.
- Of note, this handbook includes how-to steps on how you might visualize Contact Tracing using sample Go.Data output, in the "Contact Tracing" page. It also discusses how you could connect to the Go.Data API in the "Import and Export" page.

## Scripts for automated reporting and HTML dashboards using `flexdashboard`
- [See the R Reporting page](https://github.com/WorldHealthOrganization/godata/blob/master/analytics/r-reporting) documentation which contains a script to easily connect to API and extract relevant database collections directly into your R console 

![r-reporting-workflow](../assets/R_reporting_workflow.PNG)

## RShiny infrastructure
- [See this repo](https://github.com/WorldHealthOrganization/godata/tree/master/analytics/r-reporting/r-shiny) for in-progress reference RShiny app to provide more interactive components for filtering and drilling down into data on a more granular basis.The template 
- This serves to provide an example so that countries who would like host it on their Go.Data server can take it and adapt it with minimal updates required.

## Go.Data R Package
- _coming soon_ we are looking for collaborators who would like to develop Go.Data specific packages to ease data analyses and use! Please email godata@who.int if you are interested.




