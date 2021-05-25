---
layout: default
title: 6. Aggregate Reporting to DHIS2
parent: Real-World Examples
grand_parent: Go.Data Interoperability Toolkit
nav_order: 6
permalink: /godata--dhis2-aggregate/
---

# Aggregate Reporting to DHIS2
Reporting out from Go.Data to an external HMIS/reporting system is a very popular requirement among implementers, particularly the need to report aggregate/ summary results for key indicators (e.g., # of cases confirmed this week, # of cases hospitalized). 

Go.Data plans to expand its API to support extraction of automatically aggregated results for common indicators. In the meantime, users can also leverage the Go.Data API ([see API docs](https://github.com/WorldHealthOrganization/godata/api-docs/) to (1) list individual records, and then (2) write a script to sum/aggregate these records before (3) uploading to an external reporting system like DHIS2. We explore this data flow in this below reference implementation with DHIS2. 

- See [Integration with DHIS2 page](https://worldhealthorganization.github.io/godata/dhis2-integrations/) for other DHIS2 integration scripts developed by UPC and other partners, along with more guidance for DHIS2 integrations. 
- Watch the [video overview](https://sprcdn-assets.sprinklr.com/1652/5a2c79e5-f8b6-473a-b81c-7eba187f1c24-1003632985.mp4)
- [Explore the Implementation](#explore-the-implementation)

![use-case-6](../assets/use-case-6.png)

---
**Use Case:**
**#6.** _As a MOH employee using DHIS2, I would like to receive a weekly summary of Go.Data data cases to monitor performance across key COVID-19 indicators (e.g., # confirmed cases, # hospitalized cases, transmission classifications)._

---
## Solution Overview
**--> Watch the [video overview](https://sprcdn-assets.sprinklr.com/1652/5a2c79e5-f8b6-473a-b81c-7eba187f1c24-1003632985.mp4)**

Many Go.Data implementers have reported that they are required to regularly report summary results to their national-level HMIS, many of which use DHIS2 for country-level reporting and monitoring. Therefore, in this reference implementation we integrated Go.Data with the DHIS2 COVID-19 demo org, summarizing Go.Data `Cases` and uploading them as `dataValueSets` into DHIS2 for aggregate indicator reporting. See the below data flow diagram. 
- DHIS2 is a popular open-source health information system implemented in several countries worldwide, and provides features for individual- and aggregate-level health record tracking, managament, and analysis. DHIS2 also provides features for common HMIS use cases like the [COVID-19 Surveillance Package](https://www.dhis2.org/covid-19). 
- DHIS2 `Indicators` ([read more here](https://docs.dhis2.org/2.34/pt/dhis2_implementation_guide/indicators.html#:~:text=In%20DHIS2%2C%20the%20indicator%20is,do%20not%20have%20a%20denominator.)) are a core unit of aggregate analysis and are based on `data elements`. 
- We leverage the Go.Data `/cases` API endpoints to list, filter, and extract `Case` data to then aggregate before uploading to DHIS2 `data elements`. 

![use-case-6](../assets/io-use-case-6.png)

### Integration Scripts
See the Github repo for the raw source code for the following 2 OpenFn job scripts:
1. Job [6a-getCasesDHIS.js](https://github.com/WorldHealthOrganization/godata/blob/master/interoperability-jobs/6a-getCasesDHIS.js) that gets cases from Go.Data & aggregates individual records to calculate indicator results. 
2. Job [6b-importDHIS2.js](https://github.com/WorldHealthOrganization/godata/blob/master/interoperability-jobs/6b-importDHIS2.js) that uploads aggregated results to DHIS2 as `Data Value Sets`, which link to aggregate indicators. 

On OpenFn.org, we configured a `cron` timer (e.g. `00 23 * * 1`) to run the jobs every 1 week on Mondays to automate the reporting cycle end-to-end. 

![openfn-6](../assets/openfn-6.png)


## Implementation Steps 
**--> Watch the [setup walkthrough](https://sprcdn-assets.sprinklr.com/1652/8cb40700-8b8b-442d-a323-314078cb58d3-623643034.mp4)**
1. First determine the reporting requirements and how to extract data from Go.Data. Are you reporting on `Cases` or `Contacts`? What attributes will you need to summarize or aggregate results by? Consider what specific data elements you will need to extract and the formulas for different calculations needed (e.g., `COUNT`, `SUM`, `AVG`, etc.). 

2. Then determine the key data model attributes of the DHIS2 system you would like to integrate with. Are you integrating with DHIS2 `trackedEntities`? Or `dataValueSets` and `dataElements`? Which `orgUnit` and reporting `period` should data map to? 
→ See [Integrating with DHIS2](https://worldhealthorganization.github.io/godata/dhis2-integrations/) for more information on identifying different DHIS2 elements when desiging a new integration.

3. Map relevant data elements from the Go.Data response to relevant DHIS2 attributes. [See mapping specifications](https://drive.google.com/drive/folders/1qL3el6F2obdmtu2QKgcWYoXWsqBkhtII) and see [Integrating with DHIS2](https://worldhealthorganization.github.io/godata/dhis2-integrations/) docs section for more guidance on the DHIS2 data model and integration considerations. 
4. Extract relevant data elements from Go.Data per the requirements in step `#1`. In this OpenFn job [6a-getCasesDHIS.js](https://github.com/WorldHealthOrganization/godata/blob/master/interoperability-jobs/6a-getCasesDHIS.js), we send a `GET` request to the Go.Data API to list and extract `Cases` that are `'confirmed'`.  

```js
getCase(
  '3b5554d7-2c19-41d0-b9af-475ad25a382b', //outbreak Id 
  {
    where: {
      classification:
        'LNG_REFERENCE_DATA_CATEGORY_CASE_CLASSIFICATION_CONFIRMED', //filter to extract only confirmed cases
    },
  },
```
In this same job, we also calculate "summary" results to report to DHIS2. To determine the `# of confirmed cases` to report to DHIS2, in [L46]https://github.com/WorldHealthOrganization/godata/blob/master/interoperability-jobs/6a-getCasesDHIS.js#L46-L49) we count the number of records returned by our `GET` request and determine the `dateOfReporting`. 

```js
summary = {
      dateOfReporting: lastDateOfReporting,
      value: currentCases.length,
    };
```

5. We then run another OpenFn job [6b-importDHIS2.js](https://github.com/WorldHealthOrganization/godata/blob/master/interoperability-jobs/6b-importDHIS2.js) to import this "summary" data into DHIS2 via the API endpoint `/api/dataValueSets`. 
- We follow the [DHIS2 API docs](https://docs.dhis2.org/master/en/developer/html/dhis2_developer_manual_full.html#webapi_data_values) to determine other required attributes, such as `orgUnit` and `dataElement` Id.
- We leverage the OpenFn [DHIS2 API adaptor](https://openfn.github.io/language-dhis2/dataValueSet.html) helper function to access the `dataValueSets` resource. 

```js
//Example job snippet to upload data value sets to DHIS2
dataValueSet({
   dataSet: "kIfMNugiTgd",
   orgUnit: "DiszpKrYNg8",
   period: dateOfReporting, //we dynamically fill based on Go.Data extract
   completeData: dateOfReporting,
   dataValues: [
     dataElement("CnPsS2xE8UN", summaryValue), //we dynamically fill based on Go.Data extract & calculation
   ]
});
```

## Other DHIS2 Resources
1. See the [Integrating with DHIS2](https://worldhealthorganization.github.io/godata/dhis2-integrations/) for more on Go.Data integrations with DHIS2. 
2. Read more about Go.Data-DHIS2 integration use cases as part of the UPC project where some DHIS2 to Go.Data scripts have been drafted:  [https://www.essi.upc.edu/dtim/projects/COVID-19](https://www.essi.upc.edu/dtim/projects/COVID-19)
3. See DHIS2 documentation for more on aggregate reporting & API docs: [https://docs.dhis2.org/2.34/en/dhis2_implementation_guide/integration-concepts.html#aggregate-and-transactional-data](https://docs.dhis2.org/2.34/en/dhis2_implementation_guide/integration-concepts.html#aggregate-and-transactional-data)


# Explore the Implementation
1. See the [Explore OpenFn](https://worldhealthorganization.github.io/godata/explore-openfn/) page to explore the jobs on the live reference project. 
- Watch the [video overview](https://sprcdn-assets.sprinklr.com/1652/5a2c79e5-f8b6-473a-b81c-7eba187f1c24-1003632985.mp4)
- Watch the [setup walkthrough](https://sprcdn-assets.sprinklr.com/1652/8cb40700-8b8b-442d-a323-314078cb58d3-623643034.mp4)
- And [see here](https://community-godata.who.int/topics/interoperability/5fd8ec64f5c77e114e6c6823) for other interoperability videos

2. **DHIS2**: Here we integrated with the public `COVID-19 Demo` instance: [https://covid19.dhis2.org/demo](https://covid19.dhis2.org/demo)

3. **Job scripts**: See the Github [`interoperability-jobs`](https://github.com/WorldHealthOrganization/godata/tree/master/interoperability-jobs) to explore the source code used to automate these flows. These leverage an open-source Go.Data API wrapper - the OpenFn adaptor [`language-godata`](https://github.com/WorldHealthOrganization/language-godata/), as well as the DHIS2 API adaptor [language-dhis2](https://openfn.github.io/language-dhis2/)

4. **Solution Design Documentation**: [See this folder](https://drive.google.com/drive/folders/1qL3el6F2obdmtu2QKgcWYoXWsqBkhtII)] for the data flow diagram & data element mapping specifications mentioend above and used to write the integration jobs. 

