---
layout: page
title: Getting Started
nav_order: 2
permalink: /getting-started/
---

# Getting Started with Interoperability
## Interoperability Planning 
Quickstart guide to starting your interoperability journey… (This section will target a non-technical audience who is interested in interoperability)
1. Evaluating the options 
2. Preparing for implementations 
- a. Getting buy-in, Shareable PDF overviews on Go.Data app, available data elements → LINK to existing Go.Data resources here
- b. Example data sharing agreements
- c. Finalizing requirements, mapping data elements → link to Go.Data-specific template to jumpstart implementers’ design process (shareable file that could be shared with partner agencies/ systems)
3. Planning for the technical implementation of interoperability solutions → link to OpenFn ‘Integration Checklist’ resource used in all new integration projects, but customized for Go.Data)
4. Guidance for data security, protection, & compliance considerations → links to FAQ, resources


## Go.Data Implementation Considerations
### 1. Unique Identifiers:
Accurate and efficient unique identification of any data to be shared or referenced external is critical to interoperability. Before implementing Go.Data, you should spend time evaluating available unique identifier schemes and what options may already be implemented by related information systems. See the [Unique Identifiers section]() for more on Go.Data identifier schemes and considerations. 
### 2. Mandatory & Core Metadata: 
Consider that Go.Data has a list of mandatory variables (see p.41 of [Implementation Guide](...)) that must be specified in order to successfully import data into the system, as well as a list of core variables provided out-of-box. Implementers should consider leveraging available variables before configuring custom metadata, as many of these variables are referenced in Go.Data features and thereby offer enhanced reporting, if used. 
### 3. Custom Metadata: 
While Go.Data offers a set of core variables out-of-box, administrators may configure custom metadata to track variables specific to their implementation. Wherever new metadata is configured, including custom data elements and reports: 
(1) define [standard naming conventions](https://wiki.hl7.org/FHIR_Guide_to_Designing_Resources#Naming_Rules_.26_Guidelines), 
(2) ensure naming consistency across the application (e.g., using both “dateOfBirth” and “birthDate” would be confusing & redundant), and 
(3) document meaningful descriptions to support external understanding and translation if data needs to be shared externally ([read here](https://wiki.hl7.org/FHIR_Guide_to_Designing_Resources#Guidelines_for_Short_descriptions_and_definitions) for guidance). 
### 4. Standards: 
The inclusion of international eHealth standards strengthens interoperability and data sharing options for Go.Data implementations. Some standards are on the technical level (e.g. transmission methods), others on the contents side (e.g., [WHO standard indicators](http://who.int/data/gho/indicator-metadata-registry)). Aligning Go.Data implementations to these standards can incentivize data sharing and provide access to existing health systems. 
- Popular data exchange standards include FHIR, ADX, CSD, and mCSD. [Read more here](https://wiki.ohie.org/display/documents/OpenHIE+Standards+and+Profiles) on the OpenHIE wiki. 
- [Fast Healthcare Interoperability Resources (FHIR)](https://www.hl7.org/fhir/overview.html) is the most common standard for exchanging healthcare data and provides a [FHIR Implementation Guide](https://www.hl7.org/fhir/implementationguide.html) that includes standard definitions, naming conventions, and best practices for Go.Data implementers. 
### 5. API Access: 
Go.Data exposes an Application Programming Interface (API) which is used for all interactions between the web front-end, the smartphone applications and even between copies of Go.Data, if you configure multiple instances of the solution to exchange data in an “upstream server/client application” model. 
- If leveraging Go.Data’s default settings, the self-documenting description of the API methods can be viewed using Loopback Explorer by adding /explorer to the end of any Go.Data URL. See the [IT Admin Guide](...) for more information on related configuration settings and for the API documentation (see p. 53). 
- Note that all users in Go.Data have a single “active” outbreak and this will be the one whose data is returned in subsequent calls using the authentication token received for the user. If you need to work across multiple outbreaks in your code, then you will either need to change users OR switch the active outbreak of the current user via an API call.


## Go.Data Interoperability Options
See [Data Input & Sharing Options](../2-data-exchange-options.md), including available API documentation to understand Go.Data's wide range of flexible and robust options for data exchange, including import/export options, API documentation, and scripts and sample solutions for automated data integration.
