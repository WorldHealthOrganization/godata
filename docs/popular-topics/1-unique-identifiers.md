---
layout: default
title: Unique Identifier Schemes
parent: Popular Topics
nav_order: 1
permalink: /unique-identifiers/
---
# Go.Data Unique Identifiers & Integration Considerations
## 1. Unique identifier schemes
When interoperating with other systems, determining unique identifiers for every shared resource is critical to developing shared records, preventing duplicates, and preserving data integrity. 

### Go.Data GUIDs
All records created in Go.Data are assigned a system-generated internal Globally Unique Identifier (`GUID`). 
GUIDs (e.g., `8c71e61f-fb11-4d4f-9130-b69384b6e4e4`) are used as primary
keys for records in the MongoDB, and are **required to request and update Go.Data records** via the API.


`GET  http://localhost:8000/api/outbreaks/8c71e61f-fb11-4d4f-9130-b69384b6e4e4`

### Case & Contact IDs
Case ID mask: Enter a human-readable identification pattern that Go.Data will use to
create a globally unique identifier to track each case. Subject to the structure of the ID,
Go.Data automatically assigns an identification
1. Custom `*` IDs
2. Autonumber IDs `CASE-00001`

### 'Document' variable
On Case and Contact there is a standard `Document` variable available for users to specify other Document identification (e.g., national ID, passport). 

### Questionnaire custom variables
Questionnaires are essential for collecting and recording data for cases, contacts, and lab results
during an outbreak. A pre-established questionnaire format for an outbreak ensures that data
collected is consistent across the outbreak, so you can more easily perform analysis on the
information...

### Go.Data Location IDs
When Go.Data records, geocodes, other IDs...

### Determining your own custom unique identifier scheme
If a unique identifier scheme is not already available, consider the following approaches to developing your own custom identifier scheme...
1. autonumbers
2. national Ids
3. concatenating attributes
4. ...

## 'Upsert' Operations
“Upsert” operations are a data import pattern where you first check if a record exists using an external identifier, and then 
either update or insert a new record dependng on whether an existing record is found.

## Go.Data Duplicate Management Features
For scenarios where the unique identfier scheme fails, Go.Data offers some out-of-box feature for duplicate-checking across different 
record attributes (e.g., `name`, `dateOfBirth`). See the [User Guide](...) to learn more. 

