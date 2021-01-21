---
layout: default
title: Integrating with DHIS2
parent: Frequently Asked Questions
grand_parent: Go.Data Interoperability
nav_order: 3
permalink: /dhis2-integrations/
---
# Go.Data Integrations with DHIS2
## 1. DHIS2 to Go.Data
See the Github folder [dhis2togodata](https://github.com/WorldHealthOrganization/godata/tree/master/dhis2togodata) for the source code and information on available DHIS2-Go.Data integration scripts. These include: 
### 1.1. Org unit converter:
Devleoped by EyeSeeTea LS (http://eyeseetea.com/), this is a Python script to take the national org tree from a DHIS2 instance, transform its .json structure and input it into Go.Data 

### 1.2. API wrapper:
Developed by WISCENTD-UPC (https://github.com/WISCENTD-UPC/) - this package provides certain common things you may need in order to use Go.Data’s API, so that it is easier and faster. This utility library “wraps” the functionality of the API under a common tiny library that already handles functions such as login authorization that would otherwise have to be done for each query separtely.

See full package here: https://github.com/WISCENTD-UPC/godata-api-wrapper/tree/develop

### 1.3. Interoperability scripts:
Developed by WISCENTD-UPC (https://github.com/WISCENTD-UPC/) - these scripts push DHIS2 Tracked Entities for cases and contacts into Go.Data cases and contacts, in addition to automatically inserting them in a new or existing outbreak in Go.Data with the appropriate parameters.

See full package here: https://github.com/WISCENTD-UPC/dhis2-godata-interoperability/tree/develop

See more project-related updates here: https://www.essi.upc.edu/dtim/projects/COVID-19


## 2. Go.Data to DHIS2 Tracker (Individual-level data exchange)
Leveraging the Go.Data API and DHIS2 [Tracker Web API](https://docs.dhis2.org/2.34/en/dhis2_developer_manual/web-api.html#tracker-web-api), users can integrate individual-level data between the 2 systems. 

Interoperability Scripts eveloped by WISCENTD-UPC (see above) will be expanded to demonstrate 2-way exchange of case information between DHIS2 `tracked entity instance` records or `events` and Go.Data `cases` or `contacts`. See more project-related updates here: https://www.essi.upc.edu/dtim/projects/COVID-19

## 3. Go.Data to DHIS2 Data Values (Aggregate-level data exchange)
See [reference implementation #6](https://worldhealthorganization.github.io/godata/godata--dhis2-aggregate/) for specific step-by-step guidance leveraging [OpenFn](https://docs.openfn.org) jobs with a real-world example of aggregate reporting. 
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

## 4. Learn More
Read more about setting up DHIS2 aggregated reporting [here](https://docs.dhis2.org/2.31/en/user/html/setting_up_reporting.html), and learn about [DHIS2 aggregation strategies](https://docs.dhis2.org/master/en/implementer/html/aggregation-strategy-in-dhis2.html). 
