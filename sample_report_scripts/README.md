# Go.Data R analysis scripts

![Go.Data Sample Dashboard](https://github.com/WorldHealthOrganization/godata/blob/master/assets/report_screenshot.png)

This is a sample folder hierarchy for running some Go.Data data retrieval, cleaning, analysis scripts. 

If you copy/paste this folder hierarchy into your C drive and double click the .Rproj, you can run the scripts in R and they will reference proper scripts in proper places. The rationale behind this folder hierarchy and set-up was borrowed from RECON's _reportfactory_ templates repository: https://github.com/reconhub/report_factories_templates

## report_sources

This includes scripts for 
1. importing data into R from your Go.Data API 
2. cleaning these dataframes and exporting to .csv files into clean data folder
3. running basic analysis for these data collections and outputting into .HTML dashboard using flexdashboard package (see screenshot above for an example)

## report_outputs

This is where report outputs are stored.

## scripts

This is where other scripts and functions are stored; you do not need to open them up or run them separately, the scripts reference them where needed.

## data

This is where your data exports will be stored, in the "clean" folder. You can store other raw exports from Go.Data web interface in the "raw" folder.

