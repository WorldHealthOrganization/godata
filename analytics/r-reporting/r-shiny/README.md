# RShiny Reference App for Go.Data

Shiny is a useful tool for creating interactive dashboards in R. We've provided a basic template here which can be adapted by you for your country's needs. This Shiny dashboard builds on the [data cleaning tools and HTML dashboard](https://github.com/WorldHealthOrganization/godata/blob/master/analytics/r-reporting/README.md) provided by Go.Data - if you need a refresher, click on the link for more details.

This guide assumes that you:

- Have R installed,
- Have replicated this folder directory to your local machine; and,
- Know how to use the data import and data cleaning scripts.

## Dashboard structure
We have split the project into two files: `ui.R` and `server.R`. 

The `ui.R` (user interface) file tells R how you want the tool to look. This is the script where you add or remove tabs and pages, boxes, plots and text to your user interface. 

The `server.R` file is the engine of the dashboard, where you read in the data, perform analysis and generate plots. Both files are necessary to run your Shiny dashboard - they interact with each other to produce the final output.

### User interface
The `ui.R` file is split into three major components: the header, the sidebar and the body. 

```
ui <- dashboardPage(
  header = header,
  sidebar = sidebar,
  body = body,
  skin = "blue"
)
```

The above piece of code ties these three components together, and allows you to change the overall color.

#### Customising the dashboard appearance
It is also possible to customize the appearance of your Shiny dashboard further by either referencing a CSS script in the `ui.R` file, or using in-line CSS to adjust the appearance of individual objects. For example, the code below changes the color of the header boxes from green to gray:

```
tags$style(HTML(".small-box.bg-green {
    background-color: #818181 !important;
}
                    ")),
```

Detailed information on the use of CSS is outside the scope of this guide. However, for further reading, a useful overview can be found [here](https://shiny.rstudio.com/articles/css.html) and a detailed reference guide is located [here](https://www.w3schools.com/css/).

### Server
The set up chunk at the top of the `server.R` file should be run whenever the data is updated. At all other times, this code can be commented out to improve loading times when running the script. The first two scripts, _01_data_import.api.R_ and _02_clean_data_api.R_, will fetch and clean data from the Go.Data server. The third script _set_variables.R_, loads this data into the Shiny dashboard and sets the global variables used by other dashboard components.

The three types of components in the template include value boxes, plots and interactive tables. These elements sit within the `server <- function(input, output, server){}` function, and are assigned as `output$` objects.

The simple header boxes displayed at the top of the Shiny dashboard are defined within the `server.R` file itself. However, the code for more complex plots and tables are contained within their own scripts.

We'll run through how to add and edit each of dashboard elements - value boxes, plots and interactive tables - in this guide.

## Running the dashboard
To do this, open the `server.R` or the `ui.R` script and press the 'Run App' button on the top right corner of the window. Alternatively, you can hold down Ctrl+Shift+Enter to activate the application.

While the app is running, you'll be unable to run any other code. If you would like to make changes to your scripts, make sure you close the app first.

## Adding and editing dashboard elements

### Value boxes
Having value boxes in the header allows you to see important statistics at a glance, like the total number of confirmed cases, or the number of active contacts. 

These are defined in the `server.R` file like so:

```
output$vboxTotalCases <- renderValueBox({
  valueBox(
    total_cases_reg, 
    "Total confirmed cases", 
    icon = icon("user-plus", lib = "font-awesome"), 
    color = "orange" 
    ) 
})
```
To break each line down further:

- The `total_cases_reg` variable is defined in _set_variables.R_ 
- The caption is "Total confirmed cases" 
- The icon has been sourced from [Font Awesome](https://fontawesome.com/icons?d=gallery&p=2). To change this, find one that you like at the website, and then change `"user-plus"` to the name of your desired icon.
- The color is orange (Shiny has a limited palette - type `?validColors` to see the full list)

To call the value box from the `server.R` file, the `ui.R` file has the following code. You can also specify the width of the element, like so:

```
valueBoxOutput("vboxTotalCases", width = 2),
```

### Plots
Plots are stored in the _scripts_ folder as their own functions. Let's use _fpltCaseAgeBreakdown.R_ as our example here.

Each plot is defined as a named function, which can have a variety of inputs. The input dataframe (in this case, `cases`) is either defined in the _set_variables.R_ script, or called directly from the _data_ folder (using a variable defined as 'casepath' or 'contactpath' for example) like below:

```
fpltCaseAgeBreakdown <- function(casepath){
  
  cases <- readRDS(casepath)
```

Each script typically has a section where the dataframe is then manipulated to produce the plot. These manipulations could include changing the classes of variables, defining factors, or joining databases together.

```
# ==========================================================================================================================
  # Case age breakdown over time
  cases$date_of_reporting <- as.Date(cases$date_of_reporting)
  
  cases_per_week <- cases %>%
    filter(age_class != "unknown") %>%
    mutate(iso_week = isoweek(date_of_reporting)) %>%
    filter(iso_week < database_week & iso_week >= 20) %>% 
    group_by(iso_week) %>%
    summarise(weekly_total = n()) 
  
  cases$age_class_v2 <- fct_collapse(cases$age_class, 
                                     "0-4" = c("0-4"), 
                                     "5-14" = c("5-9", "10-14"), 
                                     "15-39" = c("15-19", "20-29","30-39"), 
                                     "40-64" = c("40-49", "50-59","60-64"), 
                                     "65-79" = c("65-69", "70-74","75-79"),
                                     "80+" = "80+")
  
  case_age_breakdown_over_time <- cases %>%
    mutate(iso_week = isoweek(date_of_reporting)) %>%
    filter(age_class != "unknown",
           iso_week < database_week) %>%
    # iso_week >= (database_week-15)) %>%
    mutate(week_of_reporting = as.Date(cut(date_of_reporting, breaks = "week"))) %>%
    group_by(week_of_reporting, iso_week, age_class_v2) %>%
    summarise(count = n()) %>%
    ungroup() %>%
    inner_join(cases_per_week, by = "iso_week") %>%
    mutate(prop = count/weekly_total*100)
```
You can then call your desired plot, with your preferred graphical options.

```
  ggplot(case_age_breakdown_over_time, aes(x = week_of_reporting, y = count, fill = age_class_v2)) +
    geom_line(size = 1.3) +
    geom_area(aes(fill = age_class_v2), colour = "white") +
    scale_fill_viridis(discrete = T, option = "magma") +
    scale_x_date(date_breaks = "2 weeks",
                 date_labels = "%b %d",
                 limits = c(min(case_age_breakdown_over_time$week_of_reporting), max(case_age_breakdown_over_time$week_of_reporting))) +
    ylim(0,NA) +
    theme_minimal() +
    labs(x = "",
         y = "",
         fill = "Age group",
         # title = "Age breakdown of COVID-19 cases by reporting week",
         subtitle = paste0("n = ", case_unknown_age, " with no age recorded")
    ) + 
    theme(
      legend.title = element_text(size=10, face = "bold"),
      plot.title = element_text(size=12, face = "bold"),
      axis.ticks.y.left = element_line(size = 0.5, colour = "grey"),
      axis.ticks.x = element_blank(),
      axis.title.y = element_text(size = 12),
      axis.text.x = element_text(angle = 45, hjust = 1),
      plot.subtitle = element_text(size=11),
      plot.caption = element_text(size = 8, face = "italic"),
      panel.grid.major.y = element_line(size = 0.2, colour = "grey"),
      panel.grid = element_blank())
}
```

Once you're happy with the plot, you can then call the function in the `server.R` file like so:

```
  output$pltCaseAgeBreakdown <- renderPlot({
    source(here("scripts/fpltCaseAgeBreakdown.R"))
    fpltCaseAgeBreakdown(casepath = here("data/cases_clean.rds"))
  })
```

To break this down line by line:

- We define our plot as an `output$` object, giving it a name that makes sense. In this case I've chosen to call it `output$pltCaseAgeBreakdown`.
- The `renderPlot({})` function tells Shiny that the object is a plot.
- We then `source` the script which contains our function.
- And then we call our function, `fpltCaseAgeBreakdown()` and set our `casepath` variable to point to the correct data file.

The `ui.R` file can then call the `output$` like so:

```
box(title = "Age breakdown of COVID-19 cases by reporting week", 
    plotOutput("pltCaseAgeBreakdown")),
```

We place the plot output `pltCaseAgeBreakdown` into it's own `box()`, with an appropriate title on the page that we want it to appear. 

## Interactive tables
These are built in a way that is quite similar to a plot, except that the input variable for your function is an interactive element. Let's look at _kFPIByAdmin.R_ as an example.

```
fKPIByAdmin <- function(variable = input$variable){
  
  tab_contact_status <- contact_linelist_status %>%
    # filter(!is.na(admin_2_name)) %>%
    group_by(.data[[variable]]) %>%
    summarize(
      total_reg_contacts = n(),
      contact_reg_last7d = sum(date_of_reporting >= prev_7_date),
      contact_reg_prev_last7d = sum(date_of_reporting >= before_prev_7_date & date_of_reporting < prev_7_date), # add perc:change
      total_contacts_became_case = sum(contact_status == "BECAME_CASE"), # % Became case
      total_active_contacts = sum(contact_status == "UNDER_FOLLOW_UP"),
      seen = sum(seen_with_signs + seen_without_signs), # add perc_seen
      # seen_with_signs = sum(seen_with_signs), 
      # seen_without_signs = sum(seen_without_signs),
      # missed = sum(missed),
      # no_action = sum(no_action),
      # second_week = sum(second_week_followup),
      # first_week = sum(first_week_followup),
      lost_to_followup = sum(lost_to_followup), # add perc_seen
      never_seen = sum(never_seen) # add perc_never_seen
    ) %>%
    mutate(
      perc_change_7d_contacts = round((contact_reg_last7d - contact_reg_prev_last7d)/contact_reg_prev_last7d*100,digits=1),
      perc_became_case = round(total_contacts_became_case*100 / total_reg_contacts,digits=1),
      perc_seen = round(seen*100 / total_active_contacts,digits=1),
      perc_not_yet_seen = round(never_seen*100 / total_active_contacts,digits=1),
      perc_lost_to_followup = round(lost_to_followup*100 / total_active_contacts,digits=1)) %>%
    arrange(variable) %>%
    select(
      `Admin` = variable,
      `Total Registered contacts` = total_reg_contacts,
      `% Became case` = perc_became_case,
      `New Contacts, Last 7d` = contact_reg_last7d,
      `% Weekly Change` = perc_change_7d_contacts,
      `Active contacts` = total_active_contacts,
      `% Followed` = perc_seen,
      `% Followed within 48hrs` = perc_seen,
      `% Not yet followed` = perc_not_yet_seen,
      `% Lost to follow up` = perc_lost_to_followup
    ) 
```

Again, we enclose our code as a function. In this case, however, we set a dynamic variable using the `input$` object, allowing it to accept user input from the Shiny interface. As the dataframe (`contact_linelist_status`) has been set globally by the _set_variables.R_ file, and will not be directly manipulated here, we don't need to define the path.

When we manipulate the `tab_contact_status` dataframe here, instead of `group_by(admin_1_name)`, we use `group_by(.data[[variable]])`, which pulls out the column that the user chooses to see (whether that's `admin_1_name`, `admin_2_name` or `admin_3_name`).

We then call the desired kable table and set its appearance with the remaining code:

```
  tab_contact_status %>%
      mutate(
      `Admin` = formatter("span", style = ~ formattable::style(
        color = ifelse(`Admin` == "Non rapporté", "red", "grey"),
        font.weight = "bold",font.style = "italic"))(`Admin`),
      `New Contacts, Last 7d` = color_bar("#79C5FF")(`New Contacts, Last 7d`),
      `% Became case`= color_tile("white", "grey")(`% Became case`),
      `% Lost to follow up`= color_tile("white", "orange")(`% Lost to follow up`),
      `% Followed`= color_tile("white", "#E3FCEE")(`% Followed`), 
      `% Not yet followed`= color_tile("white", "#ff7f7f")(`% Not yet followed`)
    ) %>%
    # select(`Superviseur`, everything()) %>%
    kable("html", escape = F, align =c("l","c","c","c","c","c","c","c","c","c")) %>%
    kable_styling("hover", full_width = FALSE) %>%
    add_header_above(c(" " = 2, 
                       "Contact registration" = 4,
                       "Contact follow-up" = 4))
}
```

The `server.R` file then calls the script like so:

```
output$tblAdminArea <- reactive({
  source(here("scripts/fKPIByAdmin.R"))
  fKPIByAdmin(variable = input$variable)
})
```

We again assign the function to an `output$` object with an appropriate name - in this case `output$tblAdminArea`. 
As this is an interactive table that accepts inputs, we use the `reactive({})` function instead of the `renderPlot({})` function.

The `ui.R` file controls the appearance of the table:

```
fluidRow(
  box(title = "Select admin", background = "blue", solidHeader = TRUE,
      selectInput(inputId = "variable", label = "Admin name:", choices = c("Admin area 1" = "admin_1_name",
                                                                         "Admin area 2" = "admin_2_name",
                                                                         "Admin area 3" = "admin_3_name")))),
fluidRow(
  tableOutput("tblAdminArea"),
  )),
```

Breaking this down line by line:

- The first `fluidRow()` displays the input selector, defined using `selectInput()`. 
- The `inputId` is the name of our variable (in this case, we unimaginatively named it `variable`)
- The `label` just provides some accompanying text
- The `choices` argument gives the displayed text on the left (i.e. 'Admin area 1'), and the possible variable values on the right (`admin_1_name`).
- The second `fluidRow()` displays the actual table output, using the name we assigned our table in `server.R`.

### Display elements

All of our dashboard components need to sit within display elements: like pages, tabs and boxes. These are set in the `ui.R` script.

In the dashboard body, we've defined each page as tab items like so:

```
    tabItem(tabName = "ContactDemographics", h2("Contact demographics"), width = 24,
            
            fluidRow(
              
              box(title = "Age breakdown of COVID-19 contacts by reporting week",
                  plotOutput("pltContactAgeBreakdown")),
              
              box(title = "Age/sex pyramid of COVID-19 contacts",
                  plotOutput("pltContactAgeSexPyramid")),
              
              box(title = "Occupational breakdown of COVID-19 contacts",
                  plotOutput("pltContactOccupationPieChart")),
              
              box(title = "Groups of interest among registered contacts",
                  plotOutput("pltContactHighRiskGroups"))
            )),
```

Where the `tabName` is `"ContactDemographics"`, and the displayed heading is "Contact demographics". Each tab contains `fluidRows` which hold the `boxes` that display our plots and tables. 

The sidebar links to each tab item using menu items, where each `tabName` must be identical to the names defined in the dashboard body.

```
  sidebarMenu(
    
    menuItem("Demographics", icon = icon("bar-chart-o"), startExpanded = TRUE,
             menuSubItem("Case demographics", tabName = "CaseDemographics"),
             menuSubItem("Contact demographics", tabName = "ContactDemographics")),
```

# Further reading
We've started you off with a basic dashboard template. However, there are plenty of exciting ways you can use Shiny to build beautiful, interesting apps! 

For inspiration, see the RStudio Gallery [here](https://shiny.rstudio.com/gallery/) and don't forget to share your ideas or ask questions at the Go.Data Community of Practice [website](https://community-godata.who.int/login).
