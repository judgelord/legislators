# A function to map over members
# (assumes that memmbers object contains congress and pattern)
# (assumes that data contains congress and string)
extractName <- function(string, members){
  pattern <- purrr::map(.x = members %>% select(pattern),
                        .f = str_detect_replace,
                        string_to_search = string) %>%
    unlist() %>%
    unique() %>%
    str_c(collapse = ";") %>%
    str_remove(";404error|404error;")

  return(pattern)
}

.extractName <- function(string, members){

  pattern <- purrr::map(.x = members %>% select(pattern),
                        .f = str_detect_replace,
                        string_to_search = string) %>%
    unlist() %>%
    unique() %>%
    str_c(collapse = ";") %>%
    str_remove(";404error|404error;")

  return(pattern)
}
