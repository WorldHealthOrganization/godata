---
layout: default
title: 5. Administrative Unit Areas to Go.Data
parent: Real-World Examples
grand_parent: Go.Data Interoperability
nav_order: 5
permalink: /5-godata--facility-registry/
---

#  Open Source Reference Data Integration with Go.Data (i.e. Country administrative units, health facilities)
Importing administrative locations (e.g., `Admin-Level-2` province data) and different `Location` reference data are typically the first steps in setting up a 
new `Outbreak` in Go.Data. Importing locations from shared reference sources are important to strengthening interoperability and ensuring information can be easily synced and mapped in other systems. 
1. Administrative units are captured as `Location` resources in the Go.Data pplication. All other location data (e.g., **Health Facilities**) should be captured as `Reference Data` in Go.Data. 
2. Location data can be extracted from external shared references (see HDX and other [external data source examples](#external-data-sources)) and uploaded via the standard Go.Data file import feature OR via direct integration to the Go.Data API endpoint `/locations`. 
3. In Go.Data `Location` and `Reference Data` should be imported before data collection can begin.

## Resources for importing Location data 
1. [See p. 33 of the Implementation Guide](https://community-godata.who.int/page/documents) for more information and step-by-step guidance for `Location` data imports. 
2. See [external data source examples](#external-data-sources) for links to location data & reference sources. 
3. See the [`dhis2godata` Org Unit Converter](https://github.com/WorldHealthOrganization/godata/tree/master/dhis2togodata/dhis2godata_org_unit_converter) for example script that will export admin units from a DHIS2 instance for import to Go.Data. 
4. See the API adaptor [language-godata](https://github.com/WorldHealthOrganization/language-godata/blob/master/src/Adaptor.js#L607-L644) example or check out the [API explorer](https://github.com/WorldHealthOrganization/godata/api-docs). 
 
## Other types of location reference data (i.e., health facilities)
In this reference implementation (below docs), we demonstrate how Go.Data `Reference Data` may be synced via APIs between Go.Data and an external web-based data source. While this implementation integrates `HealthSites` data, a similar integration approach may be applied to integrate other data sources with an available web API.**  

- [Watch the video overview](https://sprcdn-assets.sprinklr.com/1652/18c30dd7-141d-4f13-9b5b-c4a6f5b35a03-1187367103.mp4)
- [Explore the Implementation](#explore-the-implementation)

![use-case-5](../assets/use-case-5.png)

---
**Use Case:**
**#5.** _As a Go.Data analyst, I would like to import health facility lists from standard registries and external data sources so that I can more 
easily exchange information with the MOH and other partners._

---
### Solution Overview 
In this reference implementation, we integrated a health facility list extracted from the [http://healthsites.io/](http://healthsites.io/) API with the Go.Data `reference-data` category `Health Centres`. See below for the data flow diagram. 
- In Go.Data `reference-data` must be imported before data collection can begin so that any these can be selected in any data collection or questionnaire form variables. 
- [HealthSites.io](http://healthsites.io/) is an open source repository of health facility data built in partnership with Open Street Map. It contains several facility lists and geolocation details and provides a [REST API](https://github.com/healthsites/healthsites/wiki/API) that supports data extraction in JSON format. 
- Here we leverage the free-tier [OpenFn integration platform](https://docs.openfn.org/) to automate the data integration flow & quickly map Kobo data elements to Go.Data. See [Explore OpenFn](https://github.com/WorldHealthOrganization/godata/explore-openfn) to learn more and explore the live project. 

![dataflow-5](../assets/dataFlow-use-case-5.png)
### Implementation Steps
**-->[Watch to learn about the solution setup](https://sprcdn-assets.sprinklr.com/1652/ccc28fcf-8fe2-40c0-a743-82f9532cb555-447333759.mp4)**
1. We first identified the external data source to be integrated, data availability, and available APIs - see [HealthSites country data](https://healthsites.io/#country-data). 
2. Once we've identified the specific facility we'd like to integrate, we then determine how to export the data from the source. [See here](https://github.com/WorldHealthOrganization/godata/blob/master/interoperability-jobs/5a-GETHealthSitesData.js) for an example OpenFn job script where we send a `GET` HTTP request to `/api/v2/facilities` to list a health facilities for `Bangladesh` in HealthSites.io.
```
GET '/api/v2/facilities/?api-key=NNNNN&page=1&country=Bangladesh'
```
We refer to the data source's [API docs](https://healthsites.io/api/docs/) to determine how to make this HTTP request and apply relevant filters like `country`. 

3. Analyze the response to #2 to determine the appropriate unique identifiers to matching with Go.Data `reference-data` and to use as an external identifier for future duplicate prevention. For this implementation, we chose to use `name` to map to existing `Health Centres`, but you might also consider using a unique location id or geodata codes (see the [Unique Identifiers](http://worldhealthorganization.github.io/godata/unique-identifiers) section for more on this design topic). 

[See here](https://github.com/WorldHealthOrganization/godata/blob/docs-toolkit/interoperability-jobs/sampleData/bangladeshHealthSites.json) for the full JSON response to the `GET` request made to the API in step 2. 
```json
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
4. We then mapped relevant data elements from the HealthSites response to Go.Data `reference-data`. See example [mapping specification](https://docs.google.com/spreadsheets/d/1SNx5wB818ikveaVhHqW9c4N05leL1WGZulsdC_BJj70/edit#gid=1783114713). 

5. We then drafted another OpenFn integration script (or "job" - [see here](https://github.com/WorldHealthOrganization/godata/blob/docs-toolkit/interoperability-jobs/5-uploadHealthSites.js)) to automate the data integration mapping of data points between HealthSites and Go.Data (see below snippet). 
```js 
   const data = { //mapping attributes
      id: `LNG_REFERENCE_DATA_CATEGORY_CENTRE_NAME_${name}`,  //godataVariable: sourceValue,
      categoryId: 'LNG_REFERENCE_DATA_CATEGORY_CENTRE_NAME', //godata reference-data Id
      value: attributes.name, //map from HealthSites.io ...
      code: attributes.uuid,
      active: true,
      readOnly: false,
      outbreakId: '3b5554d7-2c19-41d0-b9af-475ad25a382b',
      description: 'hospital',
      name: attributes.name,
    };
```
In this second job, we perform an "upsert" pattern via the Go.Data API where we (1) check for existing facilities by searching Go.Data `reference-data` category `Health Centre` records using HealthSite `name` to create a matching `id` (e.g., `LNG_REFERENCE_DATA_CATEGORY_CENTRE_NAME_HOSPITAL_1`) as an external identifier, and then (2) create/update the `reference-data` records (send `POST`/`PUT` request) depending on whether a match was found. 
```js
upsertReferenceData('id', { //where id is reference-data-catefory unique identifier
      data, //object where we'll specify healthsite-to-godata mappings
})
```

See `upsertReferenceData(...)` function in the [Go.Data API adaptor](https://github.com/WorldHealthOrganization/language-godata/)

![openfn-5](../assets/openfn-jobs-5.png)

## External Data Sources
See below and p.33 of the [Implementation Guide](https://community-godata.who.int/page/documents) for other data sources you might consider integrating with to automatically register shared `Location` records in Go.Data. 
1. `HDX` – a clearinghouse of humanitarian open-source data. Included for many countries is the administrative unit boundaries which typically has a unique ID (Pcode) and in some cases this will also include additional data such as “population” that can be used in post analysis.
[https://data.humdata.org/](https://data.humdata.org/)

2.`WHO` – Global coverage of administrative unit boundaries, has centroid and Pcode for unique ID – so could be joined back to GIS data afterwards but only goes to Adm2 and in some countries only ADM 1.
[https://polioboundaries-who.hub.arcgis.com/](https://polioboundaries-who.hub.arcgis.com/)

3. `Geonames` – has ID, lat/lon and names – may or may not be able to match up to any GIS outside of Go.Data.
[http://download.geonames.org/export/dump/](http://download.geonames.org/export/dump/)

4. `HealthSites.io` - open source repository of health facility data built in partnership with Open Street Map [http://healthsites.io/](http://healthsites.io/)

# Explore the Implementation
1. See the [Explore OpenFn](https://worldhealthorganization.github.io/godata/explore-openfn/) page to explore the jobs on the live reference project. 
- [Watch the video overview](https://sprcdn-assets.sprinklr.com/1652/18c30dd7-141d-4f13-9b5b-c4a6f5b35a03-1187367103.mp4)
- [Learn about the solution setup](https://sprcdn-assets.sprinklr.com/1652/ccc28fcf-8fe2-40c0-a743-82f9532cb555-447333759.mp4)
- And [see here](https://community-godata.who.int/topics/interoperability/5fd8ec64f5c77e114e6c6823) for other interoperability videos. 

2. **[HealthSites.io](https://healthsites.io/)**: [See here](https://github.com/healthsites/healthsites/wiki/API) for the API docs and instructions for creating your own OpenStreetMap account to access the data source via the API. 

3. **Job scripts**: See the Github [`interoperability-jobs`](https://github.com/WorldHealthOrganization/godata/tree/master/interoperability-jobs) to explore the source code used to automate these flows. These leverage an open-source Go.Data API wrapper - the OpenFn adaptor [`language-godata`](https://github.com/WorldHealthOrganization/language-godata/). 

4. **Solution Design Documentation**: [See this folder](https://drive.google.com/drive/folders/1qL3el6F2obdmtu2QKgcWYoXWsqBkhtII)] for the data flow diagram & data element mapping specifications mentioend above and used to write the integration jobs. 


