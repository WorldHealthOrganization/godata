# Working with Go.Data API - sample code snippets
- go back to API Page on Go.Data Documentation Site [here](https://worldhealthorganization.github.io/godata/api-docs/)

## General Principles:
- You can interact with the Go.Data REST API in a number of ways, most code snippets we have here are in R (using *httr* and *jsonlite* packages) or Python.
- The self-documenting description of the API methods can be viewed using Loopback Explorer by adding /explorer to the end of any Go.Data URL
- There is extensive documentation on working with Loopback Explorer, including how to query effectively, [here](https://loopback.io/doc/en/lb3/Querying-data.html)
- To send requests to API, user must have access to ALL outbreaks that you are referencing in script. To do this, you have to UNSELECT all outbreaks in the “available outbreak” dropdown menu from the user configuration page in Go.Data.

## GET data collections from your Go.Data instance 
#### data_import_api.R
##### _This script gets relevant database collections from your Go.Data instance and stores them as tidy data frames in R (including all cases/contacts, followups, locations, users, teams)_
* Required inputs	
  * URL of the Go.Data server ending in “/”
  * UserName and Password of a user 
  * IDs of the outbreak for which you want to retrieve collections (can only do one outbreak at a time)
* Outputs	
  * flattened dataframes stored in R
  
 _Authors:	Sara Hollis (holliss@who.int) - Produced in Feb 2020_

#### godata_export_cases_to_gsheets_v1.0.py
##### _This script reads Go.Data cases, cleans, aggregates and exports them to Google Sheets_
* Required inputs	
  * URL of the Go.Data server ending in “/”
  * UserName and Password of a user 
  * IDs of the outbreak for which you want to retrieve collections (can only do one outbreak at a time)
  * Google Sheets API credentials
* Outputs	
  * aggregate case-counts in Google Sheets
  
 _Authors:	Mathias Leroy (mathiasleroy@gmail.com) - Produced in Nov 2020_

## PUT and/or MANAGE the data collections in your Go.Data instance via API calls

### Create objects (cases, contacts, outbreaks, hospitalizations)

#### godata_createCases.js
##### _This jquery script pushes cases from a national HMIS API to Go.Data instance._

_Authors:	Sello Pila (pilas@who.int) - Produced in Oct 2020_

#### godata_createHospitalizations.R
##### _This R script generates demo hospitalization for the cases of an outbreak. It generates them through the random number generator from the dateOfOnset_
* Required inputs
  * URL of the GO.Data server ending in “/”
  * UserName and Password of a user with the right to manage users
  * IDs of the training outbreaks we want participants to have access to
  * List of training participants in standard format
* Outputs
  * All cases of an outbreak will have hospitalization data  
  
_Authors: Sara Hollis (holliss@who.int) and Lucia Fernandez (fernandezl@who.int) - Produced in June 2020_

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

### Modify existing data (dates, user roles)

#### godata_UpdateDatesInTraining.R	
##### _This script gets cases, contacts, events, lab results and all the relationships of the cases and moves their dates by the number of days (defined in the input parameters) in order to keep outbreaks up to date._
* Required inputs	
  * URL of the Go.Data server ending in “/”
  * UserName and Password of a user with the right to manage users
  * IDs of the outbreak that needs to be updated
  * Number of days by which dates need to be move forward.
* Outputs	
  * The outbreak is moved in time X amount of days.

_Authors:	Lucia Fernandez (fernandezl@who.int) - Produced in June 2020_

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

## OTHER TIPS:

Receiving time-outs? You may need to apply special filters. Below is an example in Python:
```
def load_labs(token, base_url, outbreak_id):
        n =  0
        new_results = True
        export = []
        try:
            while new_results:
                lab_filter = f'{{"limit":10000, "skip":{n}}}'
                header = {
			'Authorization': token,
			'filter': lab_filter,
			'format': 'json'
			}

		        response = requests.get(
            			url = f'{base_url}/outbreaks/{outbreak_id}/lab-results/export',
            			headers= header,
            			proxies = None
        				)
                export = export.append(json.loads(response.text))
                n += 10000
                if len(json.loads(response.text))< 10000:
                    new_results = False
                    return export
                
        except Exception as e:
            return e
 ```
