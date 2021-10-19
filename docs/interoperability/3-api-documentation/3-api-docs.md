---
layout: default
title: API Documentation
parent: Go.Data Interoperability Toolkit
nav_order: 4
permalink: /api-docs/
---

# Go.Data API Documentation
_This section was originally published in the Go.Data [**IT Admin Guide, pg. 53**](https://community-godata.who.int/page/documents). Additional resources have been added_

<span style="color: orange;">**_NOTE:_** As of V38.1 there were some performance enhancements to the API for large volumes of data. This affects endpoints ending in `/export`. Please see section below ***Important API Updates*** to learn more.
</span>

## API Introduction
Go.Data exposes an Application Programming Interface (API) which is used for all interactions between the web front-end, the smartphone applications and even between copies of Go.Data, if you configure multiple instances of the solution to exchange data in an “upstream sever/client application” model.
This means that the API is very flexible and any operation possible from the web interface/smartphone can also be made by calling the appropriate method direct.

## LoopBack Explorer 
The self-documenting description of the API methods can be viewed using Loopback Explorer by adding `/explorer` to the end of any Go.Data URL.  For example, when installing Go.Data on your local machine with default settings:

`http://localhost:8000/explorer`

LoopBack Explorer provides some examples of possible operations, lists interface parameters and allows you to manually input json inputs and to test them against the API.
Methods are present to `GET`, `POST`, `PATCH`, etc. for bidirectional exchange of data with Go.Data. A familiarity with the types of data entities present within Go.Data is essential for understanding the API.

<span style="color: orange;">**_NOTE:_** Go.Data is currently running on LoopBack Version 3 - which is no longer actively supported by LoopBack development team. We are looking to migrate to LoopBack 4 ASAP in an upcoming Go.Data release, in which case we will inform all Go.Data users of any significant API changes that could affect integration and analytics scripts. </span>

The LoopBack team has provided great documentation for how to query data (e.g., how to add field filters to HTTP requests), which you can find in the documentation 
[here](https://loopback.io/doc/en/lb3/Querying-data.html)

## Authentication 
Almost all methods exposed by Go.Data require the request to be called by an authenticateduser. Authentication works as follows: 
1. A call must be made to POST method /users/login passing in an email and password for a valid user within Go.Data. An example is given below:
```
{ 
"email": "email@test.com", 
"password": "your_password_here" 
} 
```
2. If the user details passed are accepted, then this method will return the following json response which contains an “id” property which 
is the authentication token to be used by this user for subsequent calls.
```
{ 
"id": "Iv0S7Tj1F8RJaQSpBPHUlQ518KOUmK3SC7FlDvqLgbfbtjBt6ZFB77ViEQnKtqRq",
"ttl": 600,
"created": "2020-06-22T13:20:49.549Z", 
"userId": "18bf64ac-a36e-4890-a074-64aec702e21b", 
"createdAt ": "2020-06-22T13:20:49.550Z",
"createdBy ": "system",
"updatedAt ": "2020-06-22T13:20:49.550Z",
"updatedBy ": "system",
"deleted": false
} 
```
3. The `token` received must be passed in the header of following calls. Within the loopback explorer interface, there is the 
option to enter this token at the top right and request that it is stored for testing further calls.
![outbreak](../assets/get-access-token.png)

4. Note that all users in Go.Data have a *single “active” outbreak* and this will be the one whose data is returned in subsequent calls using the authentication token received for the user. 
If you need to work across multiple outbreaks in your code, then you will either need to change users OR switch the active outbreak of the current user via an API call.

5. For this same reason, following call to work with outbreak data usually involve methods under the “outbreak” API path as shown in the next screenshot.
![outbreak](../assets/api-outbreak.png)

6. Other tools such as SoapUI or even constructing a query and submitting directly as a URL are possible. For example, to retrieve a list of all outbreaks in Go.Data using an authentication 
token already received calling the API of my local instance, the call would be constructed as follows:
```
http://localhost:8000/api/outbreaks?
access_token=VUCA57YkMIcF5R2M8vl6PuaNHoMU0Q3Mr4cmGEOH06CPblx6xflnAw0AfQaMYdZP
```
Note that is the response returns `422 "Invalid captcha"` if received when attempting the call to the login API method, then this is a known issue linked to Go.Data’s use of cookies 
and you can workaround as follows:
1. Captcha is saved in a session variable associated with the cookie provided by the browser only for a specific web page. Make sure that you don’t call `'GET /captcha/generate-svg'` with `forComponent=login`. 
If you want to use the login directly from the API, avoid calling this method, since this is the method that forces the login method to restrict access without entering captcha. If this is the case, 
restart the API, followed by calling login without calling this method first.

2. f you use API Explorer requests, in which case the browser attaches the cookie used by the session variable, with one usage example being: open login page, followed by accessing the explorer and try to login, 
then you will get the `422 “Invalid captcha”` error, then these are the steps to follow:
- close all websites page, close browser
- open browser
- open explorer directly without going through the login page (in this case the
browser resets the cookie variable, so it should work without having to restart the API)

Other potential solutions:
- use browser with incognito mode
- use a different browser than the one used for Web UI
- close tab followed by clearing cookies cache related to this website

## Working with data 
Once authenticated, bidirectional exchange of data with Go.Data’s API is then possible, and the lifetime of the authentication token is extended with each successful call.

### Outbreak example
For example, to retrieve details of a single outbreak (the name of the outbreak, location etc.) a call can be made to the `GET` outbreaks method and would be constructed as follows by passing in both the access token (received from authentication) and the ID of the outbreak of interest.

```
GET /outbreaks
```
```
http://localhost:8000/api/outbreaks/8c71e61f-fb11-4d4f-9130-b69384b6e4e4?
access_token=VUCA57YkMIcF5R2M8vl6PuaNHoMU0Q3Mr4cmGEOH06CPblx6xflnAw0AfQaMYdZP
```

The IDs used in these calls are the internal Globally Unique Identifiers (GUIDs) used as primary keys for records in the MongoDB.
In the example above, there are two ways that a user could find the ID of the outbreak to use: 
1. If the user logins in Go.Data and navigates to a record, then the ID typically appears in the URL at the top of the page. An example is given below for viewing the example `COVID-19 Demonstration` outbreak and the ID that appears.
```
http://localhost:8000/api/outbreaks/cd936eee-5bfb-433b-a80e-e26c66bf6a48?
access_token=VUCA57YkMIcF5R2M8vl6PuaNHoMU0Q3Mr4cmGEOH06CPblx6xflnAw0AfQaMYdZ
```
![global-id](../assets/godata-ids-outbreak.png)

2. If a user needs to look up an ID, then it can always be done via a method also. In this example, the GET outbreaks method can be used to retrieve all outbreaks and then find the ID of the one in which you’re interested.
```
GET /outbreaks
```
### Case example
As a second example, the call to retrieve all cases belonging to a given outbreak would be as follows:
```
GET /outbreaks/{id}/cases
```
```
http://localhost:8000/api/outbreaks/cd936eee-5bfb-433b-a80e-e26c66bf6a48/cases?
access_token=VUCA57YkMIcF5R2M8vl6PuaNHoMU0Q3Mr4cmGEOH06CPblx6xflnAw0AfQaMYdZP
```
Note that any security restrictions that limit the data which the user can see will also apply to calls via the API. Users should be careful to authenticate with a user account which has sufficient privilege and access for the data they wish to access/change.
The call to access the record for a specific case would then incorporate the access token, the outbreak ID and the ID of the case you wish to return:
```
GET /outbreaks/{id}/cases/{fk}
```
```
http://localhost:8000/api/outbreaks/cd936eee-5bfb-433b-a80e-e26c66bf6a48/cases/3cd71bf6-afac-40d3-a32d-a1793cfe7638
access_token=HNm29JYiCIa0sNk5kjyTl8FeGKJmhFMiWAhGL6FOBVcBSCc2s2JDQ3EnLH4dFt4l
```

For posting data back to Go.Data, the same json structures should be used but if there are any fields that are not to be changed, then those JSON properties should be omitted, not left blank.
For example, if we wished to update the first name for the Case that was retrieved in the previous call then a call would be made to the following PUT method:
```
PUT /outbreaks/{id}/cases/{fk}
```
And the data passed in would be only the field to be changed:
```
{ "firstName": "TestDemo" } 
```
This constructs the following call:
```
http://localhost:8000/api/outbreaks/cd936eee-5bfb-433b-a80e-e26c66bf6a48/cases/3cd71bf6-afac-40d3-a32d-a1793cfe7638?access_token=HNm29JYiCIa0sNk5kjyTl8FeGKJmhFMiWAhGL6FOBVcBSCc2s2JDQ3EnLH4dFt4l
```
### FILTER to retrieve only records with given conditions met, using WHERE filter (i.e. only selecting certain "rows" of observations)
To use the filters provided with the method calls, the syntax is to use the keyword “where” and the sequence of elements for filtering: `{"where":{"fieldname": "filtervalue"}}`
For more on filtering, view the full LoopBack documentation [here](https://loopback.io/doc/en/lb3/Where-filter.html). 

For example, if filtering the method `GET /outbreak/{id}/cases` based on the Case ID, the filter would be `{"where":{"visualId": "CA00000001"}}`. This string will need URL encoding if passed as part of the URL (see screenshot below).

![where_filter](../assets/where_filter_url_encoding.PNG)

*Example of filtering for cases created AFTER a given date*
- JSON QUERY:  

```json
{"where":{"createdAt":{"$gt":"2020-04-14T00:00:00Z"}}}
```

- URL ENCODED: 

```txt
%7B%22where%22%3A%7B%22createdAt%22%3A%7B%22%24gt%22%3A%222020-04-14T00%3A00%3A00Z%22%7D%7D%7D
```

- REQUEST COMMAND: 

```txt
/outbreaks/{outbreak_id}/cases?filter=%7B%22where%22%3A%7B%22createdAt%22%3A%7B%22%24gt%22%3A%222020-04-14T00%3A00%3A00Z%22%7D%7D%7D&access_token={your_access_token}
```

- FINAL GET REQUEST: 

```txt
https://godata.gov.mt/api//outbreaks/{OUTBREAK TOKEN}/cases?filter=%7B%22where%22%3A%7B%22createdAt%22%3A%7B%22%24gt%22%3A%222020-04-14T00%3A00%3A00Z%22%7D%7D%7D&access_token={your_access_token}
```


*Example of filtering on more than 1 condition, i.e. retrieve only deleted records updated before a given date*

- JSON QUERY: 

```json
{"where": {"and": [{"deleted": {"eq": true}},{"updatedAt": {"lte": "2021-01-01T00:00:00.000Z"}}]},"deleted": true}
```


### FILTER to retrieve only certain fields needed for analysis using FIELDS filter (i.e. only selecting certain "columns" across observations)
Here, you will use "fields" to g: `{"fields":{"fieldname1": "true","fieldname2": "true"}}`

**NOTE: You can also filter for subfields using the "dot" notation.**

For more on filtering, view the full LoopBack documentation [here](https://loopback.io/doc/en/lb3/Where-filter.html). 

This could be useful to reduce the memory load; if you are only focusing on core case/contact variables and do not need bulky questionnaire variables. Similar URL encoding is required, see screenshot and below examples to get you started:

![fields_filter](../assets/fields_filter_url_encoding.PNG)

*Example of filtering your cases dataset to only bring back visualId, firstName, lastName, addresses.locationId  and createdAt fields*

**NOTE: Location ID is a subfield within Addresses nested list object; so you can identify it for retrieval using dot notation**.

- JSON QUERY:  

```json
{"fields": {"firstName":"true",
            "lastName":"true",
            "visualId":"true",
            "addresses.locationId":"true",
            "createdAt":"true"}}
```

- URL ENCODED: 

```txt
%7B%22fields%22%3A%7B%22firstName%22%3A%22true%22%2C%22lastName%22%3A%22true%22%2C%22visualId%22%3A%22true%22%2C%22addresses.locationId%22%3A%22true%22%2C%22createdAt%22%3A%22true%7D%7D%7D
```

- FINAL GET REQUEST: 
```txt
https://{yourgodataurl.com}/api/outbreaks/{outbreak_id}/cases?filter=%7B%22fields%22%3A%7B%22firstName%22%3A%22true%22%2C%22lastName%22%3A%22true%22%2C%22visualId%22%3A%22true%22%2C%22createdAt%22%3A%22true%7D%7D%7D&access_token={your_access_token}
```

- in R, using HTTR package:

```r{% raw %}
response_cases_short <- GET(paste0(url,"api/outbreaks/",outbreak_id,"/cases/?filter={%22fields%22:{%22firstName%22:%22true%22,%22lastName%22:%22true%22}}"),
                      add_headers(Authorization = paste("Bearer", access_token, sep = " "))
                      )
json_cases_short <- content(response_cases_short, as = "text")
cases_short <- as_tibble(fromJSON(json_cases_short, flatten = TRUE))
{% endraw %}```

## Important API Changes

As of V38.1 there were some optimizations to the API to increase performance for large amounts of data. Now, if you use the /export endpoints (example: outbreak/{id}/cases/export ) instead of just /cases, there is a multi-step process:
- In API call, you specifically specify a file type
- An “export request” is submitted to the server.
- You check status periodically Then, only when export is ready, it will be downloaded
- Once downloaded, use this fileId and pass to the /export endpoint to retrieve the file.

To see more examples of how this works, with R code, see here: https://github.com/WorldHealthOrganization/godataR#handling-versioning-across-godata-releases

## Example Implementations
- See the [Github `api` directory](https://github.com/WorldHealthOrganization/godata/tree/master/api) for sample scripts leveraging the API, both in R and Python.
