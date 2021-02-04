# Go.Data R analysis scripts

![Go.Data Sample Dashboard](https://github.com/WorldHealthOrganization/godata/blob/master/assets/report_screenshot.png)

This is a sample folder hierarchy for running some Go.Data data retrieval, cleaning, analysis scripts. 

If you copy/paste this folder hierarchy into your C drive and double click the .Rproj, you can run the scripts in R and they will reference proper scripts in proper places. The rationale behind this folder hierarchy and set-up was borrowed from RECON's _reportfactory_ templates repository: https://github.com/reconhub/report_factories_templates

## report_sources

This includes scripts for 
1. importing data into R from your Go.Data API 
2. cleaning these dataframes and exporting to .csv files into clean data folder
3. running basic analysis for these data collections and outputting into .HTML dashboard using flexdashboard package (see screenshot above for an example)

### tips on data extraction from API
- the script 02_clean_data_api.R only includes "core variables" (i.e. excluding questionnaire variables) since we wanted this to be able to be run without bugs across any Go.Data deployment and each project may have a different customizable questionnaire. This is why you will see that all fields from API starting with `questionnaireAnswers` are taken out of data frames, for this template starter cleaning script; since we only are un-nesting and cleaning the list fields (like `addresses` or `dateRanges`) that every Go.Data project will have, in separate data frames, and then joining them to the cleaned case data frame.

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


## report_outputs

This is where report outputs are stored.

## scripts

This is where other scripts and functions are stored; you do not need to open them up or run them separately, the scripts reference them where needed.

## data

This is where your data exports will be stored, in the "clean" folder. You can store other raw exports from Go.Data web interface in the "raw" folder.

