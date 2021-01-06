---
layout: page
parent: Getting Started
grand_parent: Go.Data Interoperability
title: Interoperability QuickStart
nav_order: 1
permalink: /interoperability-quickstart/
---

# Interoperability Planning QuickStart
Considering interoperbility solutions for your Go.Data implementation to improve data sharing and collaboration? See the below "Quick Start" steps for getting started. 

Go.Data provides a suite of data import & sharing features that can be leveraged to support a wide range of data interoperability solutions, which may include manual data sharing, reporting, and/or automated data integration to facilitate secure information exchange. When considering which approach is best-fit for your implementation...
1. First understand your _functional_ interoperability requirements. _What_ information needs to be shared, with _which user groups/organizations_, and _when_? 
2. Then consider what are your _compliance/legal_ requirements with respect to data sharing and privacy. Are there any country-specific compliance requirements that need to be adhered to? 
3. What systems/tools do partner organizations use and what are their _technical_ requirements? See below section [Connecting other systems](#connecting-other-systems) for specific questions to ask. 
4. Document the requirements and consider drafting a **Data Sharing Protocol** agreement with partner organizations to ensure these requirements are clearly understood by all parties involved. 
- [See example Data Sharing agreement here](https://drive.google.com/drive/folders/1XlIF5cRq1eV499GISPJBc8bidZWkuQAi?usp=sharing). 
- Consider documenting specific requirements as _user stories_ to fully detail the functional need, purpose, and people involved. [See here](https://www.atlassian.com/agile/project-management/user-stories) for standard user story templates and see the [Use Cases](https://worldhealthorganization.github.io/godata/interoperability-options/#common-use-cases) sections of this documentation for sample user stories. 
5. Evaluate your interoperability options. Once you have a clear understanding of the functional, compliance/legal, and technical requirements for your interoperability solution, review available [Data Input & Sharing Options](../2-data-exchange-options.md) to determine the best-fit approach for your requirements.
6. Build a map to detail the specific data elements to be exchanged with Go.Data. These specifications should detail how every data point should be mapped to a specific Go.Data field/variable. [See here](https://drive.google.com/drive/folders/1XlIF5cRq1eV499GISPJBc8bidZWkuQAi?usp=sharing) for a **Go.Data mapping specification template**.
7. Prepare for the technical implementation once requirements & data mapping specifications have been defined. If planning to implement an integration between Go.Data and another system, [see here](https://drive.google.com/drive/folders/1XlIF5cRq1eV499GISPJBc8bidZWkuQAi?usp=sharing) for a template **Go.Data Integration Checklist**. 

## Other Planning Resources
- See the DHIS2 [Implementation Guide](https://docs.dhis2.org/2.34/en/dhis2_implementation_guide/integration-concepts.html#implementation-steps-for-successful-data-and-system-integration) based on the [OpenHIE Implementation Methodology](https://wiki.ohie.org/display/documents/OpenHIE+Planning+and+Implementation+Guides) for additional guidance
- See the interoperability [reference implementations](https://worldhealthorganization.github.io/godata/interoperability-examples/)
- See here for example Go.Data interoperability solutions: https://worldhealthorganization.github.io/godata/interoperability-examples/
- See here for a Go.Data Implementation Guide & shareable overviews to share with interested partners: https://community-godata.who.int/page/documents


## Connecting other systems
When analyzing integration & interoperability options with another system, consider the following questions: 
1. Who are the other users? What information do they access, when, and for what business purpose? 
2. Where is the system hosted? And who manages it/ provides ongoing support? If it is hosted locally, is it web accessible or can it only be accessed via the local network? If it is hosted by a third party, do you have access to that third party to request changes, API access, technical documentation, etc.? 
3. Is there an available REST API and/or webhooks service? If yes, is there available documentation? Does the documentation cover the specific functionality (e.g., updating case records, viewing patient details, submitting a new form entry). 
4. If no API, what are other available ETL options for getting data in/out of the system? How is data currently entered and extracted? (E.g., “Mr. X digitizes visit forms in Excel at this computer, then uploads them using the ‘bulk data entry’ screen in our app at the end of each day. Data is extracted by lab technicians via the ‘Export to CSV’ button, and it is then formatted in Excel and printed to be read by technicians on site.”) 
5. Any known security requirements or authentication considerations? (e.g., firewalls, VPN requirements, IP whitelist requirements?)
6. Is there an available test environment to test integration with the application? (If not, is there a public demo of the application running on the same version that you’re currently running so that we can test the APIs?)

