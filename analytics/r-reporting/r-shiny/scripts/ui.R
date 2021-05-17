library(shinydashboard); library(leaflet)

header <- dashboardHeader(
  title = "COVID-19 Summary Dashboard - Shiny V1"
)

sidebar <- dashboardSidebar(
  
  width = 230, 
  
  sidebarMenu(
    
    menuItem("Demographics", icon = icon("bar-chart-o"), startExpanded = TRUE,
             menuSubItem("Case demographics", tabName = "CaseDemographics"),
             menuSubItem("Contact demographics", tabName = "ContactDemographics")),
    
    menuItem("Key Performance Indicators", icon = icon("chart-line"), startExpanded = FALSE,
             menuSubItem("By administrative area", tabName = "KPIByAdmin"),
             menuSubItem("By contact tracer", tabName = "KPIByContactTracer")),

    menuItem("Data Quality", icon = icon("clipboard"), startExpanded = FALSE,
             menuSubItem("Data completion", tabName = "CompletionCases")),
    
    menuItem("Maps", icon = icon("map-marker"), startExpanded = FALSE),

    menuItem("Labs", icon = icon("vial"), startExpanded = FALSE),
    
    menuItem("Users/Administration", icon = icon("globe"), startExpanded = FALSE)
  )
)


body <- dashboardBody(
  
  tabItems(
    
    tabItem(tabName = "CaseDemographics", h2("Case demographics"), width = 24,
            
            fluidRow(
              
                tags$style(HTML(".small-box.bg-green {
                    background-color: #818181 !important;
                }

                                    ")),

              valueBoxOutput("vboxTotalCases", width = 2),
              
              valueBoxOutput("vboxNewCases", width = 2),
              
              # valueBoxOutput("vboxCasesContactList", width = 2),
              
              valueBoxOutput("vboxCasesDiedRecovered", width = 2),
              
              valueBoxOutput("vboxActiveContacts", width = 2),
              
              # valueBoxOutput("vboxNewContacts", width = 2),
              
              valueBoxOutput("vboxContactsFollowed", width = 2),
              
              valueBoxOutput("vboxContactsLost", width = 2)
              
            ),
            
            fluidRow(

              box(title = "Age breakdown of COVID-19 cases by reporting week", 
                  plotOutput("pltCaseAgeBreakdown")),
              
              box(title = "Age/sex pyramid of COVID-19 cases",
                  plotOutput("pltCaseAgeSexPyramid")),
              
              box(title = "Occupational breakdown of COVID-19 cases",
                  plotOutput("pltCaseOccupationPieChart")),
              
              box(title = "Groups of interest among registered cases",
                  plotOutput("pltCaseHighRiskGroups"))
              )),
    
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
    
    tabItem(tabName = "KPIByAdmin", h2("Key performance indicators"), width = 24,
            fluidRow(
              box(title = "Select admin", background = "blue", solidHeader = TRUE,
                  selectInput(inputId = "variable", label = "Admin name:", choices = c("Admin area 1" = "admin_1_name",
                                                                                     "Admin area 2" = "admin_2_name",
                                                                                     "Admin area 3" = "admin_3_name")))),
            fluidRow(
              tableOutput("tblAdminArea"),
              )),
    
    tabItem(tabName = "CompletionCases", h2("Data quality"), width = 24,
            fluidRow(
              
              box(title = "Overall data completion rate across core COVID-19 case variables",
                  plotOutput("pltCompletionCases")),
              
              box(title = "Overall data completion rate across core COVID-19 contact variables", 
                  plotOutput("pltCompletionContacts")),
              
              box(title = "Overall data completion rate across core COVID-19 relationship variables", 
                  plotOutput("pltCompletionRelationships")),
              
              box(title = "Data completion over time", 
                  plotOutput("pltCompletionOverTime")),
              
              ))
  ))

ui <- dashboardPage(
  header = header,
  sidebar = sidebar,
  body = body,
  skin = "blue"
)
