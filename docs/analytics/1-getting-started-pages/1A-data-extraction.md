---
layout: page
parent: Data Viz Overview 
grand_parent: Analytics & Dashboards
title: Data Extraction
nav_order: 1
permalink: /data-extraction/
---

# Go.Data Data Extraction QuickStart
Considering extracting data from your Go.Data instance for advanced analysis, reporting and visualizations? See the below "Quick Start" steps for getting started. 

Go.Data provides a suite of options for extracting data -
1. File-based export to .csv, .xlsx, JSON, xml via in-app functionality 
![](https://github.com/WorldHealthOrganization/godata/blob/master/docs/assets/analysis_export.PNG)

2. Connect to API via scripts
- [See the R Reporting page](https://github.com/WorldHealthOrganization/godata/blob/master/analytics/r-reporting) documentation which contains a script to easily connect to API and extract relevant database collections directly into your R console 
- Python script to connect to API and extract relevant collections, as above, at Github repo [here](https://github.com/WorldHealthOrganization/godata/blob/master/analytics/country_use_cases/godata-Kosovo/scripts/kosovo_dashboard_data_extraction.py)
- [See the API page](https://worldhealthorganization.github.io/godata/api-docs/) for more information on accessing and working with the API. 

3. Connect directly to MongoDB database 
- [See p.36 of IT Admin Guide](https://sprcdn-assets.sprinklr.com/1652/dc9766d9-750c-45d5-87cb-e324ed0ddc56-334405042.pdf) for more information on working with MongoDB. 

## Additional Resources
- [Go.Data Community of Practice - Analytics & Interoperability Discussion Forums](https://community-godata.who.int/categories/analytics-interoperability/5fbfba76654a4708eb5069ff)
- [Loopback Explorer documentation for how to apply filters and other syntax tips when querying Go.Data API](https://loopback.io/doc/en/lb3/Querying-data.html)
