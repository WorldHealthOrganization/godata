---
layout: page
title: Popular Topics
permalink: /topics/
nav_order: 5
---

# Popular Design Topics

## 1. Unique identifiers & duplicate prevention
When interoperating with other systems, determining unique identifiers for every shared resource

### Go.Data Duplicate Management Features
For scenarios where the unique identfier scheme fails, Go.Data offers some out-of-box feature for duplicate-checking across different record attributes (e.g., `name`, `dateOfBirth`). See the [User Guide](...) to learn more. 


## 2. Aggregating records for external reporting
### 2.1. Map your reporting rules.
When planning to report aggregate results to an external system, build a map of reporting "rules" and calculations that will be required to summarize Go.Data information to generate aggregate reporting results. 

### 2.2. Consider your data extraction options. 
1. Extract individual results and then Transform & Load (E&TL strategy) - Extract individual records from Go.Data and then perform any aggregation & transformation in an outside staging environment or via an integration layer/automation step before uploading to the external reporting system. 
2. Extract aggregate results and then load (ET&L strategy) - Go.Data already provides some APIs for extraction of pre-aggregated results, and more are in development. 

### 2.3. Consider standards.
1. Consider aggregate data standards like ADX to streamline results generation for easy and widespread reporting across ADX-friendly destination systems. 
2. Reviewing standard indicator definitions may also be critical to the design of your reporting "map" (see `2.1`). 

### 2.2. Consider your data extraction options. 
1. Consider your reporting frequency & date/time “cursor” ... 


## 3. Applying data standards
1. About FHIR, ADX, OpenHIE guides
2. _When_ to implement data standards

## 4. Data security considerations for information exchange
1. Capture these requirements early on
2. Data sharing protocols
3. Be selective & deliberate about _which_ data points are exchanged
4. Leverage identifiers and autonumbers to mask sensistive information
5. Consider the security of where information is stored at rest

## 5. Integrating lab results
See [reference implementation #3] for specific step-by-step guidance with a real-world example. Other resources: ...

## 6. Integrating with DHIS2
## DHIS2 to Go.Data
See the UPC scripts... 

## Go.Data to DHIS2 Tracker (Individual-level data exchange)
See the UPC scripts and consider leveraging the DHIS2 [Tracker Web API](https://docs.dhis2.org/2.34/en/dhis2_developer_manual/web-api.html#tracker-web-api) for potential 2-way exchange of case information between DHIS2 `tracked entity instance` records or `events` and Go.Data `cases` or `contacts`. 

## Go.Data to DHIS2 Data Values (Aggregate-level data exchange)
See [reference implementation #6] for specific step-by-step guidance with a real-world example.


## 7. Integrating with mobile data collection apps 
See [reference implementation #4] for specific step-by-step guidance with a real-world example. Other links to mobile apps...
