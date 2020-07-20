###### SET INPUT PARAMETES ################################################################################################

url <- "https://godata-xxx.who.int/"            # <--------------------- insert instance url here, don't forget the slash at end !
username <- "godata_api@who.int"                             # <--------------------- insert your username for signing into Go.Data webapp here
password <- "xxxxxxxxxxxxxxxxxxx"                           # <--------------------- insert your password for signing into Go.Data webapp here


participants_list <- "participants/Go.Data_Training_UserAccounts.xlsx"        #<--------------participants list- File path
excel_sheet = "Users"              # <------------------ Name of tab where the participant list is found

## Define training outbreaks ids
group_practices<- "964a799f-3695-46a6-9390-c710281c590e"
visualizations <- "2013bdf0-fc21-4e4c-b9b2-eaec0e022487"

active_outbreak <-group_practices 
## IMPORTANT : before running this script, make sure that the user godata_api@who.int does not have any 
## available outbreaks selected
###### LOAD REQUIRED LIBRARIES ###################################################################################################

#load required packages
library(httr)    
library(dplyr)   
library(jsonlite)  
library(magrittr) 
library(chron)
library(lubridate)
library(readxl)
library(RCurl)
library(stringr)

###### LOG IN #####################################################################


login <- POST(paste0(url, "api/users/login"), content_type_json(), body =paste0("{\"email\":\"", username, "\",\"password\":\"", password,"\",\"token\":null,\"userid\":null}") )
warn_for_status(login)
credentials <- content(login)


###The response gives the user ID and the token to be used later
token <- credentials$id
userid <- credentials$userId



###### MATCH PARTICIPANT NAME WITH GO.DATA USERS ID #######################################################################################

## Read participant list
participants <- read_excel(participants_list, sheet = excel_sheet, skip = 1)
names(participants)[3]<- "name"
                           ## Remove empty rows
participants <- participants[which(!is.na(participants$name)),]

## Get Go.Data Users
response_user_list <- GET(paste0(url,"api/users?access_token=",token))
user_list <- content(response_user_list)

## Filter for training participants only
user_df <- content(response_user_list, as = "text")
user_df <- as_tibble(fromJSON(user_df, flatten = TRUE)) 
user_df <-user_df[which(substring(user_df$firstName, 1,11)=="PARTICIPANT"),]
users<- c(user_df$id)

### Add GO.Data user ID to participant list
participants <- left_join(participants, user_df[,c("email","id")], by=c("Username"="email"))


###### MATCH PARTICIPANTS WITH THE OUTBREAKS THEY CREATED #######################################################################################
## Get the full list of outbreaks from Go.Data
Source_response_outbreaks <- GET(paste0(url,"api/outbreaks?access_token=",token))
outbreaks <- content(Source_response_outbreaks, as = "text")
outbreaks <- as_tibble(fromJSON(outbreaks, flatten = TRUE))
outbreaks <- outbreaks[, c("name","id","createdBy")]
names(outbreaks) <- c("outbreak_name","outbreak_id","createdBy")

## Get the outbreaks that the participants created themselves
participants_self_created_outbreaks <- outbreaks[which(outbreaks$createdBy %in% users), ]


participants_self_created_outbreaks <- participants_self_created_outbreaks %>%
  group_by(createdBy) %>%
  summarise( outbreaks_id = paste(outbreak_id, collapse ="\",\"" ))


## Match participants with the id of the outbreak they created
participants <-left_join(participants, participants_self_created_outbreaks, by=c("id"="createdBy"))
participants <- as.data.frame(participants)                        

###### CREATE OUTBREAKS FOR PARTICIPANTS THAT COULD NOT CREATE ONE THEMSELVES ###########################################
outbreak <- fromJSON("templates/outbreak_template.json", flatten=TRUE)


## Loop through the list of participants to create an outbreak for them an given them access
## Note: the loop respects the outbreaks that they created if they managed to do so, without removing their access

for (i in 1:length(participants)) {
  
  ## Obtain participants details
  participant_id<-participants[i,c("id")]
  participant_email<-participants[i,c("Username")]
  participant_name <- participants[i,c("name")]
  participant_self_created_outbreaks <- participants[i,c("outbreaks_id")]
   
  ## The loop checks if the participant has created its outbreak(s), if not, creates an outbreak for the participants and gives him/her access
  ## The loop makes the Group Outbreak active for all participants
  if (is.na( participant_self_created_outbreaks)) {
    
    outbreak_forParticipant <-as.character(paste0("COVID 19 ",  participants[i,c("name")]))
    outbreak[["name"]]<-  outbreak_forParticipant
    locationIds <- outbreak[["locationIds"]]
    outbreak[["locationIds"]]<- list()
    outbreak[["locationIds"]][[1]] <- locationIds
    
    print(paste0("Creating outbreak for participant: ", participant_name))
    POST(paste0(url,"api/outbreaks?access_token=",token),body=outbreak, encode="json")
    Sys.sleep(1)
    
    get_outbreaks <- GET(paste0(url,"api/outbreaks?access_token=",token))
   all_outbreaks <- content(get_outbreaks, as = "text")
   all_outbreaks <- as_tibble(fromJSON(all_outbreaks, flatten = TRUE))
   all_outbreaks <- all_outbreaks[, c("name","id","createdBy")]
    
    
    ## Get the outbreaks that the participants created themselves
    participants_assigned_outbreak <- all_outbreaks[which(all_outbreaks$name==outbreak_forParticipant), ]
    participants_assigned_outbreak_id <- as.character(participants_assigned_outbreak$id)
    
    ## URL to send patch request to user endpoint
    url_patch<- paste0(url,"api/users/", participant_id, "?access_token=",token )
    
    ## Give user access to outbreaks
    patch_outbreaks <- PATCH(url=url_patch, content_type_json(),
                             body = paste0("{\"outbreakIds\":[\"", group_practices, "\",\"",visualizations, "\",\"", participants_assigned_outbreak_id,"\"]}"))

    warn_for_status(patch_outbreaks)
    print(paste0("New outbreak has been made active for ", participant_name ))
    
    ## Setting user's active outbreak
    patch_outbreak <- PATCH(url=url_patch, content_type_json(),
                            body = paste0("{\"activeOutbreakId\":\"", active_outbreak, "\"}"))
    
    warn_for_status(patch_outbreak)
    
    print(paste0(participant_name, " has the new outbreak as active outbreak"))
    
  } else if (length( participant_self_created_outbreaks)>=1) {
    
    url_patch<- paste0(url,"api/users/", participant_id, "?access_token=",token )
    ## Give user access to outbreaks
    patch_outbreaks <- PATCH(url=url_patch, content_type_json(),
                             body = paste0("{\"outbreakIds\":[\"", group_practices, "\",\"",visualizations, "\",\"", participant_self_created_outbreaks, "\"]}"))
    
    warn_for_status(patch_outbreaks)
    
    print(paste0("Participant ", participant_name, "has created its own outbreak" ))
    
    # Setting user's active outbreak
  
    patch_outbreak <- PATCH(url=url_patch, content_type_json(),
                            body = paste0("{\"activeOutbreakId\":\"", active_outbreak, "\"}"))
    
    warn_for_status(patch_outbreak)
    
    print(paste0("Group outbreak has been made active for ", participant_name ))
    
  } 
  
}






