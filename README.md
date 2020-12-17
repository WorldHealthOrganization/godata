![Go.Data Logo](https://github.com/WorldHealthOrganization/godata/blob/master/assets/godata_logo.png)

# Welcome to the Go.Data GitHub Repository!

This is the project repo for sharing technical documentation and resources developed and used in the context of Go.Data deployments worldwide. Go.Data is a software for contact tracing and outbreak response developed by WHO in collaboration with partners in the Global Outbreak Alert and Response Network (GOARN). Go.Data focuses on case and contact data including laboratory data, hospitalizaton and other variables collected through investigation forms. It generates contact follow-up lists and viusalisation of chains of tranmission.

It is currently in use in over 60 countries / terrirorites, in different institutions and at different national levels.

_Questions or feedback - please contact us at godata@who.int_ or visit 

_Visit our Community of Practice website to swap learnings or post queries here: https://community-godata.who.int/_

_R user? Join our slack channel here:https://godata-workspace.slack.com/archives/C01GS9B2RTK_

## Sample Report Scripts

This folder contains example scripts for extracting, cleaning, and running some basic analysis. Output at present includes flattened cleaned .csvs for case/contact linelists and an HTML dashboard displaying operational performance metrics for contact tracing by contact tracing supervisor and teams. Feel free to adapt to your purposes and share back any good stuff you've created!

## API

This folder contains in it many example R scripts for GET/PUT/POST commands so that you can manipulate your Go.Data instance through the API, including bulk actions. We have used this for our training instances but think it could be helpful for others too.

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

### Lime Survey to Go.Data:
A project developed internally by WHO IMT to link Daat Form (Lime Survey) to Go.Data API to API for teh exchange of COVID-19 tracking data for WHO staff.  This then is a very specific solution internal to WHO's need but illustrated using the Lime Survey and Go.Data interfaces using .Net 4.7.2 - C# code.

_see more project-related updates here: PENDING

