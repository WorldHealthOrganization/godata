perc_round <- function(x){round(x,digit = 2)}
## turn a proportion into a percentage with 2 decimal places rounding

prop_to_perc <- function(x, dec = 2) {
  x_no_na <- x[!is.na(x)]
  if (any(x_no_na < 0 | x_no_na >1)) stop("x is not a proportion")
  round(100 * x, dec)
}



## isoyear and week as character
isoweek_char <- function(x) paste0(lubridate::isoyear(x), "_W", sprintf("%02i", lubridate::isoweek(x)))

## first day of week
monday <- function(x) x - lubridate::wday(x, week_start = 1)

## middle day of week
week_center <- function(x) monday(x) + 3


## wrapper for datatable; if params$light is TRUE, then we disable the tables
show_table <- function(x, params = NULL, ...) {
  if (!is.null(params)) {
    if (isTRUE(params$light))  return(NULL)
  }
  ## print(x, ...)
  datatable(x, rownames = FALSE,
            options = list(scrollX = TRUE), ...)
}


## Display percentage with confidence intervals
prop_to_display_ci <- function(x, y, perc = FALSE, dec = 2, sep = "\n"){
  ## if (length(x) != 1) {
  ##   stop("`x` must be a single number")
  ## }
  ## if (length(y) != 1) {
  ##   stop("`y` must be a single number")
  ## }
  if (y[1] == 0) {
    "0 - "
  } 
  else {
    lci    <- prop_ci(x, y, "lower", perc, dec = dec)
    uci    <- prop_ci(x, y, "upper", perc, dec = dec)
    if (perc) {
    x_perc <- prop_to_perc(x / y, dec = dec)
      sprintf("%s%%%s(%s%% ; %s%%)", x_perc, sep, lci, uci)
    } 
    else {
      x_prop <- round(x / y, digits = dec)
      sprintf("%f%s(%f ; %f)", x_prop, sep, lci, uci)
    }  
  }
}




## Display percentage in brackets after numerator
prop_to_display_n <- function(x, y, dec = 2) {
  x_disp <- round(x, dec)
  paste0(x_disp, " (", prop_to_perc(x / y), "%", ")" )
}


kable_tab <- function(x){
  kableExtra::kable(x) %>% 
  kableExtra::kable_styling(bootstrap_options =
                            c("striped", "hover", "condensed", "responsive"))
}


