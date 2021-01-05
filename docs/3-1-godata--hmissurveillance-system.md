---
layout: default
title: 1. Go.Data <> HMIS/Surveillance System Integration
parent: Interoperability Examples
nav_order: 1
permalink: /3-1-godata--hmissurveillance-system/
---
# Go.Data <> HMIS/Surveillance System Integration for 2-way Information Exchange
In most country-level implementations, Go.Data needs to interoperate with an existing HMIS or Surveillance system to ensure no duplication of efforts. These systems might be configured on an application like DHIS2 or are custom developed using other software or databases. In this solution we explore the following use cases by designing for a Go.Data integration with a theoretical SQL-based HMIS for 2-way exchange of case information. 

![implementation-1](../assets/godata-example1.png)

---
**Use Cases:**

**#1.**  _As a MOH employee, I would like to integrate contact data from my country’s surveillance system, so that I can use Go.Data for contact tracing & follow-up on reported cases in a way that does not duplicate efforts._

**#2.** _As a Go.Data user, I would like to automatically apply the FHIR data standard to any information collected via Go.Data before sharing with the HMIS to ensure data interoperability and to avoid any manual data cleaning/reformatting steps during information exchange._

---
## Solution Overview
See below visual for a data flow diagram for a two-way information exchange between Go.Data and a theoretical HMIS/surveillance system. For this reference, we integrated Go.Data with a sample "HMIS" database configured PostgreSQL to demonstrate how user might integrate with a SQL-based system. 

![diagram-1-2](../assets/io-use-case-1-2.png)


## Determining the Integration Approach
To automate data integration from the HMIS (or any external system) to Go.Data, implementers may consider **2 common integration approaches**: 
1. **Data forwarding** - in the source system there may be an option to configure some sort of data forwarding/publishing mechanism like a webhook or REST service. If available, this allows the source system to control what and when information is shared and can enable real-time data sharing. 
2. **Direct API integration** where you can (1) send a HTTP request to fetch the relevant data from the source system, and then (2) upsert* the data in Go.Data, matching HMIS `caseId` with Go.Data `externalId` to ensure no duplicate records are created. In the approach, the integration implementer can choose what information to fetch and how frequently (and is only limited by the API & user permissions). This approach does not support real-time integration, but data syncs can be scheduled regularly to ensure no lapse in data. 

* _**"Upsert"** operations are a data import pattern where you first check if a record exists using an external identifier, and then either **update** or **insert** a new record dependng on whether an existing record is found. See the [section on Unique Identifiers](https://worldhealthorganization.github.io/godata/topics/1-unique-identifier-schemes) for additional considerations regarding upserts, `externalId` and other unique identifiers._ 

### Considerations for two-way syncing
1. Unique identifiers are critical to ensuring no duplicate records or efforts and developing a **shared record reference**. 
2. Determine the system of record...
3. Consider implementing a date/time `cursor` so that every time you extract data from a source system, you will only extract the _most recent_ data. This minimizes the data load to be exchanged between systems, which is good for efficiency and security. 
4. Consider what initiates the data `sync`...

## Flow 1. HMIS to Go.Data
To demonstrate automated data integration between the HMIS database and Go.Data, we...
1. Mapped the data elements between the 2 systems to identify corresponding variables and data transformation steps (e.g., reformatting dates, re-labeling values, mapping categories, etc.). [See example mapping specification](https://drive.google.com/drive/folders/1qL3el6F2obdmtu2QKgcWYoXWsqBkhtII). 
2. Configured an OpenFn job script to fetch data from the HMIS system. Here we leveraged the open-sourve OpenFn adaptor [`language-postgresql`](https://github.com/OpenFn/language-postgresql) to connect directly with the database. 
3. Configured a second job that then maps & loads the data from the HMIS to Go.Data, leveraging Go.Data API adaptor [language-godata](https://openfn.github.io/language-godata/). 


## Flow 2. Go.Data to HMIS & Applying FHIR data standard
To automate data integration from Go.Data to the HMIS, we...
1. Leverage the Go.Data API to automatically extract cases via an HTTP request to `GET /cases`. 
2. Apply transformation rules determined from [FHIR HL7](...) to clean, re-format, & map the Go.Data information to match the international standard
3. We then upsert the transformed data in the HMIS system, matching HMIS `caseId` with the Go.Data `externalId` to ensure no duplicates are uploaded

In OpenFn.org, we configured these jobs to run automatically on a cron timer to automate the two-way exchange. 
![openfn-1](../assets/openfn-1.png)
![openfn-2](../assets/openfn-2.png)



## Demo Solution & Implementation Resources
1. [See this video](https://drive.google.com/drive/folders/1Rf9TXCXkn8_XnjH4FcRsIGqDZ-UkVvdC) of the demo solution configured to demonstrate these use cases #1 and #2.  
2. HMIS demo: For this example use case, we configured a demo "HMIS" system on a SQL database and implemented OpenFn jobs that leverage the [`language-postgresql`](https://github.com/OpenFn/language-postgresql) to connect directly with the database. 
3. Integration: See [example integration scripts](https://github.com/WorldHealthOrganization/godata/tree/docs-toolkit/interoperability-jobs) implemented on the OpenFn integration platform for automated data exchange for scenarios `1` and `2`. Explore the solution at [OpenFn.org](https://www.openfn.org/login) using the login details: `demo@godata.org`; pw: `interop!2021`. 
4. Go.Data API Wrapper: See the open-source OpenFn adaptor [language-godata](https://openfn.github.io/language-godata/). 
5. See the solution [design documentation](https://drive.google.com/drive/folders/1qL3el6F2obdmtu2QKgcWYoXWsqBkhtII).
6. FHIR-HL7 Documentation on the content specifications for [Patient resources](https://www.hl7.org/fhir/patient.html). See the [Applying Data Standards](https://worldhealthorganization.github.io/godata/topics/4-applying-data-standards) section for more information. 
