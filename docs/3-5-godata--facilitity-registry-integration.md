---
layout: default
title: 5. Locations/ Facility Registry Integration to Go.Data
parent: Interoperability Examples
nav_order: 5
permalink: /3-5-godata--facilitity-registry-integration/
---
#  Locations/ Facility Registry Integration to Go.Data
Importing administrative locations (e.g., `Admin-Level-2` province data) and different `Location` reference data are typically the first steps in setting up a 
new `Outbreak` in Go.Data. Importing location and facility lists from shared reference sources are important to strengthening interoperability and ensuring information can be easily synced and mapped in other systems. [See p. 33 of the Implementation Guide](https://community-godata.who.int/page/documents) for more information and step-by-step guidance for data imports of Location data. 

**Here we demonstrate how `Location` data may be synced via APIs between Go.Data and an external web-based data source. While this implementation integrates `HealthSites` data, a similar integration approach may be applied to integrate other data sources with an available web API.**  
![use-case-5](../assets/use-case-5.png)

---
**Use Case:**
**#5.** _As a Go.Data analyst, I would like to import facility and location lists from standard registries and external data sources so that I can more 
easily exchange information with the MOH and other partners._

---
### Solution Overview
In this reference implementation, we integrated a health facility list extracted from the http://healthsites.io/ API with Go.Data `Location` data. See below for the data flow diagram. 
- In Go.Data `Location` data must be imported before data collection can begin.  How every country is administratively structured differs (i.e., admin level 0, admin level 1, admin level 2 etc.), but Go.Data supports capture of different location hierarchies, along with the geocodes and coordinates (latitude and longitude). 
- [HealthSites.io](http://healthsites.io/) is an open source repository of health facility data built in partnership with Open Street Map. It contains several facility lists and geolocation details and provides a [REST API](https://github.com/healthsites/healthsites/wiki/API) that supports data extraction in JSON format. 
- Here we leverage the [OpenFn integration platform](https://docs.openfn.org/) to automate the data integration flow & quickly map Kobo data elements to Go.Data. OpenFn offers [open-source](https://openfn.github.io/microservice/readme.html) and hosted implementation options. 

![dataflow-5](../assets/io-use-case-5.png)
### Integration Steps
1. We first identified the external data source to be integrated, data availability, and available APIs - see [HealthSites country data](https://healthsites.io/#country-data). 
2. Once we've identified the specific facility we'd like to integrate, we then determine how to export the data from the source. [See here](https://github.com/WorldHealthOrganization/godata/blob/master/interoperability-jobs/5a-GETHealthSitesData.js) for an example OpenFn job script where we send a `GET` HTTP request to `/api/v2/facilities` to list a health facilities for `Bangladesh` in HealthSites.io.
```
GET '/api/v2/facilities/?api-key=NNNNN&page=1&country=Bangladesh'
```
We refer to the data source's [API docs](https://healthsites.io/api/docs/) to determine how to make this HTTP request and apply relevant filters like `country`. 

3. Analyze the response to #2 to determine the appropriate unique identifiers to matching with Go.Data `Locations` and to use as an external identifier for future duplicate prevention. For this implementation, we chose to use `name`, but you might also consider using a unique location id or geodata codes (see the [Unique Identifiers](http://worldhealthorganization.github.io/godata/topics/1-unique-identifier-schemes) section for more on this design topic). 

[See here](https://github.com/WorldHealthOrganization/godata/blob/docs-toolkit/interoperability-jobs/sampleData/bangladeshHealthSites.json) for the full JSON response to the `GET` request made to the API in step 2. 
```.json
{
  "0": {
    "attributes": {
      "amenity": "hospital",
      "changeset_id": 22058971,
      "changeset_timestamp": "2014-05-01T07:56:20",
      "changeset_user": "Md Alamgir",
      "changeset_version": 1,
      "name": "Manikchari Upazila Health Complex",
      "uuid": "4598ac8e8c6d47a4a3b95d0806ca4a5d"
    },
    "centroid": {
      "coordinates": [
        91.84117813480628,
        22.8501898435141
      ],
      "type": "Point"
    },
    "completeness": 9,
    "osm_id": 2828406228,
    "osm_type": "node"
  },
```
4. We then mapped relevant data elements from the HealthSites response to Go.Data `Location`. See example [mapping specification](https://drive.google.com/drive/folders/1qL3el6F2obdmtu2QKgcWYoXWsqBkhtII). In this step, it was also important to determine the `geographicalLevelId` to be assigned based on the location hierarchy configured in Go.Data and `parentLocationId` where relevant. We leveraged the Go.Data `identifiers` variables (e.g., `uuid`, `osm_id`) to capture other external identifiers provided by HealthSites to track Locations. 

5. We then drafted an OpenFn integration script (or "job" - [see here](https://github.com/WorldHealthOrganization/godata/blob/docs-toolkit/interoperability-jobs/5-uploadHealthSites.js)) to automate the data integration mapping of data points between HealthSites and Go.Data (see below snippet). 
```.js 
   const data = {
      name: attributes.name,
      identifiers: [{ description: 'uuid', code: attributes.uuid }],
      geoLocation: { lat: coordinates[1], lng: coordinates[0] },
      active: true,
      parentLocationId: 'e86414e4-d91c-4ab8-be2a-720ae90b5106',
      geographicalLevelId:
        'LNG_REFERENCE_DATA_CATEGORY_LOCATION_GEOGRAPHICAL_LEVEL_HOSPITAL_FACILITY',
    };
```
In this job, we perform an "upsert" pattern via the Go.Data API where we (1) check for existing facilities by searching Go.Data `Location` records using HealthSite `name` (e.g., `"Manikchari Upazila Health Complex"`) as an external identifier, and then (2) create/update the `Location` records (send `POST`/`PUT` request) depending on whether a match was found. 
```.js
upsertLocation('name', {
      data,
})
```

See `upsertLocation(...)` function in the Go.Data API adaptor: https://openfn.github.io/language-godata/global.html#upsertLocation


### Implementation Resources
1. [See this video](...) of the demo solution configured to demonstrate this use case #5.  
2. [HealthSites.io](https://healthsites.io/): [See here](https://github.com/healthsites/healthsites/wiki/API) for the API docs and instructions for creating your own OpenStreetMap account to access the data source via the API. 
3. Integration: See [example integration scripts for scenario `5`](https://github.com/WorldHealthOrganization/godata/tree/master/interoperability-jobs) implemented on the OpenFn integration platform for automated data exchange. Explore the solution at [OpenFn.org](https://www.openfn.org/login) using the login details: `demo@godata.org`; pw: `interop!2021`. 
4. Go.Data API Wrapper: See the open-source OpenFn adaptor [language-godata](https://openfn.github.io/language-godata/). 
5. See the solution [design documentation](https://drive.google.com/drive/folders/1qL3el6F2obdmtu2QKgcWYoXWsqBkhtII).

### External Data Sources
See below and p.33 of the [Implementation Guide](https://community-godata.who.int/page/documents) for other data sources you might consider integrating with to automatically register shared `Location` records in Go.Data. 
1. `HDX` – a clearinghouse of humanitarian open-source data. Included for many countries is the administrative unit boundaries which typically has a unique ID (Pcode) and in some cases this will also include additional data such as “population” that can be used in post analysis.
https://data.humdata.org/
2.`WHO` – Global coverage of administrative unit boundaries, has centroid and Pcode for unique ID – so could be joined back to GIS data afterwards but only goes to Adm2 and in some countries only ADM 1.
https://polioboundaries-who.hub.arcgis.com/
3. `Geonames` – has ID, lat/lon and names – may or may not be able to match up to any GIS outside of Go.Data.
http://download.geonames.org/export/dump/
4. `HealthSites.io` - open source repository of health facility data built in partnership with Open Street Map http://healthsites.io/
