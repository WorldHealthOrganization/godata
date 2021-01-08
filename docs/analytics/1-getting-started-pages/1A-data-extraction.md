---
layout: page
parent: Getting Started
grand_parent: Analytics & Dashboards
title: Data Extraction
nav_order: 1
permalink: /data-extraction/
---

# Go.Data Data Extraction QuickStart
Considering extracting data from your Go.Data instance for advanced analysis, reporting and visualizations? See the below "Quick Start" steps for getting started. 

Go.Data provides a suite of options for extracting data -
1. File-based export to .csv, .xlsx, JSON, xml via in-app functionality (screenshot)
2. Connect to API via Loopback Explorer (R scripts and Python Scripts have been developed for this)
- R script to connect to API
- Python script to connect to API
- documentation for LoopBack explorer
3. MongoDB connector


## Additional Resources
Go.Data exposes an Application Programming Interface (API) which is used for all interactions between the web front-end, the smartphone applications and even between copies of Go.Data, if you configure multiple instances of the solution to exchange data in an “upstream server/client application” model. 
- If leveraging Go.Data’s default settings, the self-documenting description of the API methods can be viewed using Loopback Explorer by adding /explorer to the end of any Go.Data URL. See the [API docs](https://worldhealthorganization.github.io/godata/api-docs/) for more information on related configuration settings. 
- Note that all users in Go.Data have a single “active” outbreak and this will be the one whose data is returned in subsequent calls using the authentication token received for the user. If you need to work across multiple outbreaks in your code, then you will either need to change users OR switch the active outbreak of the current user via an API call.
