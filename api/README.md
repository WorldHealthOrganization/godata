## Overview of API scripts
Note: before running these scripts, make sure that the user used to send the request to the API has access to ALL outbreaks that you are referencing in script. To do this, you have to UNSELECT all outbreaks in the “available outbreak” dropdown menu from the user configuration page in Go.Data.

### Retrieve your data collections from your Go.Data instance and import into R
#### data_import_api.R
##### _This script gets relevant database collections from your Go.Data instance and stores them as tidy data frames in R (including all cases/contacts, followups, locations, users, teams)_
* Required inputs	
  * URL of the Go.Data server ending in “/”
  * UserName and Password of a user 
  * IDs of the outbreak for which you want to retrieve collections (can only do one outbreak at a time)
* Outputs	
  * flattened dataframes stored in R
  
 _Authors	Sara Hollis (holliss@who.int) - Produced in Feb 2020_


### Managing your instance through API
#### godata_UpdateDatesInTraining.R	
##### _This script gets cases, contacts, events, lab results and all the relationships of the cases and moves their dates by the number of days (defined in the input parameters) in order to keep outbreaks up to date._
* Required inputs	
  * URL of the Go.Data server ending in “/”
  * UserName and Password of a user with the right to manage users
  * IDs of the outbreak that needs to be updated
  * Number of days by which dates need to be move forward.
* Outputs	
  * The outbreak is moved in time X amount of days.

_Authors	Lucia Fernandez (fernandezl@who.int) - Produced in June 2020_

#### godata_modifyUserAccessToOubreak.R
##### _This script gets a list of users from Go.Data, identifies which of them are training participants and sets their available outbreaks and active outbreak_
* Required inputs:
  * URL of the GO.Data server ending in “/”
  * UserName and Password of a user with the right to manage users
  * IDs of the training outbreaks we want to assign to users
  * ID of the outbreak we want to make active for users
  *	Language of the training participants
* Outputs:
   * All the participants of the training have access to the given outbreaks and their active outbreaks is set.  
   
_Authors	Lucia Fernandez (fernandezl@who.int) - Produced in June 2020_

#### godata_generateOutbreaks.R
##### _This script generates outbreaks for those participants that haven’t been able to generate their own during the training sessions and gives them access to this outbreak. It defines as well participants active outbreak_
* Required inputs:	
  * URL of the GO.Data server ending in “/”
  * UserName and Password of a user with the right to manage users
  *IDs of the training outbreaks we want participants to have access to
  * List of training participants in standard format
* Outputs:
  * All the participants will have an outbreak to practice data import.  

_Authors	Lucia Fernandez (fernandezl@who.int) - Produced in June 2020_

#### godata_giveUsersAccessToMobileOutbreak.R
##### _This script gives users access to the outbreak used for connecting mobile phone and sets it active to prevent issues while participants connect. (Note: it respects user’s access to all outbreak he/she had access to before o running this script)_
* Required inputs	
  * URL of the GO.Data server ending in “/”
  * UserName and Password of a user with the right to manage users
  * IDs of the training outbreaks we want participants to have access to
  * ID of outbreak to be used for mobile phone connection
  * Language of the training participants
* Outputs
  * All the participants of the training have access to the given outbreaks and their active outbreaks is set.  

_Authors	Lucia Fernandez (fernandezl@who.int) - Produced in June 2020_

#### godata_modifyUserRoles.R
##### _This script modifies in bulk the roles of users of a go data installation with a certain pattern in the firstName_
* Required inputs
  * URL of the GO.Data server ending in “/”
  * UserName and Password of a user with the right to manage users
* Outputs
  * All the participants will have an outbreak to practice data import.  
  * NOTE:	The script can be adapted to change users based on any other property of the user object (email, middleName, etc..)

_Authors	Lucia Fernandez (fernandezl@who.int) - Produced in June 2020_

#### godata_createHospitalizations.R
##### _This script generates demo hospitalization dates for the cases of an outbreak. It generates them through the random number generator from the dateOfOnset_
* Required inputs
  * URL of the GO.Data server ending in “/”
  * UserName and Password of a user with the right to manage users
  * IDs of the training outbreaks we want participants to have access to
  * List of training participants in standard format
* Outputs
  * All cases of an outbreak will have hospitalization data  

Authors
_Sara Hollis (holliss@who.int) and Lucia Fernandez (fernandezl@who.int) - Produced in June 2020_


