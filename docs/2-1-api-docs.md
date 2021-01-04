# Go.Data API Documentation
_This section was originally published in the Go.Data *IT Admin Guide, pg. 53*. Additional resources have been added_

## API Introduction
Go.Data exposes an Application Programming Interface (API) which is used for all interactions between the web front-end, the smartphone applications and even between copies of Go.Data, 
if you configure multiple instances of the solution to exchange data in an “upstream sever/client application” model.
This means that the API is very flexible and any operation possible from the web interface/smartphone can also be made by calling the appropriate method direct.

## API Explorer 
The self-documenting description of the API methods can be viewed using Loopback Explorer by adding `/explorer` to the end of any Go.Data URL.  For example, when installing Go.Data on your local machine with default settings: -
`http://localhost:8000/explorer`

Loopack explorer provides some examples of possible operations, lists interface parameters and allows you to manually input json inputs and to test them against the API.
Methods are present to `GET`, `POST`, `PATCH`, etc. for bidirectional exchange of data with Go.Data. A familiarity with the types of data entities present within Go.Data is essential for understanding the API.

See the API Loopback Explorer for the Go.Data Demo Site: *[INSERT URL]*

For more information on interacting with the API (e.g., how to add field filters to HTTP requests), see the LoopBack documentation: 
https://loopback.io/doc/en/lb3/Fields-filter.html

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

4. Note that all users in Go.Data have a *single “active” outbreak* and this will be the one whose data is returned in subsequent calls using the authentication token received for the user. 
If you need to work across multiple outbreaks in your code, then you will either need to change users OR switch the active outbreak of the current user via an API call.

5. For this same reason, following call to work with outbreak data usually involve methods under the “outbreak” API path as shown in the next screenshot.


6. Other tools such as SoapUI or even constructing a query and submitting directly as a URL are possible. For example, to retrieve a list of all outbreaks in Go.Data using an authentication 
token already received calling the API of my local instance, the call would be constructed as follows:
```
http://localhost:8000/api/outbreaks?access_token=VUCA57YkMIcF5R2M8vl6Pu aNHoMU0Q3Mr4cmGEOH06CPblx6xflnAw0AfQaMYdZP
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

## Example Implementations
- See the [Github Repo](https://github.com/WorldHealthOrganization/godata/tree/master/api) for sample scripts leveraging the API. 
