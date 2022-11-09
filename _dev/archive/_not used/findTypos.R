findTypos <- function(string){
  purrr::map(.x = typos$typos,
             .f= str_detect_replace,
             string_to_search = string) %>%
    unlist() %>%
    unique() %>%
    # seperate pattrns found with OR
    #str_c(collapse = "|") %>%
    # remove 404error when it appears along side a found pattern
    str_remove("\\|404error|404error\\|") %>%
    str_replace(" ,", ", ") %>%
    str_squish()

}
