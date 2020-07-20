###################################################################################################
url <- "https://godata-xyz.who.int/"                   # <--------------------- insert instance url here, don't forget the slash at end !
username <- "holliss@who.int"                           # <--------------------- insert your username for signing into Go.Data webapp here
password <- "xxxxxxxxxxxxxxxxx"                           # <--------------------- insert your password for signing into Go.Data webapp here
outbreak_id <- "e99f077f-339e-4d8c-9c57-bdef2dccc845"   # <--------------------- insert your outbreak ID here

###################################################################################################



###################################################################################################
# read in from go.data API, using your updated parameters by Clicking "Source"
# no need to modify the below unless you would like to bring in additional data collections!
# this script currently will give us: contacts, 
#                                     cases,
#                                     follow ups - last 21d,
#                                     locations,
#                                     users,
#                                     relationships
###################################################################################################

#load required packages
library(httr)    
library(dplyr)   
library(jsonlite)  
library(magrittr) 
library(sqldf)

#get access token
url_request <- paste0(url,"api/oauth/token?access_token=123")

response <- POST(url=url_request,  
                 body = list(
                   username = username,                                          
                   password = password),                                       
                 encode = "json")

content <-
  content(response, as = "text") %>%
  fromJSON(flatten = TRUE) %>%
  glimpse()

access_token <- content$response$access_token                 ## this is your access token !!! that allows API calls

#specify date ranges, for follow up filters
date_now <- format(Sys.time(), "%Y-%m-%dT23:59:59.999Z")                  
date_21d_ago <- format((Sys.Date()-21), "%Y-%m-%dT23:59:59.999Z")



# import contact follow-ups, last 21 days only to avoid system time-out 
response_followups <- GET(paste0(
  url,
  "api/outbreaks/",
  outbreak_id,
  "/follow-ups/?filter={%22where%22:{%22and%22:[{%22date%22:{%22between%22:[%22",
  date_21d_ago,
  "%22,%22",
  date_now,
  "%22]}}]}}"),
  add_headers(Authorization = paste("Bearer", access_token, sep = " ")))
json_followups <- content(response_followups, as="text")
followups <- as_tibble(fromJSON(json_followups, flatten = TRUE)) 



# import location hierarchy (outbreak agnostic)
response_locations <- GET(paste0(url,"api/locations"), 
                          add_headers(Authorization = paste("Bearer", access_token, sep = " "))
)
json_locations <- content(response_locations, as = "text")
locations <- as_tibble(fromJSON(json_locations, flatten = TRUE))


# import oubtreaks (outbreak agnostic)
response_outbreaks <- GET(paste0(url,"api/outbreaks"), 
                          add_headers(Authorization = paste("Bearer", access_token, sep = " "))
)
json_outbreaks <- content(response_outbreaks, as = "text")
outbreaks <- as_tibble(fromJSON(json_outbreaks, flatten = TRUE))

# import outbreak Cases 
response_cases <- GET(paste0(url,"api/outbreaks/",outbreak_id,"/cases"), 
                      add_headers(Authorization = paste("Bearer", access_token, sep = " "))
)
json_cases <- content(response_cases, as = "text")
cases <- as_tibble(fromJSON(json_cases, flatten = TRUE))

# import oubtreak Contacts
response_contacts <- GET(paste0(url,"api/outbreaks/",outbreak_id,"/contacts"), 
                         add_headers(Authorization = paste("Bearer", access_token, sep = " "))
)
json_contacts <- content(response_contacts, as = "text")
contacts <- as_tibble(fromJSON(json_contacts, flatten = TRUE)) %>%
  filter(active == TRUE) %>%
  filter(as.Date.character(followUp.endDate) >= Sys.Date()) %>%
  filter(followUp.status == "LNG_REFERENCE_DATA_CONTACT_FINAL_FOLLOW_UP_STATUS_TYPE_UNDER_FOLLOW_UP")

# import outbreak Relationships
response_relationships <- GET(paste0(url,"api/outbreaks/",outbreak_id,"/relationships/export"), 
                              add_headers(Authorization = paste("Bearer", access_token, sep = " "))
)
json_relationships <- content(response_relationships, as = "text")
relationships <- as_tibble(fromJSON(json_relationships, flatten = TRUE))


# import Teams (outbreak agnostic)
response_teams <- GET(paste0(url,"api/teams"), 
                      add_headers(Authorization = paste("Bearer", access_token, sep = " "))
)
json_teams <- content(response_teams, as = "text")
teams <- as_tibble(fromJSON(json_teams, flatten = TRUE))

# import Users (outbreak agnostic)
response_users <- GET(paste0(url,"api/users"), 
                      add_headers(Authorization = paste("Bearer", access_token, sep = " "))
)
json_users <- content(response_users, as = "text")
users <- as_tibble(fromJSON(json_users, flatten = TRUE))

