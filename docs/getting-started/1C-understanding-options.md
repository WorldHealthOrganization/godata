---
layout: page
parent: Getting Started with IO
title: Evaluating Options 
nav_order: 3
permalink: /evaluating-io-options/
---

# Evaluating Interoperability Options
## Go.Data Interoperability
Revew available [Data Input & Sharing Options](https://worldhealthorganization.github.io/godata/options/), including available API documentation 
to understand Go.Data's wide range of flexible and robust options for data exchange, including import/export options, API documentation, and scripts 
and sample solutions for automated data integration.

## Connecting Other Systems
When analyzing integration & interoperability options with another system, consider the following questions: 
1. Who are the other users? What information do they access, when, and for what business purpose? 
2. Where is the system hosted? And who manages it/ provides ongoing support? If it is hosted locally, is it web accessible or can it only be accessed via the local network? If it is hosted by a third party, do you have access to that third party to request changes, API access, technical documentation, etc.? 
3. Is there an available REST API and/or webhooks service? If yes, is there available documentation? Does the documentation cover the specific functionality (e.g., updating case records, viewing patient details, submitting a new form entry). 
4. If no API, what are other available ETL options for getting data in/out of the system? How is data currently entered and extracted? (E.g., “Mr. X digitizes visit forms in Excel at this computer, then uploads them using the ‘bulk data entry’ screen in our app at the end of each day. Data is extracted by lab technicians via the ‘Export to CSV’ button, and it is then formatted in Excel and printed to be read by technicians on site.”) 
5. Any known security requirements or authentication considerations? (e.g., firewalls, VPN requirements, IP whitelist requirements?)
6. Is there an available test environment to test integration with the application? (If not, is there a public demo of the application running on the same version that you’re currently running so that we can test the APIs?)
