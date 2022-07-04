extractMemberName <- function(data,
                              members = members,
                              col_name,
                              congresses = unique(data$congress) ){

  # provided col name is string to format and extract names from
  data %<>% mutate(string = data[[col_name]])
  # FOR TESTING
  # col_name <- "FROM"

  if("chamber" %in% names(data)){
    # add chamber to string if not NA
    data %<>% mutate(string = ifelse(!is.na(chamber),
                                     paste(chamber, string) %>%
                                       str_replace("House", "Represenative") %>%
                                       str_replace("Senate", "Senator"),
                                     string))

    # drop chamber
    data %<>% select(-chamber)
  }

  if("state_abbrev" %in% names(data)){
    #add state_abbrev to string if not NA
    # FIXME should do the same for "state" (state full names) as well, converting to abbrev
    data %<>% mutate(string = ifelse(!is.na(state_abbrev),
                                     paste(string, "-", state_abbrev),
                                     string))

    # drop state_abbrev
    data %<>% select(-state_abbrev)
  }

  t <- Sys.time()

  # Add Letter ID if missing
  if(!"data_id" %in% names(data)){data$data_id <- 1:nrow(data)}

  data$data_id %<>%
    str_squish() %>%
    as.numeric()

  data$ID <- 1:nrow(data)

  data %<>%
    mutate(data_id = coalesce(data_id, ID) %>% # replace missing with row number
             as.numeric() ) #FIXME add one to make letter id the same as sheet id

  data$data_id %<>%
    formatC(width=6, flag="0", format = "fg")

  # Make missing congress explicit 0 so that it will not be dropped
  data$congress %<>% replace_na(0) %>% as.numeric() %>% replace_na(0) %>% as.numeric()


  # joining with members requires these variables are not there
  data %<>% mutate(last_name = NA,
                   first_name = NA,
                   pattern = NA) %>%
    select(-first_name, -last_name, -pattern)

  # clean up text
  data$string %<>% cleanFROMcolumn()

  # correct common OCR errors
  data$string %<>% ocr.errors()

  # lower case
  data$string %<>% tolower() %>%
    str_replace("senator senator", "senator") %>%
    str_replace("represenative representative", "representative")

  # na's pasted in
  data$string %<>% str_replace("na politano", "napolitano")
  data$string %<>% str_remove("^na ")
  data$string %<>% str_remove("^na ")
  data$string %<>% str_replace("han na\\b", "hanna")
  data$string %<>% str_remove_all("\\bna\\b")

  data$string %<>% str_squish()

  # misplaced commas
  data$string %<>% str_replace(" ,", ", ")

  data$string %<>% str_squish()

  # explicit NA
  data$string %<>% replace_na("")



  # correct typos
  #FIXME with more purrr
  for (i in 1:dim(typos)[1]){
    r <- typos$correct[i]
    p <- typos$typos[i]

    # Fix name typos
    data %<>%
      # find common typos
      mutate(string = string %>% purrr::map_chr(str_replace,
                                                pattern = p,
                                                replacement = r %>% paste("")))
  }

  #FIXME problem created by correcting typos
  data$string %<>% str_replace(" ,", ", ") %>% str_squish()

  base::message(paste("Typos fixed in", round(Sys.time()-t), "seconds"))
  t <- Sys.time()

  # loop over congresses in data
  data <- map_dfr(congresses, extractNamesPerCongress, data = data, members = members) #FIXME members default provided?

  base::message(paste("Names matched in", round(Sys.time()-t), "seconds"))

  data %<>% distinct()

  # New ID since function may split out multiple members if found
  data$ID <- 1:nrow(data) %>% formatC(width=6, flag="0")

  # trying this out adding chamber and state_abbrev from member data becasuse scripts use them post extractmembername sometimes,
  # should not increase n because pattern is already unique to icpsr in a chamber, right?
  data %<>% left_join(members %>% select(icpsr, pattern, bioname, first_name, last_name, congress, chamber, state_abbrev, district_code) %>% distinct() ) %>%
    distinct()

  data$icpsr %<>% as.numeric()

  data %<>% select(data_row_id = data_id, match_id = ID, icpsr, bioname, string, pattern, chamber, congress, everything())

  return(data)
}


