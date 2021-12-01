---
layout: page
title: Configuring Reference Data
parent: Data Management
nav_order: 2
permalink: /refdata/
has_children: false
---

# Configuring Reference Data in Go.Data 
Reference Data is cutomizable in Go.Data to allow for flexibility across settings and disease types, in addition to increasing the value of the analytics. Anything with a "dropdown" selector in Go.Data can be configured through Reference Data according to your context. 

![](../assets/ocha_icons.PNG)
![image](https://user-images.githubusercontent.com/57128361/123091316-7ebd1280-d429-11eb-8e94-74435e765ade.png)

This page outlines some things to keep in mind relating to Go.Data Reference Data and highlights tangible examples that can help you during implementation.

## Icon/Color Customization for Reference Data
Editing reference data to include icons and colors is optional but enables greater utility and interpretation of Go.Data Chains of Transmission. You can find more instructions for how to do this in Chapter 19 of [Go.Data User Guide](https://sprcdn-assets.sprinklr.com/1652/254f53e1-35b0-4ca8-8452-99a46c413cab-1176881866.pdf) titled "Managing Reference Data".

Of note, there are excellent open-source health icon libraries, including those developed by [OCHA for Humanitarian Settings](https://brand.unocha.org/d/xEPytAUjC3sH/icons)  and the Resolve to Save Lives [Health Icons Project](https://healthicons.org/). You can view the Health Icons Project's associated Github Repository here: [https://github.com/resolvetosavelives/healthicons](https://github.com/resolvetosavelives/healthicons)

ocha_icons.PNG
![image](https://user-images.githubusercontent.com/57128361/123091573-cf347000-d429-11eb-9171-ee57db7585dd.png)

## Editing Reference Data to better visualize clusters in chains of transmission
Below we will briefly outline a few different ways to view clusters and exposure patterns in Go.Data chains of transmission, in order to give users a better understanding of what could work in their setting.

***OPTION 1: Adding and visualizing clusters via "Cluster" portion of app.***
There are some limitations in how you can visualize clusters if using the current cluster feature.  Because of this, it is not the preferred choice for some, and many are using the other workarounds describe in options 2 and 3 below. We hope to prioritize advancements in cluster feature in future Go.Data versions.

To utilize Clusters in chains of transmission, you must first add relevant clusters. 
This then builds out what will be in the dropdown menu later, when adding a contact or creating an exposure. 
This is the only drop-down in all of Go.Data that works in this way, all others you edit in Reference Data.

![image](https://user-images.githubusercontent.com/57128361/123090091-09047700-d428-11eb-9e41-5a6f7b8a835e.png)

Add all your cases as per usual (manually or import).

Bulk add contacts onto an individual case (rolling mouse over case and clicking on ellipsis button, select bulk add). Unfortunately you cannot add cluster into this bulk import - we have added this feature request but it currently is in the backlog due to other more high priority things.

When you go to add cluster onto an individual contact afterwards (or during, if you are adding them one by one), or in the chain of transmission itself, the cluster you added will now appear in drop-down.

![image](https://user-images.githubusercontent.com/57128361/123090127-14f03900-d428-11eb-840a-3dfad32aad92.png)


The only way view this cluster feature at present in chain of transmission graph - this is under "Edge Display Options". 
This cluster info now will appear as text on the edge. This may not be the most useful way to see the cluster, which is why people have turned to Options 2 and 3 below in some scenarios.

![image](https://user-images.githubusercontent.com/57128361/123090230-34876180-d428-11eb-8b54-c5194653e786.png)

***OPTION 2: Put this cluster info into configurable reference data pertaining to relationship.***
You can also edit relevant reference data (e.g., context of exposure) and change colors and icons to these option sets, which gives us more flexibility with chains of transmission later. These can be as specific as you would need, i.e. a specific place or event....or flight.

 ![image](https://user-images.githubusercontent.com/57128361/123090266-3e10c980-d428-11eb-9344-191689741b26.png)

Then when configuring your chains of transmission graph under "Edge Display Options" you can select “Colour”to be “Context of Exposure”

 ![image](https://user-images.githubusercontent.com/57128361/123090284-42d57d80-d428-11eb-8259-94bdcbb68526.png)


This will color code all arrows based on the Context of Exposure, which looks much nicer than just the text being written on the edge - see below for an example.

 ![image](https://user-images.githubusercontent.com/57128361/123090388-597bd480-d428-11eb-85f6-e2bac7c97579.png)
  

Putting this into something like “case classification” would allow you even more flexibility in terms of changing color or icon of person itself in the chain of transmission, when identified to a given cluster, although this involves changing a pretty standard variable that you may not want to be disaggregated in such a way for other analyses.

***OPTION 3: Classify clusters as "events" – in order to spot them in chain of transmission graph as a different entity entirely.***
You can also opt to create an “event” for a given cluster, and then link cases and contacts in this cluster to this event by adding this as an exposure. Creating the cluster as an event allows it to be viewed as a separate “entity” in the chains of transmission (I.e. cases, contacts and events are the only things that are viewed as discrete points). This allows you to more easily spot the clusters and what contacts and cases may come from them.

See an example below where the different clusters are represented as events, whether a flight, bar, or workplace. This is done in conjunction with the Option 2 color-coding of type of exposure for further clarity.

![image](https://user-images.githubusercontent.com/57128361/123090423-66002d00-d428-11eb-96c5-ba8d3a7eda24.png)

 



