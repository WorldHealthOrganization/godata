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
![powerbi-1-cases](../assets/powerbi_dash1_cases.png)

## Step 1: Download Microsoft Power BI Desktop 

https://www.microsoft.com/en-us/download/details.aspx?id=58494 

## Step 2: Connect your Go.Data instance to the Go.Data PowerBI dashboard library  

### Download and open the Go.Data PowerBI dashboard library by navigating to the ***.pbix file*** [here](https://github.com/WorldHealthOrganization/godata/blob/master/docs/analytics/2-dashboards/2B-power-bi/Go-Data%20Epidemiological%20Dashboards.pbix)

### Click on the "Transform Data" icon 
![](../assets/powerbi_transform_data.png)

### Update Parameters with your own Go.Data credentials
![](../assets/powerbi_update_parameters.png)
- Go.Data Server URL: The URL of your server where Go.Data is
- Email address: The email address you use to access Go.Data
- Password: The password you use to access Go.Data
- Outbreak ID: This outbreak ID is found when you enter your Go.data installation, go to outbreaks, roll your mouse over the outbreak of interest and select modify. On the URL section, you will see a unique identifier, this is the Outbreak ID that will be used when building your query.

Click close and apply to save.

