
## This script allows you to update the dates of the training outbreak, or any other outbreak, but one oubreak at a time

###### SET INPUT PARAMETERS ################################################################################################
url <- "https://godata-xxx.who.int/"            # <--------------------- insert instance url here, don't forget the slash at end !
username <- "godata_api@who.int"                             # <--------------------- insert your username for signing into Go.Data webapp here
password <- "xxxxxxxxxxxxxxx"                           # <--------------------- insert your password for signing into Go.Data webapp here
outbreak_to_update <- "3b5554d7-2c19-41d0-b9af-475ad25a382b" 
days_ahead <- 14                            # <--------------------- how many days you want to move ahead by

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

###### MODIFYING CASE DATES  #################################################################################

for (i in 1:length(cases)) {
 
  case_id <- as.character(cases[[i]]["id"])
  
 cases[[i]] <-  cases[[i]][c("dateOfOnset", "dateOfReporting", "dateRanges")] ###---->  Please add here other dates as needed
  
 ## Update date of onset
 if( cases[[i]]["dateOfOnset"]=="NULL"){
   cases[[i]]["dateOfOnset"]<-NULL} else {
     
     
     current_dateOfOnset <-cases[[i]]["dateOfOnset"]
     new_dateOfOnset <- lubridate::ymd_hms(current_dateOfOnset) + days(days_ahead)
     new_dateOfOnset <- paste0(substring(as.character(new_dateOfOnset ), 1, 10), "T00:00:00.000Z")
     
     cases[[i]]["dateOfOnset"] <- new_dateOfOnset
     
   }
 

 ## Update  date of reporting
 if( cases[[i]]["dateOfReporting"]=="NULL"){
   cases[[i]]["dateOfReporting"]<-NULL} else {
     
     current_dateOfReporting <-cases[[i]]["dateOfReporting"]
     new_dateOfReporting <- lubridate::ymd_hms(current_dateOfReporting) + days(days_ahead)
     new_dateOfReporting <- paste0(substring(as.character(new_dateOfReporting), 1, 10), "T00:00:00.000Z")
     
     cases[[i]]["dateOfReporting"] <- new_dateOfReporting
     
   }
 
 if( cases[[i]]["dateRanges"]=="NULL"){
   cases[[i]]["dateRanges"]<-NULL} else {
     
     cases[[i]]["dateRanges"][[1]][[1]]["centerName"] <- NULL
     cases[[i]]["dateRanges"][[1]][[1]]["locationId"] <- NULL
     cases[[i]]["dateRanges"][[1]][[1]]["comments"] <- NULL
     
     current_dateRanges_startDate <-cases[[i]]["dateRanges"][[1]][[1]]["startDate"]
     new_dateRanges_startDate <- lubridate::ymd_hms(current_dateRanges_startDate) + days(days_ahead)
     new_dateRanges_startDate <- paste0(substring(as.character(new_dateRanges_startDate), 1, 10), "T00:00:00.000Z")
     
     cases[[i]]["dateRanges"][[1]][[1]]["startDate"] <- new_dateRanges_startDate
     
     current_dateRanges_endDate <-cases[[i]]["dateRanges"][[1]][[1]]["endDate"]
     new_dateRanges_endDate <- lubridate::ymd_hms(current_dateRanges_endDate) + days(days_ahead)
     new_dateRanges_endDate <- paste0(substring(as.character(new_dateRanges_endDate), 1, 10), "T00:00:00.000Z")
     
     cases[[i]]["dateRanges"][[1]][[1]]["endDate"] <- new_dateRanges_endDate
     
     
   }
  
  Sys.sleep(0.5)
  PUT(paste0(url,"api/outbreaks/",outbreak_to_update ,"/cases/",case_id,"?access_token=",token), body=cases[[i]], encode="json")
  print(paste0("Updating dates for case ", i))
    
}

  


###### READING CASE RELATIONSHIPS FROM THE OUTBREAK  #################################################################################
Source_response_cases <- GET(paste0(url,"api/outbreaks/",outbreak_to_update,"/cases?access_token=",token))
cases <- content(Source_response_cases)


