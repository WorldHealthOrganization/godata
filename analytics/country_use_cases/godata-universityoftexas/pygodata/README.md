# pygodata
`pygodata` is a Python package created by the Dell Medical School at the University of Texas at Austin to better communicate with the Go.Data API. It simply serves as a wrapper to the most frequent API calls we found ourselves using. It includes server authentication using the oauth API route, and uses the generated token to make the various GET, PUT, and POST requests required to maintain our contact tracing database.

## Installation
After downloading the package, `pygodata` is installable via `pip`.
```
pip install pygodata
```

## Use
The `pygodata` class must first be instantiated with a username, password, Go.Data outbreak ID, and base url.
```
from pygodata.pygodata import goData

gd = goData(
        user = 'xxx',       # username 
        password = 'xxx',   # password
        outbreakid= 'xxx',  # Go.Data outbreak ID
        base_url= 'xxx' ,   # Host Go.Data URL
        proxies = 'xxx'     # Proxies, if any. Default is None.
    )
```
Then, API calls can be made through one of the functions in the class. For example, the Go.Data case export.
```
case_export = gd.get_case_export(format = 'json')
```