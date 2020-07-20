
## This scripts allows to set the avaialble and active outbreaks of users in bulk

###### GET LIST OF USER OF TRAINING PARTICIPANTS #################################################################################

url <- "https://godata-xxx.who.int/"   # <-------- insert instance url of your server here, don't forget the slash at end !

## Credentials of users with the right to manage users
username <- "godata_api@who.int"                             
password <- "xxxxxxxxxxxxxxxx"

## Define outbreaks to assign to participants
group_practices<- "c7daa36b-de67-4f96-bed6-7743d693d5c8"
visualizations <- "c53c552b-940c-494a-96f8-684e54c1fefe"


## Set active outbreak
active_outbreak <- group_practices

### Participants language: please set the parameter as either ENGLISH or FRANCAIS
language <- "FRANCAIS"

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

response_user_list <- GET(paste0(url,"api/users?access_token=",token))
user_list <- content(response_user_list)

## Filter for participants only
training_participants<-Filter(function(x) {str_detect(x["lastName"], language)}, user_list)


###### DEFINE AVAILABLE AND ACTIVE OUTBREAKS FOR SESSION 1 and 2 ###############################################################################
for (i in 1:length(training_participants)) {
  

url_patch<- paste0(url,"api/users/", training_participants[[i]]["id"], "?access_token=",token )


patch_outbreaks <- PATCH(url=url_patch, content_type_json(),
                         body = paste0("{\"outbreakIds\":[\"", group_practices,"\",\"",visualizations,  "\"]}"))

warn_for_status(patch_outbreaks)

patch_active_outbreak <- PATCH(url=url_patch, content_type_json(),
                        body = paste0("{\"activeOutbreakId\":\"", active_outbreak, "\"}"))

warn_for_status(patch_active_outbreak)

print(paste0("Outbreaks assigned to participant ", training_participants[[i]]["firstName"], " and outbreak ",active_outbreak, " set as active" ))

}


