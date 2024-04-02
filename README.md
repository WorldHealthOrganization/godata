![](https://github.com/WorldHealthOrganization/godata/blob/master/docs/assets/godata-logo.png)

# Welcome to the Go.Data Site! 

This repostiory serves as an [umbrella site](https://worldhealthorganization.github.io/godata/) to gear the community towards existing technical documentation, resources, and open source components developed by and for the Go.Data community worldwide, particularly in the area of Analytics and Interoperability.

You can find all additional repos connected to the Go.Data tool in the overarching WHO Github Repository by filtering for topics = "go-data", as seen [here](https://github.com/WorldHealthOrganization?q=go-data&type=&language=)

## What is Go.Data? 

[Go.Data](https://www.who.int/tools/godata) is a software for contact tracing and outbreak response developed by WHO in collaboration with partners in the Global Outbreak Alert and Response Network (GOARN). Go.Data focuses on case and contact data including laboratory data, hospitalizaton and other variables collected through investigation forms that can be configured across settings and disease types. It generates contact follow-up lists and viusalisation of chains of tranmission. It is currently in use in over 60 countries / territories, and in over 80 different institutions at the national or subnational level.

## Components

Go.Data utilizes of the following tools and components:

Tool/Component | Description | Project Repository
--------- | --------- | ---------
Go.Data Installer | Creates installers for various system configurations | [GoDataSource-Installers**](https://github.com/WorldHealthOrganization/GoDataSource-Installers) 
Mobile App |  IOS and Android applications of Go.Data. | [GoDataSource-MobileApp**](https://github.com/WorldHealthOrganization/GoDataSource-MobileApp)
Push Notification Server | For wiping data from mobile devices. The feature can only be accessed if the required permissions are enabled. | [GoDataSource_PushNotificationServer**](https://github.com/WorldHealthOrganization/GoDataSource_PushNotificationServer)
Front End Application | The web user interface part of Go.Data. | [GoDataSource-FrontEnd**](https://github.com/WorldHealthOrganization/GoDataSource-FrontEnd)
Go.Data API | The backend of Go.Data that connects to the database, retrieves data etc.  | [GoDataSource-API**](https://github.com/WorldHealthOrganization/GoDataSource-API)

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

# Terms of Use

Please read these Terms of Use and Software License Agreement (the “**Agreement**”) carefully before installing the Go.Data Software (the “**Software**”).

By installing and/or using the Software, you (the “**Licensee**”) accept all terms, conditions, and requirements of the Agreement. 

## 1. Components of the Software

The Software is a product published by WHO (the “**Software**”) and enables you to input, upload and view your data (the “**Data**”). 

This Agreement governs your use of the Software you have downloaded.


## 2. Third-party software

#### 2.1. Third-party software embedded in the Software.

The Software contains third party open source software components, issued under various open source licenses:

- 0BSD
- AFL-2.1
- BSD-3-Clause
- BSD-2-Clause
- BSD-3-Clause-Clear
- Apache-2.0
- MIT
- MIT-0
- MPL-2.0
- CC-BY-3.0
- CC-BY-4.0
- CC0-1.0
- ISC
- Unlicense
- WTFPL
- AGPL-3.0
- Python-2.0
- BlueOak-1.0.0
- Artistic-2.0
- Zlib
- Ruby

The text of the respective licenses can be found in Annex 2.

#### 2.2. WHO disclaimers for third-party software.

WHO makes no warranties whatsoever, and specifically disclaims any and all warranties, express or implied, that either of the third-party components are free of defects, virus free, able to operate on an uninterrupted basis, merchantable, fit for a particular purpose, accurate, non-infringing or appropriate for your technical system.

#### 2.3. No WHO endorsement of third-party software.

The use of the third-party Components or other third-party software does not imply that these products are endorsed or recommended by WHO in preference to others of a similar nature.

## 3. License and Terms of Use for the Software 

#### Copyright and license. 

The Software is copyright (©) World Health Organization, 2018, and is distributed under the terms of the GNU General Public License version 3 (GPL-3.0). The full license text of the GNU GPL-3.0 can be found below in Annex 1.

## 4. Copyright, Disclaimer and Terms of Use for the Maps 

#### 4.1. 

The boundaries and names shown and the designations used on the maps [embedded in the Software] (the “**Maps**”) do not imply the expression of any opinion whatsoever on the part of WHO concerning the legal status of any country, territory, city or area or of its authorities, or concerning the delimitation of its frontiers or boundaries. Dotted and dashed lines on maps represent approximate border lines for which there may not yet be full agreement. 

#### 4.2. 

Unlike the Software, WHO is not publishing the Maps under the terms of the GNU GPL-3.0. The Maps are not based on “R”, they are an independent and separate work from the Software, and not intended to be distributed as “part of a whole” with the Software.

## 5. Acknowledgment and Use of WHO Name and Emblem

You shall not state or imply that results from the Software are WHO’s products, opinion, or statements. Further, you shall not (i) in connection with your use of the Software, state or imply that WHO endorses or is affiliated with you or your use of the Software, the Software, the Maps, or that WHO endorses any entity, organization, company, or product, or (ii) use the name or emblem of WHO in any way. All requests to use the WHO name and/or emblem require advance written approval of WHO.

## 6. Dispute Resolution

Any matter relating to the interpretation or application of this Agreement which is not covered by its terms shall be resolved by reference to Swiss law. Any dispute relating to the interpretation or application of this Agreement shall, unless amicably settled, be subject to conciliation. In the event of failure of the latter, the dispute shall be settled by arbitration. The arbitration shall be conducted in accordance with the modalities to be agreed upon by the parties or, in the absence of agreement, in accordance with the UNCITRAL Arbitration Rules. The parties shall accept the arbitral award as final.

## 7. Privileges and Immunities of WHO

Nothing contained herein or in any license or terms of use related to the subject matter herein (including, without limitation, the GNU General Public License version 3 mentioned in paragraph 3.1 above) shall be construed as a waiver of any of the privileges and immunities enjoyed by the World Health Organization under national or international law, and/or as submitting the World Health Organization to any national jurisdiction.

Annex 1

- [GNU General Public License Version 3, 29 June 2007](LICENSE)

Annex 2

- [0BSD](https://opensource.org/license/0bsd)
- [AFL-2.1](https://spdx.org/licenses/AFL-2.1.html)
- [BSD-3-Clause](https://opensource.org/license/bsd-3-clause)
- [BSD-2-Clause](https://opensource.org/license/bsd-2-clause)
- [BSD-3-Clause-Clear](https://spdx.org/licenses/BSD-3-Clause-Clear.html)
- [Apache-2.0](https://opensource.org/license/apache-2-0)
- [MIT](https://opensource.org/license/mit)
- [MIT-0](https://opensource.org/license/mit-0)
- [MPL-2.0](https://opensource.org/license/mpl-2-0)
- [CC-BY-3.0](https://creativecommons.org/licenses/by/3.0/legalcode.en)
- [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/legalcode.en)
- [CC0-1.0](https://creativecommons.org/publicdomain/zero/1.0/legalcode.en)
- [ISC](https://opensource.org/license/isc-license-txt)
- [Unlicense](https://opensource.org/license/unlicense)
- [WTFPL](http://www.wtfpl.net/about/)
- [AGPL-3.0](https://opensource.org/license/agpl-v3)
- [Python-2.0](https://www.python.org/download/releases/2.0/)
- [BlueOak-1.0.0](https://opensource.org/license/blue-oak-model-license)
- [Artistic-2.0](https://opensource.org/license/artistic-2-0)
- [Zlib](https://opensource.org/license/zlib)
- [Ruby](https://spdx.org/licenses/Ruby.html)