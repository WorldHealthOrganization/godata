---
layout: default
title: 4. Mobile App to Go.Data Integration
parent: Interoperability Examples
nav_order: 4
permalink: /3-4-godata--mobile-integration/
---
# Mobile to Go.Data Integration
Mobile apps and survey tools are widely used by Go.Data implementers and other health initiatives for on-the-ground data collection, response, basic monitoring. Many of these tools are open-source and developed on similar frameworks (e.g., ODK, Kobo Toolbox, ONA, CommCare), so the available integration options are very similar. 

---
**Use Case:**
**#4.** _As a MOH employee, I would like to integrate case data collected via my mobile survey tool so that I can monitor new case registrations in real-time and quickly follow up with new contacts._

---
## Solution Overview
In this reference implementation, we integrated a COVID-19 data collection form configured on [Kobo Toolbox](https://docs.openfn.org/) with Go.Data to deliver real-time case registration as mobile data is captured. See diagram below for the data flow. 
- Kobo Toolbox is a free mobile data collection app with offline support that is widely used in humanitarian response contexts. 
- Here we leverage the [OpenFn integration platform](https://docs.openfn.org/) to automate the data integration flow & quickly map Kobo data elements to Go.Data. OpenFn offers [open-source](https://openfn.github.io/microservice/readme.html) and hosted implementation options. 
![dataflow-4](../assets/io-use-case-4.png)

## Integration Steps
1. Consider how to extract data from your mobile application ([see this section](https://worldhealthorganization.github.io/godata/topics/#8-integrating-with-mobile-data-collection-apps) for an overview of common options). In this implementation we configured a REST Service on Kobo Toolbox to automatically forward new Kobo Toolbox form submissions collected via mobile to a specified endpoint–our demo OpenFn 
2. 

### Explore the Implementation
1. [See this video](...) of the demo solution configured to demonstrate this use case #4.  
2. Kobo Toolbox: Explore the demo Kobo project at [https://kf.kobotoolbox.org/](https://kf.kobotoolbox.org/) & REST Service configured using the login details: `godata_demo`; pw: `interoperability`. 
3. Integration: See [example integration scripts](https://github.com/WorldHealthOrganization/godata/tree/docs-toolkit/interoperability-jobs) implemented on the OpenFn integration platform for automated data exchange. Explore the solution at [OpenFn.org](https://www.openfn.org/login) using the login details: `demo@godata.org`; pw: `interop!2021`. 
4. See the solution [design documentation](https://drive.google.com/drive/folders/1qL3el6F2obdmtu2QKgcWYoXWsqBkhtII).
