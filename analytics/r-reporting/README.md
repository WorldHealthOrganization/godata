# Automated R Reporting Using Go.Data API

![](https://github.com/WorldHealthOrganization/godata/blob/master/docs/assets/R_reporting_workflow.PNG)

Below we will outline some instructions for obtaining your data directly from your Go.Data instance application programming interface (API) using R, for further data cleaning and analysis. This process will provide you with cleaned, flattened excel files and sample dashboard output that you can adapt for your purposes. Although there are multiple ways to retrieve the data collections including installing and connecting directly to the MongoDB database on your machine, this SOP outlines how to do this simply using the open-source software R – where advanced R skills are not required. 

## Step 0. Before beginning:
- Download R (version 3.6.1 or higher is recommended) here: https://www.r-project.org/
- Obtain valid Go.Data login credentials for the instance you are accessing, with the minimum permissions to _view_ data collections you are trying to extract (i.e if you want to extract laboratory data, you need the "Laboratory Personnel" role)
- Create folder directory on your local machine matching what is outlined in this Github repository, with recent contents of this Github repository, in an easily accessible place on your computer (i.e. Desktop)

## Step 1. Replicate folder directory to your local machine
In order for the scripts to work it is essential for you to have the same folder hierarchy and contents. Your folder directory should include:
- data (_a place for csv and rds file outputs to be stored_)
- scripts (_containing starter scripts and parameters, like necessary packages to be loaded or formatting, that are sourced in the report sources scripts_).
- report_sources (_contains script to import; script to clean; script to product dashboard_)
- reprt_outputs (_a place for dashboard outputs to be stored_)
- R project (_double click here to open R; so that each time your working directory is properly set_)

![](https://github.com/WorldHealthOrganization/godata/blob/master/docs/assets/R_folder_hierarchy.PNG)

Please be sure that you check your folder contents are up to date with what is living on Github. If you are able to connect dynmaically to Github in R via Git to pull most recent version, this is preferred. If you don't feel comfrotable with this, you can simply copy/paste the script contents into your local folder hierarchy. The rationale behind this folder hierarchy and set-up was borrowed from RECON's _reportfactory_ templates repository (https://github.com/reconhub/report_factories_templates) and has been simplified for our purposes.

## Step 2. Run data import script with your Go.Data credentials 
Running this script will import data into R environment from your Go.Data API.

Open up R project by double-clicking on godata.Rroj. 

Navigate to 01_data_import_api.R in the *report_sources* folder and click to open it in your R console. 

![](https://github.com/WorldHealthOrganization/godata/blob/master/docs/assets/R_report_sources.PNG)
![](https://github.com/WorldHealthOrganization/godata/blob/master/docs/assets/R_data_import_api.PNG)

At the top of the script, fill in the appropriate URL, your Go.Data username and password, and outbreak_id of interest. 

![](https://github.com/WorldHealthOrganization/godata/blob/master/docs/assets/R_script_credentials.PNG)

TIP: In order to obtain your outbreak ID, navigate to View Outbreak in Go.Data and you can find it in the URL. You can only extract data from one outbreak at a time. Before running, ensure this is your active outbreak in the platform. 

![](https://github.com/WorldHealthOrganization/godata/blob/master/docs/assets/R_outbreak_id.PNG)

Run the script by clicking "Source".
NOTE: you will receive an error if you do not have proper contents in the *scripts* (necessary for downloading pre-requisite packages & setting core fields).

Once the script has succesfully completed, you should have created several data frames in your R global environment that will be used in subsequent cleaning scripts.

![](https://github.com/WorldHealthOrganization/godata/blob/master/docs/assets/R_collections.PNG)

NOTE: please switch your language to English in your Go.Data instance before running this API script, to ensure core data elements are all brought back in a consistent form.

## Step 3. Run cleaning scripts and export to excel 
The dataframes as retrieved straight from API can contain some nested arrays in lists; for fields that can have multiple responses for one case or contact (i.e. more than one address can be registered if person has moved; repeat hospitalizations can be recorded; followUp history is stored). The cleaning script helps to properly un-nest relevant fields and do some basic data manipulation to these data frames before exporting to .CSV (or prepping for additional analysis in R).

Navigate to *02_clean_data_api.R*, (also in *report_sources folder*), click to open, and run script.

![](https://github.com/WorldHealthOrganization/godata/blob/master/docs/assets/R_clean_data_api.PNG)

This will result in the following cleaned .csv files saved in the data foler, with format matching the pattern below, updated each time you run the script to contain the most recent data.
- contacts_clean.csv
- cases_clean.csv
- etc 

You will also have .rds files in the data folder (i.e. contacts_clean.rds; cases_clean.rds) This condensed format will be used for subsequent R dashboards scripts since it is more performant and perserves language characters better.

NOTE: these cleaning scripts focus on the CORE data variables and not custom questionnaire variables, as questionnaires are configurable for each country or institution deploying Go.Data. No core data elements (those living outside of questionnaires) should need updating in terms of coding; however, if you would like to pull in additional questionnaire data elements you may need to slightly modify this script to accommodate these extra fields. Additionally, it is possible that your location hierarchy or team structure may vary in your deployment setting (I.e. supervisor registered at a different admin level) so changes may need to be made to the location cleaning scripts. Please see the section _Further tips on data extraction/cleaning from API_ at the bottom fo this SOP for more details.

## Step 4. Utilize cleaned datasets for additional analysis inside or outside of R
The cleaned datasets will now be much easier to do additional analysis whether inside or outside of R. 

We have created some sample scripts to get you started in some basic dashboard analyses (see, for example, 03_daily_summary_dashboard.Rmd for a ready-made HTML dashboard that will give you stats on a range of operational metrics to be monitored by supervisor and contact tracer on a daily basis). 

Screenshots below show some of these graphics, such as contact follow-up status by a given admin level. These will be printed to the *report_outputs* folder.

![](https://github.com/WorldHealthOrganization/godata/blob/master/docs/assets/report_screenshot.png)


### Tips on extracting additional questionnaire variables
- the script 02_clean_data_api.R only includes "core variables" (i.e. excluding questionnaire variables) since we wanted these scripts to work without bugs across any variation of Go.Data deployment (as each project may have a different customizable questionnaire). This is why you will see that all fields from API starting with `questionnaireAnswers` are taken out of data frames, for this template starter cleaning script; since we only are un-nesting and cleaning the list fields (like `addresses` or `dateRanges`) that every Go.Data project will have, in separate data frames, and then joining them to the cleaned case data frame.

```
cases_clean <- cases %>%
  filter(deleted == FALSE | is.na(deleted)) %>%      # Remove all deleted cases
  select_if(negate(is.list)) %>%                     # Take out all list fields since unnesting causes duplicate rows if >1 response per case/contact                    
  select(-contains("questionnaireAnswers"))          # Take out all that are not core variables (questionnaire) for same reason above and need to un-nest
  
 ```
 
However we know projects will still want to extract their questionnaire data and that is easy!
To do so, you will have to either specify exactly which variable, and unnest it...as shown below...
*NOTE* Better to do this as a separate dataframe, and then join to core case variables to avoid cases being duplicated or dropped from clean case linelist, as shown below. When questionnaires are not filled for a given case, the do not have the var in their JSON and thus will not apper in the questionnaire dataframe.

```
### EXAMPLE - retrieving and unnesting Go.Data Questionnaire variables

coltoretrieve = colnames(cases)[grep('questionnaire', colnames(cases))] #get columns from the questionnaire
questionnaire.list = cases[coltoretrieve]

cases_questionnaire_unnest <- cases %>%
  select(id,                                   #get uuid for later join !
        all_of(coltoretrieve)) %>%             #questionnaire columns
  mutate_if(is.list, simplify_all) %>%
  unnest(colnames(questionnaire.list), 
         names_sep = ".")                      # for cases that had no questionnaire filled, they will not appear after un-nesting
                                               # thus why we now have the uuid for joining the q fields you need, per case, ensuring no duplication
         
cases_clean <- cases %>%
  filter(deleted == FALSE | is.na(deleted)) %>%   
  select_if(negate(is.list)) %>%                   # Remove all listed/nested fields from overall cases dataframe
  select(-contains("questionnaireAnswers")) %>%    # Remove all Questionnaire vars from overall cases dataframe
  left_join(cases_questionnaire_unnest, by="id") %>%   # Join back in flattened de-duped questionnaire fields above, using case id
  rename_at(vars(starts_with("questionnaireAnswers")),         # Rename so it is easier to read
            funs(str_replace(., "questionnaireAnswers", "Q")))
```


