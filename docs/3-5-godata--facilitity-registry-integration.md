---
layout: default
title: 5. Locations/ Facility Registry Integration to Go.Data
parent: Interoperability Examples
nav_order: 5
permalink: /3-5-godata--facilitity-registry-integration/
---
#  Locations/ Facility Registry Integration to Go.Data
Importing administrative locations (e.g., `Admin-Level-2` province data) and different `Location` reference data are typically the first steps in setting up a 
new `Outbreak` in Go.Data. Importing location lists from shared reference sources are important to strengthening interoperability and ensuring information can 
be easily synced and mapped in other systems. [See p. 33 of the Implementation Guide](...) for more information and step-by-step guidance for data imports.
 Here we demonstrate how `Location` data may be synced via APIs.  

---
**Use Case:**
**#5.** _As a Go.Data analyst, I would like to import facility and location lists from standard registries and external data sources so that I can more 
easily exchange information with the MOH and other partners._

---
![dataflow-5](../assets/io-use-case-5.png)
### Integration Steps
1. Identify the external data source and available APIs - see [Health Sites example](). 
2. Export the data from the source - [see here]() for an example script where we send a `GET` HTTP request to `/api/facilities` to fetch a health facility list.
3. Analyze the response to #2 to determine the appropriate unique identifiers to matching with Go.Data `locations` and to use as `externalId` for future duplicate prevention. 
4. Upsert the facilities as `locations` in Go.Data using `name` as an external identifier to match existing locations ([see script here](...). You might also consider matching on other unique identifiers such as available `uuid` or `geodata` codes. 

### Implementation Resources
1. [See this video](...) of the demo solution configured to demonstrate this use case #5.  
2. To click around & explore the solution in-depth, go to OpenFn.org...
3. See [example integration scripts](...) ... 
4. See the solution [design documentation](...) ... 

### External Data Sources
1. `HDX` – a clearinghouse of humanitarian open-source data. Included for many countries is the administrative unit boundaries which typically has a unique ID (Pcode) and in some cases this will also include additional data such as “population” that can be used in post analysis.
https://data.humdata.org/
2.`WHO` – Global coverage of administrative unit boundaries, has centroid and Pcode for unique ID – so could be joined back to GIS data afterwards but only goes to Adm2 and in some countries only ADM 1.
https://polioboundaries-who.hub.arcgis.com/
3. `Geonames` – has ID, lat/lon and names – may or may not be able to match up to any GIS outside of Go.Data.
http://download.geonames.org/export/dump/
4. `HealthSites.io` - open source repository of health facility data built in partnership with Open Street Map http://healthsites.io/
