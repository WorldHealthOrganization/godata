
## This scripts allows to set the users roles in bulk

###### SETINPUT PARAMETES ################################################################################################
url <- "https://godata-xxx.who.int/"   # <-------- insert instance url of your server here, don't forget the slash at end !

## Credentials of users with the right to manage users
username <- "godata_api@who.int"                             
password <- "xxxxxxxxxxxxxxx"
firstName <-"PARTICIPANT" 
###### LOAD REQUIRED LIBRARIES ###################################################################################################

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
response_user_list <- GET(paste0(url,"api/users?access_token=",token))
user_list <- content(response_user_list)

## Filter for participants only
training_participants<-Filter(function(x) {str_detect(x["firstName"], firstName)}, user_list)

###### GENERATE THE LIST OF ROLES TO BE GIVEN TO PARTICIPANTS ######################################################################
## OPTION 1: Create a list from scratch -----> Note the role codes are: ROLE_CONTACT_TRACING_COORDINATOR' ROLE_DATA_MANAGER' ROLE_REPORTS_AND_DATA_VIEWER' ROLE_DEFAULT_MINIMUM_BACKUP_ACCESS' ROLE_EPIDEMIOLOGIST' ROLE_HELP_CONTENT_MANAGER' ROLE_LAB_RESULTS_MANAGER' ROLE_LANGUAGE_MANAGER' ROLE_GO_DATA_ADMINISTRATOR' ROLE_REFERENCE_DATA_MANAGER' ROLE_SYSTEM_ADMINISTRATOR' ROLE_USER_MANAGE
roleIds <- list("ROLE_CONTACT_TRACER","ROLE_CONTACT_TRACING_COORDINATOR", "ROLE_DATA_MANAGER", "ROLE_REPORTS_AND_DATA_VIEWER","ROLE_DEFAULT_MINIMUM_BACKUP_ACCESS", "ROLE_EPIDEMIOLOGIST", "ROLE_HELP_CONTENT_MANAGER", "ROLE_LAB_RESULTS_MANAGER", "ROLE_GO_DATA_ADMINISTRATOR","ROLE_REFERENCE_DATA_MANAGER" ,"ROLE_SYSTEM_ADMINISTRATOR", "ROLE_USER_MANAGER")
role_list <- list(roleIds)
names(role_list) <-"roleIds"


### TIP: you can get the role codes by reading from a participant that has all roles assigned
# E.g. Participant 1
role_list<- training_participants[[1]]["roleIds"]


###### CHANGE USER ROLES ################################################################
for (i in 1:length(training_participants)) {
  
  url_patch<- paste0(url,"api/users/", training_participants[[i]]["id"], "?access_token=",token )
  
  patch_roles<- PATCH(url=url_patch, body=role_list, encode="json")
  
  warn_for_status(patch_roles)
  
  
  print(paste0("RoleIds have been assigned to participant ", training_participants[[i]]["firstName"] ))
}


