

## /foo/bar/file_2019-03-01.xlsx -> file_2019-03-01.xlsx
extract_file_name <- function(x) {
  gsub("^[^.]+/", "", x)
}


## some_file_2019-03-01.xlsx -> some_file_
undated_file_name <- function(x) {
  file_name <- extract_file_name(x)
  sub("[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}[.][[:alpha:]]{3,4}",
      "",
      file_name)
}
