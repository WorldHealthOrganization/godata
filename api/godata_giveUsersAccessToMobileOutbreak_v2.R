
## This scripts allows to set the avaialble and active outbreaks of users in bulk

###### GET LIST OF USER OF TRAINING PARTICIPANTS #################################################################################

url <- "https://godata-xxx.who.int/"   # <-------- insert instance url of your server here, don't forget the slash at end !

## Credentials of users with the right to manage users
username <- "godata_api@who.int"                             
password <- "xxxxxxxxxxxxxxxxxx"

## Define outbreaks to assign to participants
demo_for_mobile<- "3b5554d7-2c19-41d0-b9af-475ad25a382b"

### Participants language: please set the parameter as either ENGLISH or FRANCAIS
language <- "ENGLISH"

###### LIBRARIES ##################################################################################################################
#install.packages("httr")
library(httr)    
library(dplyr)   
library(jsonlite)  
library(magrittr) 
library(chron)
library(lubridate)
library(stringr)

###### LOG IN ##################################################################################################################

login <- POST(paste0(url, "api/users/login"), content_type_json(), body =paste0("{\"email\":\"", username, "\",\"password\":\"", password,"\",\"token\":null,\"userid\":null}") )
warn_for_status(login)
credentials <- content(login)

###The response gives the user ID and the token to be used later
token <- credentials$id
userid <- credentials$userId

###### GET LIST OF USER OF TRAINING PARTICIPANTS #################################################################################

## Get the list of Go.Data users
response_user_list <- GET(paste0(url,"api/users?access_token=",token))
user_list <- content(response_user_list)

## Filter for training participants  only
training_participants<-Filter(function(x) {str_detect(x["lastName"], language)}, user_list)


for (i in 1:length(training_participants)) {
  
  user_id <- as.character(training_participants[[i]]["id"])
  
  ## Simplify the user objects to contain only the available outbreaks (outbreakIds)
  training_participants[[i]] <-  training_participants[[i]][c("outbreakIds")] ###---->  Please add here other dates as needed
  
  ## Add mobile outbreak to the list of available outbreaks for this user
  next_element <- length(training_participants[[i]][["outbreakIds"]])+1
  training_participants[[i]][["outbreakIds"]][[next_element]] <- demo_for_mobile
  
  ## Send a PATCH request to give user access to the mobile outbreak
  url_patch<- paste0(url,"api/users/", user_id, "?access_token=",token )
  
  patch_outbreaks <- PATCH(url=url_patch, body=training_participants[[i]], encode="json")
  warn_for_status(patch_outbreaks)
  print(paste0("Participants ", training_participants[[i]]["firstName"], " has been given access to mobile outbreak" ))
  
  
  ## Send a PATCH request to make mobile outbreak active for the use
  patch_active_outbreak <- PATCH(url=url_patch, content_type_json(),
                                 body = paste0("{\"activeOutbreakId\":\"", demo_for_mobile, "\"}"))
  
  warn_for_status(patch_active_outbreak)
  print(paste0("Mobile outbreak is active for participant ", training_participants[[i]]["firstName"]))
  
  Sys.sleep(0.5)
  
}
