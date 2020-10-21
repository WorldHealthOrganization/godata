/**
This script was developed by the team in Free State Province (Sello Pitsi, PitsiSE@fshealth.gov.za) for pushing cases from their national HMIS system (NICD) to Go.Data
**/



/**
* Login Method - NICD
* 
*
**/
function loginFunction() {

			 let headers = new Headers();
    			headers.append('apiKey', '');
    			var username = "";
    			var password = "";


    			var url = "https://apitest.nicd.ac.za/NMC/ResultData/Login?username="+username+"&password="+password;

          //Used to bypass the  CORS policy block
    			const proxyurl = "https://cors-anywhere.herokuapp.com/";



 				fetch(proxyurl + url, {
  				method: "POST",
  				mode: 'cors',
  				withCredentials: true,
  				headers: headers
			}).then(response => response.json()) 
				.then(
					json => getCaseList(username,json.token)
					) 
				.catch(err => console.log(err));
		}

/**
* Get Cases Method - NICD
* 
*
**/  

	function getCaseList(username,token){

			 let headers = new Headers();
    			headers.append('apiKey', '');

			var url = "https://apitest.nicd.ac.za/NMC/ResultData/GetCaseList?username="+username+"&token="+token+"&lastRecord=0";

				const proxyurl = "https://cors-anywhere.herokuapp.com/";
			fetch(proxyurl + url, {
  				method: "GET",
  				mode: 'cors',
  				withCredentials: true,
  				headers: headers
			}).then(response => response.json()) 
				.then(
					json => submitDataFunction(json,username,token) //console.log(json)
					) 
				.catch(err => console.log(err));

	}

  /**
* Storing Data Temporally 
* 
*
**/ 
	function submitDataFunction(response,username,token){

			var cases_list = response.Data;
      
      for (var i = 0; i < 1; i++) {
					
       var  cases = cases_list[i];
       
         $.ajax({
            url: "Main_c/save_cases",
            data: {cases:cases},
            method: 'POST',
        }).done(function(resp){
          
         	console.log(resp); 
        


        });
				
			}
      logoutFunction(username,token);
	}

  /**
* Logoout Method - NICD
* 
*
**/ 
	function logoutFunction(username,token){

			 let headers = new Headers();
    			headers.append('apiKey', '');

			var url = "https://apitest.nicd.ac.za/NMC/ResultData/Logout?username="+username+"&token="+token;

				const proxyurl = "https://cors-anywhere.herokuapp.com/";
			fetch(proxyurl + url, {
  				method: "POST",
  				mode: 'cors',
  				withCredentials: true,
  				headers: headers
			}).then(response => response.json()) 
				.then(
					json => console.log(json)
					) 
				.catch(err => console.log(err));

	}
 

  /**
* Login Method - Godata
* 
*
**/ 
 function loginGoDataFunction(){
   
    			var username = "";
    			var password = "";


    			var url = "https://X.X.gov.za/api/oauth/token";

    	    $.ajax({
            type: "POST",
            //the url where you want to sent the userName and password to
            url: url,
            dataType: 'json',
            async: false,
            //json object to sent to the authentication url
            data: {username: username ,password : password },
            success: function (resp) {
                //do any process for successful authentication here
                var token = resp.response.access_token;
                 SendDataToGoData(token);
            }
        });
 }

   /**
* Retriving Temporally stored data 
* 
*
**/ 
  
  function SendDataToGoData(token){
  
     
     $.ajax({
                url: 'Main_c/getData',
                method: 'POST',
                dataType: "JSON"
              })
              .done(function(result) {
              
                  for (var i = 0; i < result.length; i++) {
                    
                     sendToGoData(result[i],token);
                  }
              });
    
  
  }
  
 
/**
* Send Data To GoData Method - Godata
* 
*
**/ 
  function sendToGoData(json_data,token){
      

      var outbreaks_id = "";

    	var url = "https://X.X.gov.za/api/outbreaks/"+outbreaks_id+"/cases?access_token="+token;
      
      $.ajax({
            type: "POST",
          
            url: url,
            dataType: 'json',
            async: false,
            data: { "firstName": json_data['name'], "gender": "string",  "isDateOfOnsetApproximate": true,"wasContact": false,   "outcomeId": "string",  "safeBurial": false,  "burialPlaceName": "string",   "burialLocationId": "string",  "classification": "string",   "riskLevel": "string",  "riskReason": "string",   "transferRefused": false,  "questionnaireAnswers": {},  "vaccinesReceived": [    {       "vaccine": "string",      "date": "2020-10-15T07:02:16.222Z",      "status": "string"    }  ],   "pregnancyStatus": "string",   "id": "string1",   "outbreakId": "string",   "visualId": "00222222",  "middleName": "string",   "lastName": "string",  "dob": "2020-10-15T07:02:16.222Z",   "age": {    "years": 0,    "months": 0  },   "occupation": "string","documents": [{      "type": "string",      "number": "string"     } ],   "addresses": [{       "typeId": "LNG_REFERENCE_DATA_CATEGORY_ADDRESS_TYPE_USUAL_PLACE_OF_RESIDENCE",       "country": "string",       "city": "string",       "addressLine1": "string","postalCode": "string",       "locationId": "string",       "geoLocation": {         "lat": 0,         "lng": 0       },       "geoLocationAccurate": false,       "date": "2020-10-15T07:02:16.222Z",       "phoneNumber": "string",       "emailAddress": "string"     }  ],  "dateOfReporting": "2020-10-15T07:02:16.222Z",   "isDateOfReportingApproximate": false,   "dateOfLastContact": "2020-10-15T07:02:16.222Z",   "dateOfInfection": "2020-10-15T07:02:16.222Z",   "dateOfOnset": "2020-10-15T07:02:16.222Z",   "dateBecomeCase": "2020-10-15T07:02:16.222Z",   "dateRanges": [    {       "typeId": "string","centerName": "string",       "locationId": "string",       "comments": "string",       "startDate": "2020-10-15T07:02:16.222Z",       "endDate": "2020-10-15T07:02:16.222Z"     }  ],  "classificationHistory": [     {      "classification": "string",      "startDate": "2020-10-15T07:02:16.222Z",      "endDate": "2020-10-15T07:02:16.222Z"    }  ],  "dateOfOutcome": "2020-10-15T07:02:16.222Z",  "dateOfBurial": "2020-10-15T07:02:16.222Z",  "followUpTeamId": "string",  "deletedByParent": "string",  "hasRelationships": false,  "relationshipsRepresentation": [    {      "id": "string",      "active": true,      "otherParticipantType": "string",      "otherParticipantId": "string",      "target": true,      "source": true    }  ],  "notDuplicatesIds": [    ""  ],  "usualPlaceOfResidenceLocationId": "string",  "createdAt": "2020-10-15T07:02:16.222Z",  "createdBy": "string",  "updatedAt": "2020-10-15T07:02:16.222Z",  "updatedBy": "string",  "createdOn": "string",  "deleted": false,  "deletedAt": "2020-10-15T07:02:16.222Z"},
            success: function (resp) {
                //do any process for successful authentication here
                console.log(resp);
            }
        });



  }