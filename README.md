# Welcome to the Go.Data repository!

This is the public WHO Go.Data repo for sharing scripts and documentation related to the Go.Data projects. Currently under construction but adding new things each day. Feedback and contributions welcome!

_Questions or feedback - please contact us at godata@who.int_

_Visit our Community oF Practice website to swap learnings or post queries here: https://community-godata.who.int/_

## API

This folder contains example R scripts for GET/PUT/POST commands so that you can manipulate your Go.Data instance through the API, including bulk actions. We have used this for our training instances but think it could be helpful for others too.

## Sample Report Scripts

This folder contains example scripts for extracting, cleaning, and running some basic analysis. Output at present includes flattened cleaned .csvs for case/contact linelists and an HTML dashboard displaying operational performance metrics for contact tracing by contact tracing supervisor and teams. Feel free to adapt to your purposes.

## DHIS2 to Go.Data

This folder contains the beginnings of interoperability work between DHIS2 COVID packages and Go.Data for countries that have requested to push their case and contact data to Go.Data from their DHIS2 instance, and vice versa, to benefit from core competencies of each tool. More details below:

### Org unit converter: 
Devleoped by EyeSeeTea LS (http://eyeseetea.com/), this is a Python script to take the national org tree from a DHIS2 instance, transform its .json structure and input it into Go.Data 

### API wrapper:
Developed by WISCENTD-UPC (https://github.com/WISCENTD-UPC/) - this package provides certain common things you may need in order to use Go.Data's API, so that it is easier and faster. This utility library "wraps" the functionality of the API under a common tiny library that already handles functions such as login authorization that would otherwise have to be done for each query separtely.

_see full package here: https://github.com/WISCENTD-UPC/godata-api-wrapper/tree/develop_

### Interoperability scripts:
Developed by WISCENTD-UPC (https://github.com/WISCENTD-UPC/) - these scripts push DHIS2 Tracked Entities for cases and contacts into Go.Data cases and contacts, in addition to automatically inserting them in a new or existing outbreak in Go.Data with the appropriate parameters. 

_see full package here: https://github.com/WISCENTD-UPC/dhis2-godata-interoperability/tree/develop_

_see more project-related updates here: https://www.essi.upc.edu/dtim/projects/COVID-19_

