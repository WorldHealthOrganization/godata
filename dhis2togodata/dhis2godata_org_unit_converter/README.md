# dhis2godata
dhis2 to godata organisation unit converter

###### How to use:

1) **Download dhis2 organisation unit** json files and add them to the input folder (by default "input")
You can add multiple files to convert in the same execution.
If you want to configure a different input/output folder, please change them in config.json configuration file

2) **Check the config file (config.json)**
  - root_level: Define the root org unit level (default: 3)
  - input_dir: Define the input folder (default: input)
  - ouptut_dir: Define the output folder (default: output) 

3) **Run the script**
  - Bat: execute run-dhis2godata.bat
  - Command line: go to the script folder and run "python dhis2godata.py".

4) **Get the files**. They will be generated in the output folder (by default "output")


###### How to download dhis2 formatted org units:
To download the dhis2 OU json files you can use the API:

1) If you know the UID in DHIS2 of the country, you can e.g. filter by path entering the following URL in your browser and saving the result as a file in your computer
<INSTANCE-URL>/api/organisationUnits/<UID>.json?fields=name,id,level,coordinates,featureType,code,parent,children[id]&paging=false&includeDescendants=true
(replace <INSTANCE-URL> by your instance URL and <UID> by the OU UID)

2) If you don't know the UID of the OU, you can find it by using the following URL in your browser:
<INSTANCE-URL>/api/organisationUnits.json/filter=name:ilike:<NAME>
(replace <INSTANCE-URL> by your instance URL and <NAME> by the name of the OU you would like to find out its UID)

The answer would be similar to the following:
```
{
  pager: {
    page: 1,
    pageCount: 1,
    total: 1,
    pageSize: 50
  },
  organisationUnits: [
  {
    id: "DVnpk4xiXGJ",
    displayName: "Kingdom of Spain"
  }
  ]
}
```

The UID will appear as the value for the "id" key in the response from the server for the desired entry. 

In this example, when looking for Spain OU tree in DEV instance we would run the following: 
https://extranet.who.int/dhis2-dev/api/organisationUnits.json?filter=name:ilike:spain

...that will give us the UID: DVnpk4xiXGJ...

...and then we will execute the final query...

https://extranet.who.int/dhis2-dev/api/organisationUnits/DVnpk4xiXGJ.json?fields=name,id,level,coordinates,featureType,code,parent,children[id]&paging=false&includeDescendants=true

*Requirements:*

Python 3
- To install python download the appropriate package to your Operating System from the following link: https://www.python.org/downloads/release/python-382/

