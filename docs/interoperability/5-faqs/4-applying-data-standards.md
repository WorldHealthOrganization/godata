---
layout: default
title: Applying Data Standards
parent: Frequently Asked Questions
grand_parent: How to integrate my data with other systems
nav_order: 4
permalink: /applying-data-standards/
---
# Applying Data Standards
The inclusion of international eHealth standards strengthens interoperability and data sharing options for health information system implementations. Typically the metadata of different systems does not match exactly. Unless an organization has been enforcing a consequent data standard policy, different systems will have different codes and labels for tracking beneficiary details, for example. Standard definitions for key beneficiary data points (e.g., `name`, `gender`, `birthDate`, `phone`, etc.) can help systems more quickly understand and exchange information. 

Some standards are on the technical level (e.g. transmission methods), others on the contents side (e.g., [WHO standard indicators](http://who.int/data/gho/indicator-metadata-registry)). Aligning Go.Data implementations to these data standards can incentivize data sharing and provide access to existing health systems.

- Popular data exchange standard profiles include FHIR, ADX, CSD, and mCSD. Read more here on the [OpenHIE wiki](https://wiki.ohie.org/display/documents/OpenHIE+Standards+and+Profiles).
- [Fast Healthcare Interoperability Resources (FHIR)](https://www.hl7.org/fhir/overview.html) is the most common standard for exchanging healthcare data and provides a [FHIR Implementation Guide](https://www.hl7.org/fhir/implementationguide.html) that includes standard definitions, naming conventions, and best practices for Go.Data implementers. When configuring your Go.Data instance, consider if possible to incorporate such standards in your variable names & metadata configuration. 
- Check out [reference implementation #2](https://worldhealthorganization.github.io/godata/1-2-godata--hmissurveillance-system/) for an example of how Go.Data data values might be transformed to adhere to the FHIR protocol for `Patient` resources before exchange with an external HMIS. 

## How to Apply Standards
There are many steps (both technical- and business-related) required before a system is fully compliant with international standard definitions and data exchange protocols–these will differ by standard. 
 
### Mapping Data Elements
A crucial (and typically the first) step is how organize the mapping of data elements between different systems. Implementers can start to prepare for standards implementation by first building a **Data Element Dictionary & Map** to document existing metadata and how data should be shared with partner systems. As an example, see the [Mapping Specification](https://docs.google.com/spreadsheets/d/1SNx5wB818ikveaVhHqW9c4N05leL1WGZulsdC_BJj70/edit#gid=1444757722) from reference implementation #2. 

Also, implementers can consider at what step in the data cycle does it make the most sense to apply standards (i.e., before loading data into Go.Data, after exporting for reporting to external systems). If standards are not applied within the Go.Data instance itself, perhaps their application is only important before sharing with external systems and can therefore be applied during the data exchange workflow. 

![applying-standards](../assets/applying-standards.png)

#### Mapping information & meaning
Consider...
1. Which data elements are important to share? 
2. How to map your data elements to external systems & standard definitions? 
3. What are the transformation rules that need to be applied? 
4. Are there any privacy and security concerns when sharing specific data elements or aspects of those elements? 

### Technical Requirements
Consider the technical requirements for exchange patterns, message protocols, & data storage.  Depending on your standard, where you expect to implement the transformation step, and the requirements of the connected systems - your implementation plan may vary. Mapping out the systems and data flows will help you to build this blueprint and consider whatever steps or tools are needed to satisfy requirements. 

# Learn More
Seek more information specific to the standard you are interested in applying. The [OpenHIE Community](https://wiki.ohie.org/display/documents/OpenHIE+Standards+and+Profiles) is an active and trusted resource when it homes to healthcare information exchange and standards. 
