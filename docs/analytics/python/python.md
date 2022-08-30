---
layout: page
title: Python
parent: Analytics & Dashboards
nav_order: 5
permalink: /python/
has_children: false
---

## Dashboard with PandasGUI 
Country use case
{: .label .label-purple }

**Pandas** is an open-source library that is built on top of NumPy library, a Python package that offers various data structures and operations for manipulating numerical data and time series. It is mainly popular for importing and analyzing data much easier. Pandas is fast and it has high-performance & productivity for users.

The team at Canton Vaud, Switzerland developed a Python/Pandas interface for their Go.Data implementation to more easily fetch data from Go.Data and use it as a Pandas dataframe.

See Github directory:[https://github.com/WorldHealthOrganization/pygodata](https://github.com/WorldHealthOrganization/pygodata)

## Python script for data extraction of aggregated and tabular data to Google Sheets
Country use case
{: .label .label-purple }

The team at the Ministry of Health in Kosovo use a Python script to read in Go.Data Cases from the API, perform cleaning/filter operations, aggregate into tables and export to Google Sheets. These aggregated case count tables can then be used for any number of analyses, in your dashboard platform of choice.

See Python script [here](https://github.com/WorldHealthOrganization/godata/blob/master/analytics/country_use_cases/godata-Kosovo/scripts/kosovo_dashboard_data_extraction.py)

## Python script for extracing case export from Go.Data and uploading to SQL Server 
Country use case
{: .label .label-purple }

The team at the University of Texas at Austin created ETL scripts in python to transfer Go.Data cases from one resource to another. One such example script is [`goData_cases_ETL.py`](https://github.com/WorldHealthOrganization/godata/blob/master/analytics/country_use_cases/godata-universityoftexas/goData_cases_ETL.py) which replicates and transfers Go.Data cases from mongoDB to an internal SQL server using `pygodata` for better downstream manipulability.
