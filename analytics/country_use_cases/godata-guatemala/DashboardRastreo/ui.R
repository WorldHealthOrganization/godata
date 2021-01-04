#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#




# Define UI for application that draws a histogram
shinyUI(dashboardPage(skin = 'blue',
                      dashboardHeader(
                          titleWidth = 260,
                          title = "Rastreo COVID-19"),
                      dashboardSidebar(
                          width = 260,
                          dateRangeInput("fechaReporte", 
                                         "Fechas de reporte por día de creación", 
                                         start = "2020-08-12", 
                                         end = Sys.Date(),
                                         min="2020-08-12", 
                                         max = Sys.Date(),
                                         format = "dd/mm/yyyy", 
                                         language = "es",
                                         separator = "a"),
                          
                          selectInput("DASFilter",
                                      "DAS",
                                      choices = c("TODOS", 
                                                  "ALTA VERAPAZ",
                                                  "BAJA VERAPAZ",
                                                  "CHIMALTENANGO",
                                                  "CHIQUIMULA",
                                                  "EL PROGRESO",
                                                  "ESCUINTLA",
                                                  "GUATEMALA CENTRAL",
                                                  "GUATEMALA NOR-OCCIDENTE",
                                                  "GUATEMALA NOR-ORIENTE",
                                                  "GUATEMALA SUR",
                                                  "HUEHUETENANGO",
                                                  "IXCÁN",
                                                  "IXIL",
                                                  "IZABAL",
                                                  "JALAPA",
                                                  "JUTIAPA",
                                                  "PETÉN NORTE",
                                                  "PETÉN SUR OCCIDENTE",
                                                  "PETÉN SUR ORIENTE",
                                                  "QUETZALTENANGO",
                                                  "QUICHÉ",
                                                  "RETALHULEU",
                                                  "SACATEPÉQUEZ",
                                                  "SAN MARCOS",
                                                  "SANTA ROSA",
                                                  "SOLOLÁ",
                                                  "SUCHITEPÉQUEZ",
                                                  "TOTONICAPÁN",
                                                  "ZACAPA" )
                          ),
                          selectInput("DMSFilter",
                                      "DMS",
                                      choices = 'TODOS'),
                          selectInput("ClasificacionFilter",
                                      "Clasificación de Casos",
                                      choices = c("TODOS",
                                                  'CONFIRMADO',
                                                  'SOSPECHOSO',
                                                  'CONFIRMADO POR NEXO EPIDEMIOLÓGICO')
                          ),
                          sidebarMenu(
                              menuItem("Casos", tabName = "rastreoCase", icon=icon("head-side-virus")),
                              menuItem("Contactos", tabName = "rastreoContact", icon=icon("shield-virus")),
                              menuItem("Reportes", tabName = "reportes", icon=icon("file-alt")),
                              menuItem("Herramientas", tabName = "herramientas", icon=icon("tools"))
                              
                          )
                      ),
                      dashboardBody(
                          tabItems(
                              tabItem(
                                    tabName = "rastreoCase",
                                    h2("Seguimiento de casos"),
                                    fluidRow(
                                        shinydashboard::valueBoxOutput("rastreoCases",width = 3),
                                        shinydashboard::valueBoxOutput("rastreoCasesContactable",width = 3),
                                        shinydashboard::valueBoxOutput("rastreoCasesActive",width = 3),
                                        shinydashboard::valueBoxOutput("rastreoCasesActiveContactable",width = 3)
                                    ),
                                    fluidRow(
                                      shinydashboard::valueBoxOutput("rastreoCasesFromContactsContactable",width = 3),
                                      shinydashboard::valueBoxOutput("rastreoContactsToCases",width = 3),
                                      shinydashboard::valueBoxOutput("rastreoCasesRecuperados",width = 3),
                                      shinydashboard::valueBoxOutput("rastreoContactsCompleto",width = 3)
                                    ),
                                    fluidRow(
                                      box(
                                        width = 12,
                                        title = 'Definiciones',
                                        tags$ul(
                                          tags$li('Contactable: son los casos para los cuáles se tiene un número de teléfono.'),
                                          tags$li('Activo: Bajo seguimiento telefónico/aislamiento domiciliario.'),
                                          tags$li('Recuperado: Ha cumplido con criterios de recuperación.'),
                                          tags$li('Imposible de contactar: número de teléfono equivocado o no contesta ni una llamada (2 intentos, 2 días seguidos).'),
                                          tags$li('Perdido (durante el seguimiento): contesto alguna llamada pero dejo de contestar (2 intentos, 2 días seguidos) o rechaza (pide) que se le deje de dar seguimiento.'),
                                          tags$li('Hospitalizados/fallecidos: Seguimiento domiciliario concluido porque el caso o la familia reporta hospitalización o fallecimiento o el caso es transferido al hospital por los supervisores.'),
                                          tags$li('Concluido por otra razón: Supervisor perfil clínico determina que sintomatología no es COVID-19.')
                                        )
                                        
                                      )
                                    ),
                                    fluidRow(
                                      tabBox(
                                        width = 12, 
                                        tabPanel(
                                          title = 'Casos acumulados por fecha de ingreso a Go.Data',
                                          withLoader(plotlyOutput('rastreoCasesFechaDeNotificacion'), type = 'html', loader = 'loader5')
                                        ),
                                        tabPanel(
                                          title = 'Casos contactables acumulados por fecha de ingreso a Go.Data',
                                          withLoader(plotlyOutput('rastreoCasesContactableFechaDeNotificacion'), type = 'html', loader = 'loader5')
                                        )
                                      )
                                    ),
                                    fluidRow(
                                        tabBox(
                                            width = 6,
                                            tabPanel(
                                                title = 'Casos Acumulados por Sexo',
                                                withLoader(plotlyOutput("rastreoCasesSexo"), type = 'html', loader = 'loader5')
                                            ),
                                            tabPanel(
                                                title = 'Casos Activos por Sexo',
                                                withLoader(plotlyOutput("rastreoCasesActiveSexo"), type = 'html', loader = 'loader5')
                                            )
                                        ),
                                        tabBox(
                                            width = 6,
                                            tabPanel(
                                                title = 'Casos Acumulados por Edad',
                                                withLoader(plotlyOutput("rastreoCasesEdad"), type = 'html', loader = 'loader5')
                                            ),
                                            tabPanel(
                                                title = 'Casos Activos por Edad',
                                                withLoader(plotlyOutput("rastreoCasesActiveEdad"), type = 'html', loader = 'loader5')
                                            )
                                        )
                                    ),
                                    fluidRow(
                                      tabBox(
                                        width = 12,
                                        
                                        tabPanel(
                                          title = 'Casos según su estado de seguimiento DONA',
                                          withLoader(plotlyOutput('rastreoCasesEstadoDeSeguimientoDona'), type = 'html', loader = 'loader5')
                                        ),
                                        tabPanel(
                                          title = 'Casos contactables según su estado de seguimiento DONA',
                                          withLoader(plotlyOutput('rastreoCasesContactableEstadoDeSeguimientoDona'), type = 'html', loader = 'loader5')
                                        ),
                                        tabPanel(
                                          title = 'Casos según su estado de seguimiento',
                                          withLoader(plotlyOutput('rastreoCasesEstadoDeSeguimiento'), type = 'html', loader = 'loader5')
                                        ),
                                        tabPanel(
                                          title = 'Casos contactables según su estado de seguimiento',
                                          withLoader(plotlyOutput('rastreoCasesContactableEstadoDeSeguimiento'), type = 'html', loader = 'loader5')
                                        )
                                      )
                                    )
                                    
                              ),
                              tabItem(tabName = 'rastreoContact',
                                      h2('Contactos en Seguimiento'),
                                      fluidRow(
                                        shinydashboard::valueBoxOutput("rastreoContacts",width = 3),
                                        shinydashboard::valueBoxOutput("rastreoContactsContactable",width = 3),
                                        shinydashboard::valueBoxOutput("rastreoContactsActive",width = 3),
                                        shinydashboard::valueBoxOutput("rastreoContactsActiveContactable",width = 3)
                                      ),
                                      fluidRow(
                                        tabBox(
                                          width = 12,
                                          tabPanel(
                                            title = 'Contactos Acumulados por fecha de notificación',
                                            withLoader(plotlyOutput('rastreoContactsFechaDeNotificacion'), type = 'html', loader = 'loader5')
                                          )
                                        )
                                      ),
                                      fluidRow(
                                        tabBox(
                                          width = 6,
                                          tabPanel(
                                            title = 'Contactos Acumulados por Sexo',
                                            withLoader(plotlyOutput("rastreoContactsSexo"), type = 'html', loader = 'loader5')
                                          ),
                                          tabPanel(
                                            title = 'Contactos Activos por Sexo',
                                            withLoader(plotlyOutput("rastreoContactsActiveSexo"), type = 'html', loader = 'loader5')
                                          )
                                        ),
                                        tabBox(
                                          width = 6,
                                          tabPanel(
                                            title = 'Contactos Acumulados por Edad',
                                            withLoader(plotlyOutput("rastreoContactsEdad"), type = 'html', loader = 'loader5')
                                          ),
                                          tabPanel(
                                            title = 'Contactos Activos por Edad',
                                            withLoader(plotlyOutput("rastreoContactsActiveEdad"), type = 'html', loader = 'loader5')
                                          )
                                        ),
                                        tabBox(
                                          width = 12,
                                          tabPanel(
                                            title = 'Nivel de Riesgo en Contactos',
                                            withLoader(plotlyOutput('rastreoContactsRiesgo'), type = 'html', loader = 'loader5')
                                          )
                                        )
                                      )
                              ),
                              tabItem(
                                tabName = 'reportes',
                                h2('Reportes del plan de rastreo de casos y contactos'),
                                fluidRow(
                                  box(
                                    width = 12,
                                    title = 'Datos Acumulados',
                                    withLoader(dataTableOutput('reporteAcumulado'), type = 'html', loader = 'loader5')
                                  )
                                ),
                                fluidRow(
                                  box(
                                    width = 12,
                                    title = 'Reporte de notificaciones',
                                    withLoader(dataTableOutput('reporteCases'), type = 'html', loader = 'loader5')
                                  )
                                ),
                                fluidRow(
                                  box(
                                    width = 12,
                                    title = 'Reporte de contactos',
                                    withLoader(dataTableOutput('reporteContacts'), type = 'html', loader = 'loader5')
                                  )
                                )
                              ),
                              tabItem(
                                tabName = 'herramientas',
                                h2('Herramientas para supervisores'),
                                box(
                                  numericInput(
                                    "workersNumber",
                                    "Numero de rastreadores",
                                    20,
                                    min = 1,
                                    max = NA,
                                    step = NA,
                                    width = NULL
                                  ),
                                  width = 12,
                                  title = 'Generación de base de datos para manejo de casos de los datos en Go.Data',
                                  # Input: Select a file ----
                                  fileInput("file1", "Escoja archivo CSV",
                                            multiple = FALSE,
                                            accept = c("text/csv",
                                                       "text/comma-separated-values,text/plain",
                                                       ".csv"))
                                ),
                                dataTableOutput('herramientaRastreadores'),
                                # Button
                                downloadButton("downloadData", "Descargar")
                              )
                              
                              #NEXT TAB CONTENT STARTS HERE
                          )
                      ),
                    
))

