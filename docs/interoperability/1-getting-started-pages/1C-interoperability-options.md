---
layout: default
title: Options
parent: Getting Started
grand_parent: Go.Data Interoperability
nav_order: 3
permalink: /options/
---

# Data Interoperability Options
## 1. Data Input
1. Go.Data provides out-of-box features to support manual data entry, and file import options for file types .csv, .xls, .xlsx, .xml, json, and .ods. See the [User Guide](https://community-godata.who.int/page/documents) for more information. 
2. Online, offline, and mobile data input options are supported. 
3. **Excel import templates**: See the [Go.Data Community](https://community-godata.who.int/page/documents)
4. Manual data entry and import approaches require relatively little technical effort. They may also be used temporarily to pilot a data integration approach. This allows users to test functionality and reports, without having to employ dedicated technical resources for the development of automated interoperability functions.


## 2. Data Sharing & APIs
1. **Exports:** Go.Data provides out-of-box features for generating data exports and basic reports. This includes exports to file types .csv, .xls, .xlsx, .xml, json, .ods, and .pdf.  See the [User Guide](https://community-godata.who.int/page/documents) for more information. 
2. **API:** Go.Data provides robust APIs to support a wide range of data exchange scenarios. Any operation possible from the web interface/smartphone can also be made by calling the appropriate method direct. [See the API page](https://worldhealthorganization.github.io/godata/api-docs/) for more information. 

## 3. Integration Scripts & ETL Tools
Go.Data community members have developed scripts for extracting, cleaning, and loading data to and from Go.Data for extended analysis and integration with common tools like DHIS2. This includes code written in R, Python, C#, JavaScript and more.  & [Github repo](https://github.com/WorldHealthOrganization/godata/) for more information and links to source code.  

## 4. Connectors with Common ICT4D Tools
1. **[OpenFn](https://docs.openfn.org/) integration platform** uses the open-source API adaptor/wrapper [language-godata](https://github.com/WorldHealthOrganization/language-godata) to expose a series of helper functions for commonly used API operations (e.g., `getCases(...)`). See [OpenFn/microservice](https://openfn.github.io/microservice/) for information on open-source and free integration tools for configuring and automating integration scripts. 
2. **PowerBI & Other analysis tools** - Consider leveraging the standard export feature to generate file exports to run through external tools, and/or leverage the Go.Data API to automate or stream data exports (see the standard resource and `/export` endpoints). See the [Analytics docs](https://worldhealthorganization.github.io/godata/analytics/) for more information and examples. 


# Real-World Interoperability Scenarios
See the [Use Cases](https://worldhealthorganization.github.io/godata/use-cases/) page for common integration scenarios and use cases shared by Go.Data community members and implementers. This includes user story-based requirements and solution examples. 



