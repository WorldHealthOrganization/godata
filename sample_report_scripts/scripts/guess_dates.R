
## Dirty hack to process dates treated as numbers when importing messy dates
## from Excel; this will replace `guess_dates` from `linelist::guess_dates` when
## called directly (but not when called through `clean_dates` or `clean_data`)

## Very important, and sneaky as f**k:
## * Excel's origin is 1900-01-01 (for VHF)
## * google spreadsheet's origin is 1889-12-30 (for MLL)

## Note that even though the MLL is technically saved in Excel, the origin seems
## to be inherited from the google spreadsheet

guess_dates <- function(x, error_tolerance = 1,
                        origin = as.Date("1900-01-01"), ...) {

  x <- as.character(x)

  to_replace <- !is.na(suppressWarnings(as.integer(x)))
  replacement <- lubridate::as_date(
      as.integer(x[to_replace]),
      origin = origin)
  replacement <- as.character(replacement)
  x[to_replace] <- replacement

  linelist::guess_dates(x, error_tolerance = error_tolerance, ...)
}
