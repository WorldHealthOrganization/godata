---
layout: page
parent: Data Visualization
grand_parent: Analytics & Dashboards
title: PowerBI
nav_order: 2
permalink: /power-bi/
---

# Go.Data PowerBI "Starter Kit"
Reference Template
{: .label .label-blue }
We have developed a pre-formatted PowerBI dashboard library that you can connect to your Go.Data instance with a few simple steps. The result includes various epidemiological dashboards adapted specifically for the Go.Data metadata structure, has seen in screenshot below.

![](../assets/powerbi_dash_new.png)

### [View step-by-step directions in the full-length "How-To" manual here](https://github.com/WorldHealthOrganization/godata/blob/master/docs/analytics/2-data-visualization/2B-power-bi/Connecting%20Power%20BI%20to%20GoData%20Manual.pdf)

The first key steps are also listed below.

## Step 1: Download [Microsoft Power BI Desktop](https://www.microsoft.com/en-us/download/details.aspx?id=58494)

## Step 2: Download the [Go.Data PowerBI Dashboard libary](https://github.com/WorldHealthOrganization/godata/blob/master/docs/analytics/2-data-visualization/2B-power-bi/Go-Data%20Epidemiological%20Dashboards_FINAL.pbix)

This is a .pbix file format, which you can double click to open after downloading PowerBI Desktop. The most updated version will always be on our Github repository in the `power-bi` folder as linked above.

## Step 3: Connect to your Go.Data instance 
All dashboard queries are already configured, you simply need to connect it to your Go.Data instance! See steps below:

### Click on the "Transform Data" icon 
![](../assets/powerbi_transform_data.png)

### Update Parameters with your own Go.Data credentials
![](../assets/powerbi_update_parameters.png)
- ***Go.Data Server URL***: The URL of your server where Go.Data is
- ***Email address***: The email address you use to access Go.Data
- ***Password***: The password you use to access Go.Data
- ***Outbreak ID***: This outbreak ID is found when you enter your Go.data installation, go to outbreaks, roll your mouse over the outbreak of interest and select modify. On the URL section, you will see a unique identifier, this is the Outbreak ID that will be used when building your query.

### Click close and apply to save.

If you are encountering problems don't hesitate to reach out at _godata@who.int._


### To access the virtual training hosted by Chile’s MOH on “creating dashboards using Power BI with data collected from Go.Data” please refer to the [Community of Practice](https://community-godata.who.int/conversations/dashboards-and-analysis/godata-implementation-in-chile-training-in-the-development-of-dashboards-in-power-bi-connected-to-godata/621f8a65c838953441d0246e)

