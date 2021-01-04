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
![diagram-1-2](../assets/io-use-case-1-2.png)


## Flow 1. HMIS to Go.Data
To automate data integration from the HMIS to Go.Data, implementers may consider 2 common integration approaches: 
1. Data forwarding...
2. Direct data integration via APIs where you can (1) send a HTTP request to fetch the relevant data from the source HMIS, and then (2) upsert* the data in Go.Data, matching HMIS `caseId` with Go.Data `externalId` to ensure no duplicate records are created. 


* _**"Upsert"** operations are a data import pattern where you first check if a record exists using an external identifier, and then either **update** or **insert** a new record dependng on whether an existing record is found. See the [section on Unique Identifiers](...) for additional considerations regarding upserts, `externalId` and other unique identifiers._ 

## Flow 2. Go.Data to HMIS & Applying FHIR 
To automate data integration from Go.Data to the HMIS, we...
1. Leverage the Go.Data API to automatically extract cases via an HTTP request to `GET /cases`. 
2. Apply transformation rules determined from [FHIR HL7](...) to clean, re-format, & map the Go.Data information to match the international standard
3. We then upsert the transformed data in the HMIS system, matching HMIS `caseId` with the Go.Data `externalId` to ensure no duplicates are uploaded

## Considerations for two-way syncing
1. Unique identifiers are critical to ensuring no duplicate records or efforts and developing a **shared record reference**. 
2. Determine the system of record...
3. Consider implementing a date/time `cursor` so that every time you extract data from a source system, you will only extract the _most recent_ data. This minimizes the data load to be exchanged between systems, which is good for efficiency and security. 
4. Consider what initiates the data `sync`...

## Demo Solution & Implementation Resources
1. [See this video](...) of the demo solution configured to demonstrate these use cases #1 and #2.  
2. See [example integration scripts](...) ... 
3. See the solution [design documentation](...) ... 

![implementation-2](../assets/godata-example2.png)
