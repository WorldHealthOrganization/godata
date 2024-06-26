---
layout: default
title: Integrating Lab Results
parent: Frequently Asked Questions
grand_parent: How to integrate my data with other systems
nav_order: 6
permalink: /integrating-lab-results/
---
# Integrating Lab Results
Go.Data supports the capture of `Lab Results` records for enhanced tracking and follow-up for individual records. In the Go.Data data model, all `Lab Result` records must be related to an individual beneficiary record (`Cases`, `Contacts`).  

See the [reference implementation #3](https://worldhealthorganization.github.io/godata/importing-lab-results/) for a more detailed walk-through of how to convert lab results `sample` data to fit the Go.Data data model. 

## Matching Results to Individuals
Before external lab system data can be imported, related `Case` records must be created in Go.Data to capture individual persons' details. 
Only _after_ these resources have been created, can `Lab Results` data be uploaded to the Go.Data system. 

Lab results can be matched to `Case` records either via an externalId that is also captured in the Go.Data system (e.g., `CASE-10001`) or via the Go.Data-generated global unique Id (`id` - e.g., `0ed35c12-e1ff-40a3-9ce7-188562abefc7`) that is auto-assigned to every new resource. 

## Importing Results
Results can be imported using standard Go.Data Excel import features and/or via the REST API `/lab-result` endpoints (e.g., `POST /outbreaks/{id}/cases/{nk}/lab-results`). If importing via the API, the Go.Data-generated global unique identifier `id` will be required (you cannot only using the Mask ID such as `CASE-10001`). 

## Resources
1. See the related [reference implementation #3](https://worldhealthorganization.github.io/godata/importing-lab-results/) for specific step-by-step guidance with a real-world example. 
2. See the [Go.Data Community](https://community-godata.who.int/topics/interoperability/5fd8ec64f5c77e114e6c6823) for import templates converting lab results to Case/Contact and Lab Results records. These include: 
- [Case Import Template](https://sprcdn-assets.sprinklr.com/1652/81f8ca3b-85dd-4227-ba38-07a3fd7602dc-1433384782.xlsx)
- [Contact Import Template](https://sprcdn-assets.sprinklr.com/1652/c6e81e6d-a1d7-497e-befe-b4c901771a22-1696387742.xlsx)
- [Lab Results Import Template](https://sprcdn-assets.sprinklr.com/1652/3b12476b-0d12-4d85-a3f9-c748a69c7856-960273073.xlsx)

3. See the [Unique Identifiers](https://worldhealthorganization.github.io/godata/unique-identifiers/) section for more on assigning unique Ids to individual `Case` and `Contact` records. 
