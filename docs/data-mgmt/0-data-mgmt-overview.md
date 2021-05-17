---
layout: page
title: How to manage my data
nav_order: 2
permalink: /data-mgmt/
has_children: true
---

# Go.Data Data Management Principles & Resources

## Metadata Overview

This document [here](https://sprcdn-assets.sprinklr.com/1652/69a1e048-e8b7-47ea-8e90-512a50600ecd-1206687439.pdf) describes an overview of the metadata within Go.Data. You can find a table of the _required metadata fields_ below. Please refer to document to see the entire list.

Variable Label     | Code                | Defintiion        |  Source / Notes
------------------|---------------------|-------------------|-------------------- 
**Visual ID** | id | Unique Identifier for any entity (Case, Contact, Contact of Contact or Event) created in the system | Pattern set in Outbreak settings. Read more info on unique IDs and cask masks [here]()
**First Name** | first_name | First Name of person or event | Freetext. Additional fields for Middle and Last Name exist but are optional. If you do not want to put the actual first name, you can also put an ID here (for instance, Country Identifier or Passport Number). 
**Date of Reporting** | date_of_reporting | Date (YYYY-MM-DD) that record is filled | Date selector from calendar.
**Location** | address_location | Location (Recommended to fill most granular Admin Level) | Configurable Go.Data Reference Data (choose from location hierarchy, after your locations have been configured)
**Address type** | address_type | Type of address | Date
Address date | address_date | Date that the address is valid until | Configurable Go.Data Reference Data (Default Values: Current Address, Previous Address)
**Classification** | classification | Classification of case | Configurable Go.Data Reference Data (Default values include "Confirmed", "Probable", "Suspect", "Not A Case-Discarded"
**Date of Last Contact** | date_of_last_contact | Date of last contact with the confirmed or probable COVID-19 case | Date selector from calendar. NOTE: This will be used in generating Follow Up period.

## Data Dictionary

You can download this template excel file [here](https://sprcdn-assets.sprinklr.com/1652/dbcc4983-9761-4abc-b5e6-cce1b5c33f10-1723930809.xlsx) to build out a data dictionary for your Go.Data platform.
**NOTE: You can code variables however you would like, and adapt your reference data to suit your purposes. Using this data dictionary as a starting point, please adapt it to fit what you have configured in your system. This would include adding in entirely new variables that you may have added for custom questionnaires for cases, contacts, follow-ups and labs.**