###### MODIFYING CASE RELATIONSHIPS DATES  #################################################################################

for (i in 1:length(cases)) {
  
  case_id <- as.character(cases[[i]]["id"])

  
  response_case_relationships <- GET(paste0(url,"api/outbreaks/",outbreak_to_update,"/cases/",case_id,"/relationships?access_token=",token))
  case_relationships <- content(response_case_relationships)
  j=5
  if(length(case_relationships)>0){
  ### Remove ID, createdAt, createdBy, updatedAt, updatedBy

  ## Change oubreak
  for (j in 1:length(case_relationships)) {
    
    print(paste0("Updating case relationship: ", j))
    
    case_relationship_id <- case_relationships[[j]]["id"]
    case_relationships[[j]] <-  case_relationships[[j]][c( "contactDate" )] #
    
    

    ## Move date of contact
    current_contactDate <-case_relationships[[j]]["contactDate"]
    new_contactDate<- ymd_hms(current_contactDate) + days(days_ahead)
    new_contactDate <- paste0(substring(as.character(new_contactDate), 1, 10), "T00:00:00.000Z")
    
    case_relationships[[j]]["contactDate"] <- new_contactDate
    
    print(paste0("Posting relationship ", j, " for case ", i))
    Sys.sleep(0.5)
    
    PUT(paste0(url,"api/outbreaks/",outbreak_to_update ,"/cases/",case_id,"/relationships/", case_relationship_id, "/?access_token=",token), body=case_relationships[[j]], encode="json")
    
  }
    } else {
    print(paste0("Case ",i, " didn't have relationships"))
  }
  
  

}


###### READING CONTACTS AND FOLLOW UPS FROM THE OUTBREAK  #################################################################################

Source_response_contacts <- GET(paste0(url,"api/outbreaks/",outbreak_to_update,"/contacts?access_token=",token))
contacts <- content(Source_response_contacts)

###### MODIFYING CONTACT DATES AND FOLLOW UP DATES #################################################################################

for (i in 1:length(contacts)) {
  
  contact_id <- as.character(contacts[[i]]["id"])
  
  contacts[[i]] <-  contacts[[i]][c( "dateOfReporting" )] ###---->  Please add here other dates as needed
  
  
  ## Update date of reporting
  if( contacts[[i]]["dateOfReporting"]=="NULL"){
    contacts[[i]]["dateOfReporting"]<-NULL} else {
      current_dateOfReporting <-contacts[[i]]["dateOfReporting"]
      new_dateOfReporting <- ymd_hms(current_dateOfReporting) + days(days_ahead)
      new_dateOfReporting <- paste0(substring(as.character(new_dateOfReporting), 1, 10), "T00:00:00.000Z")
      
      contacts[[i]]["dateOfReporting"] <- new_dateOfReporting
      
    }

  ## NOTE: ["followUp"]]["startDate"] and ["followUp"]]["endDate"] are automatically updated with the relationship dates are updated.
  
## Read contact follow up
  Source_response_follow_ups <- GET(paste0(url,"api/outbreaks/",outbreak_to_update,"/contacts/", contact_id, "/follow-ups?access_token=",token))
  follow_ups <- content(Source_response_follow_ups)
  
  ## Update contact follow ups:one by one
  for (j in 1:length(follow_ups)) {
    
    follow_up_id <- as.character(follow_ups[[j]]["id"])
    
    follow_ups[[j]] <-  follow_ups[[j]][c("date")] ###---->  Please add here other dates as needed
    
    ## Update date of onset
    if( follow_ups[[j]]["date"]=="NULL"){
      follow_ups[[j]]["date"]<-NULL} else {
        
        
        current_date <-follow_ups[[j]]["date"]
        new_date <- lubridate::ymd_hms(current_date) + days(days_ahead)
        new_date <- paste0(substring(as.character(new_date ), 1, 10), "T00:00:00.000Z")
        
        follow_ups[[j]]["date"] <- new_date
        
      }
   
    
    print(paste0("Updating follow up ", j, " of conact ", i))
    Sys.sleep(0.5)
    put <-PUT(paste0(url,"api/outbreaks/",outbreak_to_update ,"/contacts/",contact_id,"/follow-ups/", follow_up_id, "?access_token=",token), body=follow_ups[[j]], encode="json")
    
    warn_for_status(put)
  }
  
  

  print(paste0("Update date of reporting of contact ", i))
  Sys.sleep(0.5)
  PUT(paste0(url,"api/outbreaks/",outbreak_to_update ,"/contacts/",contact_id,"?access_token=",token), body=contacts[[i]], encode="json")
  
  
}

