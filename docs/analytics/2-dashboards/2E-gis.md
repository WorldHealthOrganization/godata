---
layout: page
title: GIS
parent: Data Visualization
grand_parent: Analytics & Dashboards
nav_order: 5
permalink: /gis/
has_children: false
---

# Options and Considerations for GIS Analysis in Go.Data 
Coming soon {: .label .label-yellow }

## Example Maps Using Go.Data Data
-links/screenshots here of very basic GIS maps, using Go.Data data in test instance
-template GIS files, linked up to Go.Data data in test instance

## Go.Data Location Variables
The below variables are stored within the `addresses` block of .json, when registering cases, contacts or events. Please note that some are from reference data that must be configured, while others are freetext. **Indicates Required Field**

Variable Name     | Code                | Defintiion        |  Source / Notes
------------------|---------------------|-------------------|-------------------- 
**Location** | address_location | Location (Recommended to fill most granular Admin Level) | Configurable Go.Data Reference Data (choose from location hierarchy, after your locations have been configured)
Latitude | address_lat | Latitude |  Configurable Go.Data Reference Data OR manual capture depending on location chosen from drop-down
Longitude | address_lat | Longitude | Manual Capture OR taken from Go.Data Reference Data depending on location chosen from drop-down
Coordinates Accurate | address_gps_accurate | GPS Coordinates are considered precise | Toggle to mark Yes or No
City | address_city | City | freetext
Street | address_street | Street | freetext
Phone Number | address_city | City | freetext
Postal Code | address_postal | Postal Code | freetext
Email address | address_email| Email Address | freetext
**Address type** | address_type | Type of address | Date
Address date | address_date | Date that the address is valid until | Configurable Go.Data Reference Data (Default Values: Current Address, Previous Address)

The Go.Data address variables can be found in the "Address" Block when going to register a case, contact or event, as seen in screenshot below. You can add as many addresses as you want for an entity. The address marked as `type` = `current` will be that which is used in analytics dashboards within the application. 
![](../assets/address_block.png)

## Configuring your Go.Data Locations
- [this guidance](https://community-godata.who.int/conversations/locations-reference-data-languages/sop-bulk-importing-locations-into-godata/6022b951ed9dc017691d861f) contains a step-by-step guide on how to bulk import locations using excel files, in addition to sample excel templates.

## Using GIS Data for your Go.Data Location Configuration
-excel files of dummy data used to create maps


## Sample Go.Data Location Dummy Data for Analysis
-excel files of dummy data used to create maps


