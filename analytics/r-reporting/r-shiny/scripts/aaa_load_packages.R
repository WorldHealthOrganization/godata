## This script loads all required packages, and throws error messages for ones
## that are missing.

required_packages <- c(
  "dplyr",
  "lubridate",
  "here",
  "rio",
  "DT",
  "scales",
  "incidence",
  "epicontacts",
  "distcrete",
  "earlyR",
  "epitrix",
  "projections",
  "janitor",
  "magrittr",
  "kableExtra",
  "ggrepel",
  "ggplot2",
  "tidyverse",
  "plotly",
  "zoo", # rolling operations
  "formattable",
  "tidyr",
  "aweek",
  "stringr",
  "httr",
  "tibble",
  "jsonlite",
  "sqldf"
  
)

available_packages <- .packages(all.available = TRUE)

## load packages
for (i in seq_along(required_packages)) {
  pkg <- required_packages[i]
  if (! pkg %in% available_packages) {
    msg <- sprintf("The package '%s' is not installed - trying to install it...",
                   pkg)
    message(msg)
    suppressWarnings(try(utils::install.packages(pkg)))
    if (! pkg %in% available_packages) {
      msg <- sprintf("Package %s could not be installed :-/",
                     msg)
      warning(msg)
    }
  }
  if (require(pkg, character.only = TRUE)) {
    msg <- sprintf("Package '%s' loaded",
                   pkg)
  }
}