###### READING EVENTS FROM THE OUTBREAK  #################################################################################

source_response_events <- GET(paste0(url,"api/outbreaks/",outbreak_to_update,"/events?access_token=",token))
events <- content(source_response_events)

###### MODIFYING EVENT DATES  #################################################################################


for (i in 1:length(events)) {
  
  event_id <- as.character(events[[i]]["id"])
  events[[i]] <-  events[[i]][c( "dateOfReporting", "date" )]
  
  ## Update date of reporting
  if( events[[i]]["dateOfReporting"]=="NULL"){
    events[[i]]["dateOfReporting"]<-NULL } else {
  current_dateOfReporting <-events[[i]]["dateOfReporting"]
  new_dateOfReporting <- ymd_hms(current_dateOfReporting) + days(days_ahead)
  new_dateOfReporting <- paste0(substring(as.character(new_dateOfReporting), 1, 10), "T00:00:00.000Z")
  
  events[[i]]["dateOfReporting"] <- new_dateOfReporting
  
    }
  
  ## Update event date
  if( events[[i]]["date"]=="NULL"){
    events[[i]]["date"]<-NULL } else {
      current_dateOfReporting <-events[[i]]["date"]
      new_dateOfReporting <- ymd_hms(current_dateOfReporting) + days(days_ahead)
      new_dateOfReporting <- paste0(substring(as.character(new_dateOfReporting), 1, 10), "T00:00:00.000Z")
      
      events[[i]]["date"] <- new_dateOfReporting
      
    }
  
  print(paste0("Updating date of event: ", i))
  Sys.sleep(0.5)
  put <- PUT(paste0(url,"api/outbreaks/",outbreak_to_update ,"/events/",event_id,"?access_token=",token), body=events[[i]], encode="json")
  content(put)

}

###### READING LAB RESULTS #################################################################################
Source_response_lab_results <- GET(paste0(url,"api/outbreaks/",outbreak_to_update,"/lab-results?access_token=",token))
lab_results <- content(Source_response_lab_results)


###### MODIFYING LAB RESULTS  #################################################################################
for (i in 1:length(lab_results)) {
  
  lab_results_id <- as.character(lab_results[[i]]["id"])
  
  lab_results[[i]] <-  lab_results[[i]][c("dateSampleTaken")] ###---->  Please add here other dates as needed
  
  ## Update date of onset
  if( lab_results[[i]]["dateSampleTaken"]=="NULL"){
    lab_results[[i]]["dateSampleTaken"]<-NULL} else {
      
      
      current_dateSampleTaken <-lab_results[[i]]["dateSampleTaken"]
      new_dateSampleTaken <- lubridate::ymd_hms(current_dateSampleTaken) + days(days_ahead)
      new_dateSampleTaken <- paste0(substring(as.character(new_dateSampleTaken ), 1, 10), "T00:00:00.000Z")
      
      lab_results[[i]]["dateSampleTaken"] <- new_dateSampleTaken
      
    }
  
  
  Sys.sleep(0.5)
  PUT(paste0(url,"api/outbreaks/",outbreak_to_update ,"/lab-results/",lab_results_id,"?access_token=",token), body=lab_results[[i]], encode="json")
  print(paste0("Updating lab result ", i))
  
}




