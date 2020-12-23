# packages for this script
packages = c('rsconnect',"httr","xml2","readr","data.table","dplyr","jsonlite","magrittr","sqldf",'tidyr','rsconnect', 'shiny','shinydashboard','shinycustomloader','ggplot2','plotly','tidyr','dplyr','readr','kableExtra','tibble','janitor','caTools','DT','RColorBrewer','leaflet','sf','htmltools','scales','lubridate','forcats','zoo','stringr','writexl','data.table')
# check if packages are installed
package.check = lapply(
  packages,
  FUN = function(x) {
    if (! suppressMessages(require(x,character.only = TRUE))) {
      install.packages(x, dependencies = TRUE)
      suppressMessages(library(x, character.only = TRUE))
    }
  }
)