---
layout: page
title: Popular Topics
permalink: /topics/
nav_order: 5
---

# Popular Design Topics

## 1. Unique identifier schemes
When interoperating with other systems, determining unique identifiers for every shared resource is critical to developing shared records, preventing duplicates, and preserving data integrity. 

### Go.Data GUIDs
All records created in Go.Data are assigned a system-generated internal Globally Unique Identifier (`GUID`). 
GUIDs (e.g., `8c71e61f-fb11-4d4f-9130-b69384b6e4e4`) are used as primary
keys for records in the MongoDB, and are **required to request and update Go.Data records** via the API.


`GET  http://localhost:8000/api/outbreaks/8c71e61f-fb11-4d4f-9130-b69384b6e4e4`

### Case & Contact IDs
Case ID mask: Enter a human-readable identification pattern that Go.Data will use to
create a globally unique identifier to track each case. Subject to the structure of the ID,
Go.Data automatically assigns an identification
1. Custom `*` IDs
2. Autonumber IDs `CASE-00001`

### 'Document' variable
On Case and Contact there is a standard `Document` variable available for users to specify other Document identification (e.g., national ID, passport). 

### Questionnaire custom variables
Questionnaires are essential for collecting and recording data for cases, contacts, and lab results
during an outbreak. A pre-established questionnaire format for an outbreak ensures that data
collected is consistent across the outbreak, so you can more easily perform analysis on the
information...

## Go.Data Location IDs
When Go.Data records, geocodes, other IDs...

## Determining your own custom unique identifier scheme
If a unique identifier scheme is not already available, consider the following approaches to developing your own custom identifier scheme...
1. autonumbers
2. national Ids
3. concatenating attributes
4. ...

## 2. Unique identifiers & duplicate prevention
## 'Upsert' Operations
Upserts ensure no duplicates...

### Go.Data Duplicate Management Features
For scenarios where the unique identfier scheme fails, Go.Data offers some out-of-box feature for duplicate-checking across different record attributes (e.g., `name`, `dateOfBirth`). See the [User Guide](...) to learn more. 


## 3. Aggregating records for external reporting
### 3.1. Map your reporting rules.
When planning to report aggregate results to an external system, build a map of reporting "rules" and calculations that will be required to summarize Go.Data information to generate aggregate reporting results. 

### 3.2. Consider your data extraction options. 
1. Extract individual results and then Transform & Load (E&TL strategy) - Extract individual records from Go.Data and then perform any aggregation & transformation in an outside staging environment or via an integration layer/automation step before uploading to the external reporting system. 
2. Extract aggregate results and then load (ET&L strategy) - Go.Data already provides some APIs for extraction of pre-aggregated results, and more are in development. 

### 3.3. Consider standards.
1. Consider aggregate data standards like ADX to streamline results generation for easy and widespread reporting across ADX-friendly destination systems. 
2. Reviewing standard indicator definitions may also be critical to the design of your reporting "map" (see `2.1`). 

### 3.2. Consider your data extraction options. 
1. Consider your reporting frequency & date/time “cursor” ... 


## 4. Applying data standards
1. About FHIR, ADX, OpenHIE guides
2. _When_ to implement data standards

## 5. Data security considerations for information exchange
1. Capture these requirements early on
2. Data sharing protocols
3. Be selective & deliberate about _which_ data points are exchanged
4. Leverage identifiers and autonumbers to mask sensistive information
5. Consider the security of where information is stored at rest

## 6. Integrating lab results
See [reference implementation #3] for specific step-by-step guidance with a real-world example. Other resources: ...

## 7. Integrating with DHIS2
### 7.1. DHIS2 to Go.Data
See the UPC scripts... 

### 7.2. Go.Data to DHIS2 Tracker (Individual-level data exchange)
See the UPC scripts and consider leveraging the DHIS2 [Tracker Web API](https://docs.dhis2.org/2.34/en/dhis2_developer_manual/web-api.html#tracker-web-api) for potential 2-way exchange of case information between DHIS2 `tracked entity instance` records or `events` and Go.Data `cases` or `contacts`. 

### 7.3. Go.Data to DHIS2 Data Values (Aggregate-level data exchange)
See [reference implementation #6] for specific step-by-step guidance with a real-world example of aggregate reporting. 
One of the first things you’ll need to do is identify the specific DHIS2 `data set` that you plan to integrate your Go.Data data with. In DHIS2, aggregate data captured as `dataValueSets` and is further defined across different dimensions called `orgUnit`, `period`, and `dataElement` & `categories`. 

#### Data sets
Users will need to know the specific name and ID of the destination `dataSet` in DHIS2. You will need to obtain the ID from the test or production DHIS2 environment.

#### Organisation units
Aggregation by location in Go.Data is based on your `Location` hierarchy. Your `Locations` must align with DHIS2 `organisation units`. You will need to specify the DHIS2 `orgUnit` ID in order to upload aggregate results. 

#### Period
All aggregate data reported is associated with a specific DHIS2 reporting `period`, which may be daily, weekly, monthly, yearly, etc. depending on the DHIS2 implementation. Examples: `20201205`, `202012`, `2020`

#### Data elements
Calculations for DHIS2 `indicators` are based on `dataElements`. For each DHIS2 data element, you will need to calculate the summary `value` to send to DHIS2. You will need to know both the `value` and `dataElement` DHIS2 Id in order to upload new `dataValues`. 

#### Categories
Categories are another dimension commonly used to define data elements in aggregate reporting.

#### Learn More
Read more about setting up DHIS2 aggregated reporting [here](https://docs.dhis2.org/2.31/en/user/html/setting_up_reporting.html), and learn about [DHIS2 aggregation strategies](https://docs.dhis2.org/master/en/implementer/html/aggregation-strategy-in-dhis2.html). 


## 8. Integrating with mobile data collection apps 
See [reference implementation #4] for specific step-by-step guidance with a real-world example. Other links to mobile apps...
