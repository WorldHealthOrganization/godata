## Search for a dataset and get the most recent
## Take a pattern which can be a regular expression
## Then checks a file location for the latest version
## This assume that the file are named with a date at the end
## The date should be in the format 'YYYY-MM-DD'
## Example:
## file_location <- here::here('data/clean')
## beni_latest <- get_latest_data('beni', file_location)
## beni_data <- custom_import(beni_latest)

get_latest_data <- function(pattern, path) {
  data_files <- list.files(path, pattern = pattern,
                           recursive = FALSE, 
                           full.names = TRUE)
  if(length(data_files) == 0L){
    msg <- sprintf("No file containing `%s` found in %s",
                   pattern,
                   path)
    stop(msg)
  }
  file_names <- extract_file_name(data_files)
  file_dates <- linelist::guess_dates(file_names)
  latest <- which.max(file_dates)
  out <- data_files[latest]
  out
}
