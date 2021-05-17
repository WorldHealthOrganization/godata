---
layout: page
title: How to manage my data
nav_order: 2
permalink: /data-mgmt/
has_children: true
---

# Getting to know your Data
Before beginning data collection and in order to consider any analytics and interoperability solutions, you should get to know the metadata requirements within the Go.Data, including understanding what is defined vs. what you can configure on your own. We recommend keeping up-to-date technical documentation for your deployment such as a Data Dictionary, which we describe below.

## Metadata Overview

This document [here](https://sprcdn-assets.sprinklr.com/1652/69a1e048-e8b7-47ea-8e90-512a50600ecd-1206687439.pdf) describes an overview of the metadata within Go.Data. You can find a table of the _required metadata fields_ below. Please refer to document to see the entire list.

### Case/Contact Required Variables
When creating a new person (case, contact or contact of contact), you are prompted to fill out 3 main sections - **Personal**, **Address**, and **Epidemiology**. 

Within these tabs you have a range of pre-formatted core variables to fill in - some required, some optional. The table below highlights the required fields.

Variable Label     | Code                | Defintiion        |  Source / Notes
------------------|---------------------|-------------------|-------------------- 
**Case/Contact ID** | id | Visual Unique Identifier for any entity (Case, Contact, Contact of Contact) created in the system | Pre-filled according to pattern set in Outbreak settings. Read more info on unique IDs and cask masks [here](). This is NOT the same as the uuid generated automatically but we recommend you have a read-able Visual ID system across all cases and contacts.
**First Name** | first_name | First Name of person or event | Freetext. Additional fields for Middle and Last Name exist but are optional. If you do not want to put the actual first name, you can also put an ID here (for instance, Country Identifier or Passport Number). 
**Date of Reporting** | date_of_reporting | Date (YYYY-MM-DD) that record is filled | Date selector from calendar.
**Location** | address_location | Location (Recommended to fill most granular Admin Level) | Configurable Go.Data Reference Data (choose from location hierarchy, after your locations have been configured)
**Address type** | address_type | Type of address | Configurable Go.Data Reference Data (Default Values: Current Address, Previous Address)
**Classification** | classification | Classification of case | Configurable Go.Data Reference Data (Default values include "Confirmed", "Probable", "Suspect", "Not A Case-Discarded"
**Date of Onset** | date_of_onset | Date of symptom onset | Date selector from calendar. NOTE: You can set in outbreak settings for this field to be not required (as may be desirable for COVID-19 with many asymptomatic cases.
**Date of Last Contact** | date_of_last_contact | Date of last contact with the confirmed or probable COVID-19 case | Date selector from calendar. NOTE: This will be used in generating Follow Up period.

### Event Required Variables
When creating an event, you are prompted to fill out 2 main sections - **Details** and **Address**.

Within these tabs you have a range of pre-formatted core variables to fill in - some required, some optional. The table below highlights the required fields.

Variable Label     | Code                | Defintiion        |  Source / Notes
------------------|---------------------|-------------------|-------------------- 
**Event Name** | name | Event name | Freetext
**Date of Reporting** | date_of_reporting | Date (YYYY-MM-DD) that record is filled | Date selector from calendar.
**Date** | date | Date (YYYY-MM-DD) that event occurred | Date selector from calendar.
**Location** | address_location | Event Location (Recommended to fill most granular Admin Level) | Configurable Go.Data Reference Data (choose from location hierarchy, after your locations have been configured)

### Lab Required Variables
When creating an lab sample, you are prompted to fill out only 1 main section - **Details**. You can add as many lab results for any given person, over time. The records are _per sample_ not _per person_.
**NOTE**: From the web-app, you can only create a lab sample for an existing registered person (case, contact or contact of contact). If bulk importing, you must indicate existing **Person ID** with the proper pattern. A **Sample ID** is not required but is an optional field.

Within this tab you have a range of pre-formatted core variables to fill in - some required, some optional. The table below highlights the required fields.

Variable Label     | Code                | Defintiion        |  Source / Notes
------------------|---------------------|-------------------|-------------------- 
**Person ID** | id | Visual Unique Identifier for any entity (Case, Contact, Contact of Contact) created in the system | This is already stored if you are adding lab-result in web-app. If bulk importing lab results, you must add a column for "Person ID".
**Date Sample Taken** | date | Date (YYYY-MM-DD) that lab sample was taken | Date selector from calendar.

## Data Dictionary

You can download this template excel file [here](https://sprcdn-assets.sprinklr.com/1652/dbcc4983-9761-4abc-b5e6-cce1b5c33f10-1723930809.xlsx) to build out a data dictionary for your Go.Data platform. You can code variables however you would like, and adapt your reference data to suit your purposes.

**NOTE:  You will need to adapt this data dictionary to fit what you have configured in your system. This would include adding in entirely new variables that you may have added for custom questionnaires for cases, contacts, follow-ups and labs or changing reference data that you have configured.**
