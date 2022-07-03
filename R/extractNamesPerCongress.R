# A function to map over congresses
# one congress at a time
extractNamesPerCongress <- function(congress_i, data, members = members){

  # subset to one congress
  data %<>% filter(congress == congress_i)

  # search only if that congress exists in data
  # FIXME with purrr error handeling?

  # if congress not in members file
  if(!congress_i %in% members$congress & "DATE" %in% names(data)){

    top5 <- nrow(data)
    if(top5>5){top5<-5}

    ## Message for when errors are probably non-observations (short strings or NA)
    nonobs <- "but empty string, so probably non-observations"

    base::message(red(paste(
      paste0("Bad dates in ", congress_i, "th congress?"),
      paste(data %>%
              mutate(string = ifelse(
                nchar(string <3) |
                  string %in% c("na", "na na", "(b)(6)", "") |
                  is.na(string) |
                  !is.na(ERROR),
                nonobs,
                string) ) %>%
              # group_by(data_id) %>%
              # mutate(data_id = ifelse(string == "but probably non-observations",
              #                          data_id == paste(top_n(1, data_id), "-", top_n(1, desc(data_id)) ),
              #                          data_id) ) %>%
              # ungroup() %>%
              group_by(string) %>%
              mutate(DATE = paste0(unique(DATE), collapse = ", "),
                     row = paste0(unique(data_id), collapse = ";") %>% str_trunc(4+(10*7)+3) ) %>% # "row [first 10 row numbers]..."
              count(DATE, row, string, wt = NULL) %>%
              arrange(row) %>%
              arrange(-n) %>%
              ungroup() %>%
              transmute(strings = paste0("row ", row, ", DATE = ", DATE, " \"", string, "\"")) %>%
              .$strings,
            collapse = "\n"),
      sep = "\n")))

    data %<>%
      mutate(pattern = "Date out of range",
             first_name = NA,
             last_name = NA)
  }

  # if congress in members file
  if(congress_i %in% members$congress){
    members %<>% filter(congress == congress_i)

    base::message( green(str_c("Searching ",  " data for members of the ", congress_i, "th, n = ",
                               nrow(data), " (", length(unique(data$string)), " distinct strings)."#,
                               # broken by dplyr 1.0.0, reverted in and works with 1.0.1
                               #" Most common string: \"", count(data, string) %>% top_n(1, n) %>% .[1,1], "\""
    )
    ))
    #count(data, string)
    #count(data, string) %>% top_n(1, n)
    # match patterns from the members data and merge with member names
    data %<>%
      ungroup() %>%
      # map function to detect members over lower case version of FROM
      mutate(pattern = string %>% purrr::map_chr(extractName,
                                                 data = data,
                                                 members = members) ) %>% # select(from,matches)
      # split out multiple members into separate rows
      mutate(pattern = str_split(pattern, ";")  ) %>%
      unnest()

    suppressMessages(
      data %<>%
        # join in members data by pattern
        left_join(members %>% select(pattern, first_name, last_name, congress) ) %>% #, by = c("pattern", "congress")) %>%
        mutate(first_name = as.character(first_name),
               last_name = as.character(last_name))
    )
  }
  return(data)
}
