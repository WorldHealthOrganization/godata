---
layout: page
parent: Getting Started
grand_parent: Go.Data Interoperability Toolkit
title: Interoperability QuickStart
nav_order: 1
permalink: /interoperability-quickstart/
---

# Interoperability Planning QuickStart
When considering which approach is best-fit for your implementation, ask yourself...

1. What are your _functional_ interoperability requirements. _What_ information needs to be shared, with _which user groups/organizations_, and _when_? 
2. What are your _compliance/legal_ requirements with respect to data sharing and privacy. Are there any country-specific compliance requirements that need to be adhered to? 
3. What systems/tools do partner organizations use and what are their _technical_ requirements? See below section [Connecting other systems](#connecting-other-systems) for specific questions to ask.  
4. What are specific requirements, or _user stories_, that fully describe the functional need, purpose, and people involved? Consider documenting these. Typically a user story will include (1) _who_ the requirement supports, (2) _what_ the requirement/need is, and (3) for what _purpose_/ business function. [See here](https://www.atlassian.com/agile/project-management/user-stories) for standard user story templates and see the [Use Cases](https://worldhealthorganization.github.io/godata/use-cases/) sections of this documentation for sample user stories. 
5. What are your interoperability options? Once you have a clear understanding of the functional, compliance/legal, and technical requirements for your interoperability solution, review available [Data Input & Sharing Options](https://worldhealthorganization.github.io/godata/options/) to evaluate and determine the best-fit approach for your requirements.
6. What specific data elements need to be exchanged from your systme to Go.Data? Build a map. [See here](https://community-godata.who.int/page/documents) for a **Go.Data mapping specification template**.
7. What technical resources will be required to implement the integration? Create a check-list. [See here](https://community-godata.who.int/page/documents) for a template **Go.Data Integration Checklist**. 

## Other Planning Resources
- Go.Data interoperability examples under [reference implementations](https://worldhealthorganization.github.io/godata/interoperability-examples/)
- Go.Data Implementation Guide & shareable overviews to share with interested partners: [https://community-godata.who.int/page/documents](https://community-godata.who.int/page/documents)
- WHO [Digital Health Atlas](https://digitalhealthatlas.org/en/-/): see [this instructional video](https://www.youtube.com/watch?v=97wIGZ_YdeM) on how this tool can help inform digital health landscape in your setting when considering implementation and interoperability  
- Other helpful guidances such as the DHIS2 [Implementation Guide](https://docs.dhis2.org/2.34/en/dhis2_implementation_guide/integration-concepts.html#implementation-steps-for-successful-data-and-system-integration) and the [OpenHIE Implementation Methodology](https://wiki.ohie.org/display/documents/OpenHIE+Planning+and+Implementation+Guides) 

## Connecting other systems
When analyzing integration & interoperability options with another system, consider the following questions: 
1. Who are the other users? What information do they access, when, and for what business purpose? 
2. Where is the system hosted and who manages? If it is hosted locally, is it web accessible or can it only be accessed via the local network? If it is hosted by a third party, do you have access to that third party to request changes, API access, and technical documentation? 
3. Is there an available REST API and/or webhooks service? If yes, is there available documentation? Does the documentation cover the specific functionality (e.g., updating case records, viewing patient details, submitting a new form entry)?
4. If no API, what are other available ETL options for getting data in/out of the system? How is data currently entered and extracted? (E.g., “Mr. X digitizes visit forms in Excel at this computer, then uploads them using the ‘bulk data entry’ screen in our app at the end of each day. Data is extracted by lab technicians via the ‘Export to CSV’ button, and it is then formatted in Excel and printed to be read by technicians on site.”) 
5. Are there any known security requirements or authentication considerations? (e.g., firewalls, VPN requirements, IP whitelist requirements?)
6. Is there an available test environment to test integration with the application? (If not, is there a public demo of the application running on the same version that you’re currently running so that we can test the APIs?)

