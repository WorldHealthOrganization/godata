---
layout: default
title: Live Integrations
parent: Go.Data Interoperability
nav_order: 5
permalink: /integration-scripts/
---

# Go.Data Integration Scripts
_To date, Go.Data partners have written integration code using JavaScript, C#, Python and R. You can find integration scripts related to the Go.Data project in the WHO repository [here](https://github.com/WorldHealthOrganization?q=go-data&type=&language=)_
_To engage directly with this community, visit the "Interoperability" forum in the CoP [here](https://community-godata.who.int/topics/interoperability/5fd8ec64f5c77e114e6c6823)_

## 1. Connectors to external Analytics Tools
See [Analytics documentation](https://worldhealthorganization.github.io/godata/analytics/) and the Github directory [analytics](https://github.com/WorldHealthOrganization/godata/tree/master/analytics) to learn more, including:

-*Exporting to R for analysis & Dashboards:* We have developed some template R scripts for extracting, cleaning, and running some basic analysis. Output includes flattened cleaned `.csv` files for case/contact linelists and HTML dashboards displaying operational performance metrics for contact tracing by contact tracing supervisor and teams. See 
[Github directory](https://github.com/WorldHealthOrganization/godata/tree/master/analytics/r-reporting) & [Analytics documentation](https://worldhealthorganization.github.io/godata/analytics/) for further info.

-*PowerBI:* _New scripts and template dashboards under review and coming soon._ [See the community](https://community-godata.who.int/conversations/dashboards-and-analysis/connecting-power-bi-through-api/5f8033acbd255079ca8ce356) for related discussion. 

## 2. DHIS2 to Go.Data
### [Go.Data-DHIS2 Interoperability App](https://wiscentd-upc.github.io/godata-dhis2-interoperability-app/)

![architecture-summary](../assets/dhis2togodata.PNG)

Collaborators at the Polytechnic University of Catalonia (UPC) have developed a DHIS2 app for exporting metadata and data between DHIS2 and Go.Data. This has been a common request for countries who are using DHIS2 COVID-19 package for case registration but would like to utilize Go.Data for contact tracing follow-up. See demo video below, and instructions on how to install at the project site linked above. 

<video width="1098" height="604" src="https://sprcdn-assets.sprinklr.com/1652/67feefd9-83ea-40c3-b0fc-c4f0c0180b9d-36486025.mp4" controls />

For questions / considerations on if this can be piloted in your setting and to provide feedback, please view [this post](https://community-godata.who.int/conversations/interoperability/call-of-interest-piloting-godatadhis2-interoperability-app/6012b391dbaa4b35ec1837cd) on the Go.Data Community of Practice.

See Github directories: [dhis2-godata-interoperability](https://github.com/WorldHealthOrganization/dhis2-godata-interoperability) & [godata-api-wrapper](https://github.com/WorldHealthOrganization/godata-api-wrapper)

### DHIS2 to Go.Data Metadata Sync
Collaborators at [EyeSeeTea](https://github.com/EyeSeeTea) have developed a script to quickly convert dhis2 Organization Units to Go.Data locations.

See Github directory: [dhis2godata](https://github.com/WorldHealthOrganization/WIDP-DHIS2-scripts/tree/master/dhis2godata)

## 3. OpenFn Job Scripts for API Actions
See Github directory: [interoperability-jobs](https://github.com/WorldHealthOrganization/godata/tree/master/interoperability-jobs)

This folder contains reference implementations of automated interoperability solutions to demonstrate common Go.Data interoperability 
use cases and example [OpenFn job scripts](https://docs.openfn.org/documentation.html#jobs) that automate common API and data exchange operations. 

These jobs leverage OpenFn open-source API adaptors including [`language-godata`](https://github.com/WorldHealthOrganization/language-godata/).

## 4. Other Scripts for API Actions
See Github directory: [api](https://github.com/WorldHealthOrganization/godata/tree/master/api) and [Analytics documentation](https://worldhealthorganization.github.io/godata/analytics/).

This contains example R, Pythin and C# scripts for GET/PUT/POST commands so that you can manipulate your Go.Data instance through the API, including bulk actions. We have used this for our training instances but think it could be helpful for others too.

## 5. WHO Polio Database to Go.Data
See Github directory: [PolioDB-GODATA](https://github.com/EyeSeeTea/WHO-scripts)

-Collaborators at [EyeSeeTea](https://github.com/EyeSeeTea) have developed a script to quickly convert admin levels from the WHO Polio GeoDatabase to Go.Data locations.

## 6. Lime Survey to Go.Data
A project developed internally by WHO Information Management and Technology Department to link Data Form (Lime Survey) to Go.Data API for the exchange of COVID-19 tracking data for WHO staff. This is a very specific solution internal to WHO's need but illustrates integrating the Lime Survey and Go.Data interfaces using .Net 4.7.2 - C# code. 

_Code and documentation coming soon_
