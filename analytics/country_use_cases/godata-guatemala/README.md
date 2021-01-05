<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->

<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="https://extranet.who.int/goarn/sites/default/files/go.data_.png" alt="Logo"  height="80">
  </a>

  <h3 align="center">Go.Data Guatemala</h3>

  <p align="center">
    Transformation, manipulation and visualization of the data of the implementation of GoData in Guatemala for the tracking of COVID-19 cases and contacts.
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About the project</a>
      <ul>
        <li><a href="#developed-with">Developed with</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#use">Use</a>
      <ul>
        <li><a href="#automation-script">Automation script</a></li>
        <li><a href="#dashboard">Dashboard</a></li>
      </ul>
    </li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About the project

[![Product Name Screen Shot][product-screenshot]]()

In Guatemala, a pilot project was carried out to trace at home or by phone of COVID-19 cases and contacts using [Go.Data](https://www.who.int/godata). For contacts, the platform's contact follow-ups section was used. While for the cases, the flexibility of the questionnaires was used to implement the follow-ups strategy.

To analyze and report the results of the project, a dashboard was generated from the information of the cases and contacts. In this dashboard, a reports section was also added to report the results of the project. Finally, a tool was added that helps personnel to assign the cases to follow to the different trackers automatically and summarizes the information necessary to carry out the tracing.

Automating the process of obtaining, transforming and updating data on the dashboard was a must. So a script was generated with all the necessary workflow to run the complete ETL process.

### Developed with

* [R](https://www.r-project.org/)
* [ShinyApps](https://www.shinyapps.io/)
* [shinydashboard](https://rstudio.github.io/shinydashboard/)
* [Go.Data](https://www.who.int/godata)



<!-- GETTING STARTED -->
## Getting started

You must have a Go.Data user with no access restrictions to use the `rastreoConsolidation.R` script in charge of the entire ETL process.

### Prerequisites

* R
  ```sh
  sudo apt-get install r-base
  ```

### Installation

1. Clone the repository
   ```sh
   git clone https://github.com/Oliversinn/godata-guatemala.git
   ```
2. Install R packages
   ```sh
   cd godata-guatemala
   Rscript scripts/installPackages.R
   ```
3. Connect with [ShinyApps](https://shiny.rstudio.com/articles/shinyapps.html)
   ```R
   rsconnect::setAccountInfo(name="<ACCOUNT>", token="<TOKEN>", secret="<SECRET>")
   ```

<!-- USAGE EXAMPLES -->
## Use

### Automation script

The only script to run is the `rastreoConsolidation.R`. In it, you have to configure the IP or domain, user credentials and IDs of the outbreak and language that you want to use from the Go.Data platform. These fields are represented with "xxxxxxxx" when cloning this repository for security. When running this script it downloads the databases and when transforming them, it saves them in `DashboardRastreo/data` so that the dashboard can use them. At the end the scrip publishes the just updated version of the dashboard.

* Run the script
   ```sh
   Rscript scripts/rastreoConsolidation.R > logs/rastreoUpdate-$(date +\%F-\%T).log 2>&1
   ```

Executions of the script generate a log in the `logs/` folder to keep track of the process of each execution. Here's what a successful run looks like:
[![Log][log]]()

### Dashboard

To see how the dashboard works, you can run it by opening it from RStudio or you can run the following command by adding the path to the dashboard `DashboardRastreo`

* Run the dashboard
   ```sh
   R -e "shiny::runApp('path/to/DashboardRastreo')"
   ```

<!-- CONTACT -->
## Contact

[Oliver Mazariegos](https://mazariegos.gt/) - olivera@mazariegos.gt

Repo Link: [https://github.com/Oliversinn/godata-guatemala](https://github.com/Oliversinn/godata-guatemala)

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[product-screenshot]: assets/dashboard.png
[log]: assets/log.png