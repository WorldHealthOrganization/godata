---
layout: default
title: Aggregating Records for Reporting
parent: Frequently Asked Questions
grand_parent: How to integrate my data with other systems
nav_order: 2
permalink: /aggregate-reporting/
---
# Aggregate Reporting
Go.Data implementers commonly have to report on aggregate results across key indicators to report to external systems and partners. Consider the following when determining your
approach to aggregate reporting on Go.Data information. 

## 1. Map your reporting rules.
When planning to report aggregate results to an external system, build a map of reporting "rules" and calculations that will be required to summarize Go.Data information to generate aggregate reporting results. 

## 2. Consider your data extraction options. 
1. Extract individual results and then Transform & Load (E&TL strategy) - Extract individual records from Go.Data and then perform any aggregation & transformation in an outside staging environment or via an integration layer/automation step before uploading to the external reporting system. 
2. Extract aggregate results and then load (ET&L strategy) - Go.Data already provides some APIs for extraction of pre-aggregated results, and more are in development. 
3. Consider your reporting frequency & how to save date/time “cursor” (how you will mark the time period for which you last extracted data) to minimize redundancy and sharing of only new or updated records. 

## 3. Consider standards.
1. Consider aggregate data standards like ADX to streamline results generation for easy and widespread reporting across ADX-friendly destination systems. 
2. Reviewing standard indicator definitions may also be critical to the design of your reporting "map" (see `2.1`). 


## Learn More
- See the [Integrating with DHIS2](https://worldhealthorganization.github.io/godata/dhis2-integration/) section and [Reference Implementation #6](https://worldhealthorganization.github.io/godata/godata--dhis2-aggregate/) for aggregate
reporting examples specific to DHIS2.  

