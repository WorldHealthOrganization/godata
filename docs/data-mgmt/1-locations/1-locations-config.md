---
layout: page
title: Configuring locations
parent: Data Management
nav_order: 1
permalink: /locations/
has_children: false
---

# Configuring locations in Go.Data 

Within the Go.Data system, “Location” data refers to the administrative unit levels you want to report your data at and it is also used to assign teams for contact tracing and follow-up. 

For example, administrative unit level zero (ADMIN 0) is the country level, administrative unit level one (ADMIN 1) could be a region, administrative level two (ADMIN 2) a province, etc. 

![](../assets/location_tree_godata.PNG)

Each country will have its own levels it typically aggregates and reports health data at. These may be administrative areas or health service areas. As it is a required reference dataset for the Go.Data system, users upload their respective hierarchical location data prior to creating an outbreak in the system. Go.Data is not shipped with this data so that users will have the flexibility to use their own best available sources. Below we describe a few ways to configure your locations.

### ***Bulk Import*** 
- To Bulk Import via Excel files, we have a step-by-step SOP in both [English](https://sprcdn-assets.sprinklr.com/1652/4b8d1d7d-12cf-4911-987e-e9a1a0fd3c41-2422637769.pdf) and [French]() for how to bulk import your locations. 
- We have developed structured excel templates [here](https://github.com/WorldHealthOrganization/godata/tree/master/docs/data-mgmt/1-locations) so that you can adapt and quickly get started.
- Follow [this thread in the Community of Practice](https://community-godata.who.int/conversations/locations-reference-data-languages/sop-bulk-importing-locations-into-godata/6022b951ed9dc017691d861f) to ask your questions or get tips.
- You can also import .json files, such as your location .json tree exported from DHIS2 (see below)

### ***Replicate location tree from another system***
- ***DHIS2*** For DHIS2 users, we have developed tools to replicate your DHIS2 Org Unit to be the basis of your location tree in Go.Data. For this you can either use [Go.Data-DHIS2 Interoperability App](https://github.com/WorldHealthOrganization/dhis2-godata-interoperability) ***or*** utilize DHIS2 Org Unit Converter, which you can find at this repository here: [https://github.com/EyeSeeTea/WHO-scripts/tree/master/dhis2godata](https://github.com/EyeSeeTea/WHO-scripts/tree/master/dhis2godata). [See the Metadata Export Guide for more details](https://github.com/WorldHealthOrganization/godata/blob/master/docs/interoperability/GoData%20-%20DHIS2%20interoperability-%20Metadata%20Export%20Guide.pdf)
- ***WHO Polio DataBase*** For those who want to utilize WHO Geo-Data via [The Global Polio Administrative Boundaries project](https://polioboundaries-who.hub.arcgis.com/pages/boundarydownloads) to be the basis of your location tree in Go.Data, there are scripts to transform this data into necessary Go.Data format. See Github Repository here: [https://github.com/EyeSeeTea/WHO-scripts/tree/master/PolioDB-GODATA](https://github.com/EyeSeeTea/WHO-scripts/tree/master/PolioDB-GODATA)

### ***API***
- You can create locations via the API - please see more information in the API [here](https://worldhealthorganization.github.io/godata/api-docs/)

### ***Indivual Creation in Web-app***
- if you don't have many locations to create, you can add these one-by-one in the web-app. Please refer to the user guide for more information.

## Using GIS data as a source for your location data
Below we provide suggestions on where to find this data when you are in configuration phase, more specifically, from GIS sources. Users are encouraged to always check with their public health agency/organization for guidance on these data first – we are providing these sources as suggestions only. However, you may find that these sources align with what your public health agency endorses.

_Why are we suggesting using GIS data as a source for location data?_
1.	Comprehensive administrative boundary datasets are publicly available for most of the world
2.	GIS datasets typically have a unique identifier for each feature/area (a requirement of Go.Data)
3.	By using a GIS dataset (and its unique identifiers) to define your location data – you will be able to tie back into GIS data outside of Go.Data for further analysis and visualization
4.	Many times, other useful data is included with GIS boundary data – such as population data – which can be used for further analysis outside of Go.data (eg. calculating rates, etc.)

Location information can be found in many places, but here are a few recommendations:

***WHO Global Geo-data***
The Global Polio Administrative Boundaries project was initiated to compile all available administrative units by country which connect best with GPEI data. Although developed for the Polio program, it is available to the public for use. You can search, visualize and download the various levels of polio administrative boundaries from this page. Various formats of total data or subset of data are available in excel, csv, shape file, geo-database or as API services from this page. 

NOTE: the dataset is available for Admin 0, 1, and 2 only. The excel spreadsheet download will include a unique identifier, centroid coordinates, as well as associated admin area names and IDs (hierarchical). Please read the meta data for the datasets as boundaries are dated and you will want to use current version.

[https://polioboundaries-who.hub.arcgis.com/pages/boundarydownloads](https://polioboundaries-who.hub.arcgis.com/pages/boundarydownloads)

***The Humanitarian Data Exchange (HDX)***
HDX is managed by the United Nations Office of Coordination for Humanitarian Affairs (UNOCHA) Centre for Humanitarian Data. It is an open platform for humanitarian data which is designed so that data is easy to find and can be downloaded and used for analysis. 

NOTE: This is a voluntary clearinghouse for data therefore the data availability, admin levels and format vary by country. In some cases, it is only available in GIS format, in those cases someone with GIS skills may need to clean and/or format it to Go.Data requirements.

[https://data.humdata.org/](https://data.humdata.org/)

***Global Administrative Areas (GADM)***
GADM is a high-resolution database of country administrative areas. The GADM website and data repository is hosted at UC Davis in the Hijmans Lab. The goal is to maintain GIS for all countries, at all levels, at any time period. Formats include shapefile, geopackage and some R-based formats.

NOTE: Someone with GIS or R skills may need to clean and/or format it to Go.Data requirements.

[https://gadm.org/data.html](https://gadm.org/data.html)

***Geonames***
The GeoNames geographical database covers all countries and contains over eleven million placenames that are available for download free of charge under a creative commons attribution license. The data is accessible through a number of webservices and a daily database export. The data is compiled from over a hundred sources and is managed by GeoNames ambassadors.

NOTE: The data format is tab-delimited text in utf8 encoding. It includes a name, ID and centroid lat/lons. Web services in XML and JSON are also available.

[https://www.geonames.org/export/#dump](https://www.geonames.org/export/#dump)

TIP: A shapefile is made up of many individual files. The file that stores information with the ID and administrative area name is stored in the .dbf file. It is not necessary to have GIS skills or access to a GIS application to see that – you can open this file in Excel to view those attributes. So, if you download an admin shapefile, open excel and navigate to and open the associated .dbf file to see the attributes.

