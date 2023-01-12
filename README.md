![](https://github.com/WorldHealthOrganization/godata/blob/master/docs/assets/godata-logo.png)

# Welcome to Go.Data's Documentation Site!
This repostiory serves as an [umbrella documentation site](https://worldhealthorganization.github.io/godata/) to gear users towards existing technical documentation and resources developed by and for Go.Data users worldwide, particularly in the area of Analytics and Interoperability.

You can find all additional repos connected to the Go.Data tool in the overarching WHO Github Repository by filtering for topics = "go-data", as seen [here](https://github.com/WorldHealthOrganization?q=go-data&type=&language=)

## What is Go.Data?
[Go.Data](https://www.who.int/tools/godata) is a software for contact tracing and outbreak response developed by WHO in collaboration with partners in the Global Outbreak Alert and Response Network (GOARN). Go.Data focuses on case and contact data including laboratory data, hospitalizaton and other variables collected through investigation forms that can be configured across settings and disease types. It generates contact follow-up lists and viusalisation of chains of tranmission. It is currently in use in over 60 countries / territories, and in over 80 different institutions at the national or subnational level.

## Components

Go.Data utilizes of the following tools and components:

Tool/Component | Description | Project Repository
--------- | --------- | ---------
Go.Data Installer | Creates installers for various system configurations | [GoDataSource-Installers**](https://github.com/WorldHealthOrganization/GoDataSource-Installers) 
Mobile and Webapp Components | Go.Data outbreak investigation and contract tracing system, both the PC-installable user interface and database parts and the mobile application. | [GoDataSource-MobileApp**](https://github.com/WorldHealthOrganization/GoDataSource-MobileApp)
Push Notification Server | Built using Express 4.x, Parse Dashboard 1.2, Parse Server 3.1 and Node 8.x | [GoDataSource_PushNotificationServer**](https://github.com/WorldHealthOrganization/GoDataSource_PushNotificationServer)
Front End Application | Built with Angular CLI version 7.3.7, using Angular v7.2.11 | [GoDataSource-FrontEnd**](https://github.com/WorldHealthOrganization/GoDataSource-FrontEnd)
Go.Data API | Built using Loopback 3.x using Node 8.x and MongoDb 3.2 | [GoDataSource-API**](https://github.com/WorldHealthOrganization/GoDataSource-API)

 ** _these repositories are currently private and will be made public with time_ 

## In the [*Go.Data Docs Site*](https://worldhealthorganization.github.io/godata/), you can find:

###  Go.Data Analytics Scripts
Example scripts and resources for extracting, cleaning, and running analyses. Output includes dashboards displaying operational performance metrics for contact tracing by contact tracing supervisor and teams. 

### Go.Data Interoperability Use Cases
We've compiled existing integrations that partners and users have developed, and guidances on if you are considering connecting Go.Data to other system(s).

### Go.Data API Documentation
How to work with the Go.Data API, and links to further resources.

# How can I contribute?
We would appreciate your contributions or feedback so that the user base can benefit from your experience. 

If you have a contribution to make, please email godata@who.int to be added to the repository and submit a pull request, including a documentation page on your Use Case for Analytics or Interoperability.

You can also visit our Community of Practice website to swap learnings or post queries at [https://community-godata.who.int/](https://community-godata.who.int/).
