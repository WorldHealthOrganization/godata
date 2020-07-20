## This script allows you to update the dates of the training outbreak, or any other outbreak, but one oubreak at a time

###### SET INPUT PARAMETES ################################################################################################

rl <- "https://godata-xxx.who.int/"            # <--------------------- insert instance url here, don't forget the slash at end !
username <- "godata_api@who.int"                             # <--------------------- insert your username for signing into Go.Data webapp here
password <- "xxxxxxxxxxxxxxxx"                           # <--------------------- insert your password for signing into Go.Data webapp here
outbreak_to_update <- "3b5554d7-2c19-41d0-b9af-475ad25a382b" 


###### LOAD REQUIRED LIBRARIES ###################################################################################################

library(httr)    
library(dplyr)   
library(jsonlite)  
library(magrittr) 
library(chron)
library(lubridate)


###### LOG IN ##################################################################################################################

login <- POST(paste0(url, "api/users/login"), content_type_json(), body =paste0("{\"email\":\"", username, "\",\"password\":\"", password,"\",\"token\":null,\"userid\":null}") )
warn_for_status(login)
credentials <- content(login)


###The response gives the user ID and the token to be used later
token <- credentials$id
userid <- credentials$userId


## Assigning target and source outbreak to the users we are using to send the request
url_patch<- paste0(url,"api/users/", userid, "?access_token=",token )

patch_outbreaks <- PATCH(url=url_patch, content_type_json(),
                         body = paste0("{\"outbreakIds\":[\"", outbreak_to_update, "\"]}"))

warn_for_status(patch_outbreaks)


## Setting user's active outbreak
patch_outbreak <- PATCH(url=url_patch, content_type_json(),
                        body = paste0("{\"activeOutbreakId\":\"", outbreak_to_update, "\"}"))

warn_for_status(patch_outbreak)

###### READING CASES FROM THE OUTBREAK  #################################################################################

Source_response_cases <- GET(paste0(url,"api/outbreaks/",outbreak_to_update,"/cases?access_token=",token))
cases <- content(Source_response_cases)

## Load template for dateRanges
load("templates/dateRangesTemplate.RData")

###### MODIFYING CASE DATES  #################################################################################
i=1
for (i in 2:length(cases)) {
  
  case_id <- as.character(cases[[i]]["id"])


    
  ## Update date of onset
  if( cases[[i]]["dateOfOnset"]=="NULL"){
    cases[[i]]["dateOfOnset"]<-NULL} else {
      
      current_dateOfOnset <-cases[[i]]["dateOfOnset"]
      dateRange_StartDate <- lubridate::ymd_hms(current_dateOfOnset) + days(sample.int(5, 1))
      dateRange_StartDate <- paste0(substring(as.character(dateRange_StartDate ), 1, 10), "T00:00:00.000Z")
      
      dateRange_EndDate <- lubridate::ymd_hms(dateRange_StartDate) + days(sample.int(15, 1))
      dateRange_EndDate <- paste0(substring(as.character(dateRange_EndDate ), 1, 10), "T00:00:00.000Z")
    
      cases[[i]]["dateRanges"][[1]] <- dateRanges
      cases[[i]]["dateRanges"][[1]][[1]]["startDate"] <- dateRange_StartDate
      cases[[i]]["dateRanges"][[1]][[1]]["endDate"]<- dateRange_EndDate
     
    }
  
  cases[[i]] <-  cases[[i]][c("dateRanges")]
  
  Sys.sleep(0.5)
  put <- PUT(paste0(url,"api/outbreaks/",outbreak_to_update ,"/cases/",case_id,"?access_token=",token), body=cases[[i]], encode="json")
  warn_for_status(put)
  print(paste0("Adding hospitalizations to case ", i))
  
}


getwd()
