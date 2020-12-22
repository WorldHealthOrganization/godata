---
layout: page
title: Interoperability Examples
nav_order: 4
permalink: /interoperability-examples/
---
# Interoperability Reference Implementations
The following examples were configured to demonstrate common interoperability use cases & potential solutions. 

## 1. Go.Data <> HMIS/Surveillance system 2-way information exchange
The...

---
**Use Cases:**

_As a MOH employee, I would like to integrate contact data from my country’s surveillance system, so that I can use Go.Data for contact tracing & follow-up in a way that does not duplicate efforts._

_As a Go.Data user, I would like to automatically apply the FHIR data standard to any contact information collected via Go.Data before sharing with the HMIS to ensure data interoperability and to avoid any manual data cleaning/reformatting steps during information exchange._

---

### Demo Solution & Implementation Resources
1. [See this video](...) of the demo solution configured to demonstrate this requirement #1.  
2. To click around & explore the solution in-depth, go to...
3. See [example integration scripts](...) ... 
4. See the solution [design documentation](...) ... 

## 2. Importing Lab Sample Data to Go.Data
For many Go.Data implementers, lab results data will be the starting reference point when implementing a new Go.Data instance. This sample data will need to be first be transformed to align with the Go.Data data model, where `Case` and `Contact` records must first be created to track individual beneficiary details. Once these individual records are created, then related `Lab Results` data can be imported. 

---
**Use Case:**
_As a Go.Data user, I would like to directly integrate lab datasets so that I can more quickly and securely register Contact and Case records to ensure data quality and save time on data entry._

---

### Standard Import Process
Typically a lab will provide export of `Sample`/ `Results` data like [this example](...). In this data source, there might be multiple `Sample` results for 1 individual. To import this data to the Go.Data system, the user will need to...

1. Analyze the dataset to construct unique `Case` and `Contact` records. Consider...

* 1.a. Is there an available patient unique id (e.g., national id)? 
* 1.b. If not, can you construct a new unique id? 
 
2.Import the individual records to Go.Data using the standard `import` wizard or the API. When uploading, match with existing resources to prevent duplicates. To do this, you will need to consider the appropriate unique identfier to check for existing records. Consider...

* 2.a. Will you import a lab-provided custom Id or standard identifier (e.g., `nationalId`) from the lab dataset? (and mask the Go.Data Case Id as `*`...)
* 2.b. Will you generate a new custom Id (e.g., `caseId: 'CASE-00001'`) based on some standard naming convention and autonumber? 
 
3. Organize the data to link every `Sample` record to an individual person record. [See this Case - Lab Results](...) import template. 

4. Export the Ids...

### Implementation Resources
1. See [example import templates](...) ... 
3. See the section on [Unique Identifiers](...) to support with resource matching during data imports. 



## 3. Mobile to Go.Data
Mobile survey and data collection apps are widely used by Go.Data implementers and other health initiatives...

---
**Use Case:**
_As a MOH employee, I would like to integrate case data collected via my mobile survey tool so that I can monitor new case registrations in real-time and quickly follow up with new contacts._

---
### Implementation Resources
1. [See this video](...) of the demo solution configured to demonstrate this requirement #3.  
2. To click around & explore the solution in-depth, go to OpenFn.org...
3. See [example integration scripts](...) ... 
4. See the solution [design documentation](...) ... 

## 4. Health Facility/ Locations  Import to Go.Data
Mobile survey and data collection apps are widely used by Go.Data implementers and other health initiatives...

---
**Use Case:**
_As a Go.Data analyst, I would like to import facility and location lists from standard registries and external data sources so that I can more easily exchange information with the MOH and other partners._

---

### Implementation Resources
1. [See this video](...) of the demo solution configured to demonstrate this requirement #4.  
2. To click around & explore the solution in-depth, go to OpenFn.org...
3. See [example integration scripts](...) ... 
4. See the solution [design documentation](...) ... 

## 5. Aggregate reporting to HMIS/ DHIS2 
Reporting...

---
**Use Case:**
_As a MOH employee using DHIS2, I would like to receive a weekly summary of Go.Data data cases to monitor performance across key COVID-19 indicators (e.g., # confirmed cases, # hospitalized cases, transmission classifications)._

---


### Implementation Resources
1. [See this video](...) of the demo solution configured to demonstrate this requirement #5.  
2. To click around & explore the solution in-depth, go to OpenFn.org...
3. See [example integration scripts](...) ... 
4. See the solution [design documentation](...) ... 
