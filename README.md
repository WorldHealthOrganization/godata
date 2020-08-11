# Welcome to the Go.Data repository!

This is the public WHO Go.Data repo for sharing scripts and documentation related to the Go.Data projects. Currently under construction but adding new things each day.

## api

This folder contains in it many example R scripts for GET/PUT/POST commands so that you can manipulate your Go.Data instance through the API, including bulk actions. We have used this for our training instances but think it could be helpful for others too.

## sample_report_scripts

This folder contains in it some example scripts for extracting, cleaning, and running some basic analysis. Output at present includes flattened cleaned .csvs for case/contact linelists and an HTML dashboard displaying operational performance metrics for contact tracing by contact tracing supervisor and teams. Feel free to adapt to your purposes.

## dhis2godata

This folder contains the beginnings of interoperability work between DHIS2 COVID packages and Go.Data for countries that have requested to push their case and contact data to Go.Data from their DHIS2 instance. So far we have a Python script to take the national org tree from DHIS2 and input it into Go.Data as well as an API wrapper to push basic case information from DHIS2 Tracked Entities to Go.Data.

any questions please don't hesitate to email godata@who.int

Thanks for your patience as we built this out but very much looking forward contributions, feedbacks, ideas!
