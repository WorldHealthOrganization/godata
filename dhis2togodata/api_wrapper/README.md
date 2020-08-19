# Go.Data API Wrapper (WIP)

_developed by WISCENTD (https://github.com/WISCENTD-UPC)_

Javascript API wrapper around DHIS2. It handles authentication automatically given user credentials.

_see full package here: https://github.com/WISCENTD-UPC/godata-api-wrapper/tree/develop_

## Installation

This package is not currently in the npm ecosystem, so in order to install it in a project, it should be added as a git repository.

```{json}
  {
    "dependencies": {
      "godata-api-wrapper": "git+ssh://git@github.com/WISCENTD-UPC/godata-api-wrapper.git#develop"
    }
  }
```

After configuring the package.json ```npm install``` should be executed

## Usage

Creation of the api wrapper:

```{Javascript}
  const API = require('godata-api-wrapper')
  const api = new API({
    baseURL: '',
    credentials: {
      email: 'username',
      password: 'password'
    }
  })
```

### API Docs

+ api.login(credentials): Explicit login request. Credentials are optional if they were already defined in the creation of the api handler. This is generally not necessary since, for every endpoint, a middleware already checks if login is needed and performs it automatically.

+ api.getUsers(): Get all users.

+ api.getLocations(): Get all locations.

+ api.createLocation(location): Create location from an object.

+ api.deleteLocation(id): Delete location given its ID.

+ api.getOutbreaks(): Get all outbreaks.

+ api.createOutbreak(body): Create an outbreak from an object.

+ api.deleteOutbreak(id): Delete an outbreak given its ID. It handles automatically deactivating the outbreak for all users before deleting it.

+ api.activateOutbreakForUser(userID, outbreakID): Activate an outbreak given **outbreakID** for user with **userID** ID.

+ api.removeActiveOutbreakFromUser(userID): Remove active outbreak from user given its ID.

+ api.getOutbreakCases(outbreakID): Get cases from outbreak given its ID.

+ api.getOutbreakCase(outbreakID, caseID): Get additional information from a case (give its ID) of an outreak (given its ID).

+ api.createOutbreakCase(outbreakID, case): Create a case from an object associated with an outbreak given its ID.

+ api.deleteOutbreakCase(outbreakID, caseID): Delete a case (given its ID) from an outbreak (given its ID).

## Testing

```{bash}
npm test
```
