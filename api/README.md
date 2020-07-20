## Overview of API scripts
Note: before running these scripts, make sure that the user used to send the request to the API has access to ALL outbreaks that you are referencing in script. To do this, you have to UNSELECT all outbreaks in the “available outbreak” dropdown menu from the user configuration page in Go.Data.

### Retrieve your data collections from your Go.Data instance and import into R
- Script Name	data_import_api.R

### Scripts to retrieve your collections from your Go.Data instance
Description of scripts for managing Training instance through API


- Script Name	1_godata_UpdateDatesInTraining.R
Description	This script gets cases, contacts, events, lab results and all the relationships of the cases and moves their dates by the number of days (defined in the input parameters) in order to keep outbreaks up to date. 
Needed inputs	•	URL of the Go.Data server ending in “/”
•	UserName and Password of a user with the right to manage users
•	IDs of the outbreak that needs to be updated
•	Number of days by which dates need to be move forward.
Outputs	The outbreak is moved in time X amount of days.
Authors	Lucia Fernandez (fernandezl@who.int) - Produced in June 2020


Script Name	2_Godata_modifyUserAccessToOubreak.R
Description	This script gets a list of users from Go.Data, identifies which of them are training participants and sets their available outbreaks and active outbreak
Needed inputs	•	URL of the GO.Data server ending in “/”
•	UserName and Password of a user with the right to manage users
•	IDs of the training outbreaks we want to assign to users
•	 ID of the outbreak we want to make active for users
•	Language of the training participants
Outputs	All the participants of the training have access to the given outbreaks and their active outbreaks is set.  
Authors	Lucia Fernandez (fernandezl@who.int) - Produced in June 2020


Script Name	3_godata_generateOutbreaks.R
Description	This script generates outbreaks for those participants that haven’t been able to generate their own during the training sessions and gives them access to this outbreak. It defines as well participants active outbreak
Needed inputs	•	URL of the GO.Data server ending in “/”
•	UserName and Password of a user with the right to manage users
•	IDs of the training outbreaks we want participants to have access to
•	List of training participants in standard format

Outputs	All the participants will have an outbreak to practice data import.  
Authors	Lucia Fernandez (fernandezl@who.int) - Produced in June 2020


Script Name	4_godata_giveUsersAccessToMobileOutbreak.R
Description	This script gives users access to the outbreak used for connecting mobile phone and sets it active to prevent issues while participants connect. (Note: it respects user’s access to all outbreak he/she had access to before o running this script)
Needed inputs	•	URL of the GO.Data server ending in “/”
•	UserName and Password of a user with the right to manage users
•	IDs of the training outbreaks we want participants to have access to
•	ID of outbreak to be used for mobile phone connection
•	Language of the training participants
Outputs	All the participants of the training have access to the given outbreaks and their active outbreaks is set.  
Authors	Lucia Fernandez (fernandezl@who.int) - Produced in June 2020


Script Name	Addition_godata_modifyUserRoles.R
Description	This script modifies in bulk the roles of users of a go data installation with a certain pattern in the firstName
Needed inputs	•	URL of the GO.Data server ending in “/”
•	UserName and Password of a user with the right to manage users
Outputs	All the participants will have an outbreak to practice data import.  
Notes	The script can be adapted to change users based on any other property of the user object (email, middleName, etc..)
Authors	Lucia Fernandez (fernandezl@who.int) - Produced in June 2020


Script Name	Addition_godata_createHospitalizations.R

Description	This script generates demo hospitalization dates for the cases of an outbreak. It generates them through the random number generator from the dateOfOnset
Needed inputs	•	URL of the GO.Data server ending in “/”
•	UserName and Password of a user with the right to manage users
•	IDs of the training outbreaks we want participants to have access to
•	List of training participants in standard format

Outputs	All cases of an outbreak will have hospitalization data  
Authors
Sara Hollis (holliss@who.int) and Lucia Fernandez (fernandezl@who.int) - Produced in June 2020


