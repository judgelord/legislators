# Formats col_name (usually first_name) to similiar format as members$first_name
# Capitalizes letters appropriately and fixes common errors
formatFirstName <- function(data, col_name){

  data$first_name <- data[[col_name]]

  data %<>%
    # In voteview, first names are title case
    mutate(first_name = stri_trans_totitle(first_name))

  ##############################################################################################################################
  # FIXED
  # All of the below should be corrected with the typos tables (if a typo) or in nameCongress.R (if a name that needs expanding)
  # Spelling and specific corrections
  data %<>%
    mutate(first_name = ifelse( grepl("Don",FROM,ignore.case=TRUE)&grepl("Young",FROM,ignore.case=TRUE), "Donald", first_name)) %>% #fixed in namecongress
    #mutate(first_name = ifelse( grepl("Andr",FROM,ignore.case=TRUE)&grepl("Carson",FROM,ignore.case=TRUE), "André", first_name)) %>% #fixed
    mutate(first_name = ifelse( grepl("John",FROM,ignore.case=TRUE)&grepl("Thune",FROM,ignore.case=TRUE), "John", first_name)) %>% #no error
    mutate(first_name = ifelse( grepl("John",FROM,ignore.case=TRUE)&grepl("Rockefeller",FROM,ignore.case=TRUE), "John", first_name)) %>%#no error
    mutate(first_name = ifelse( grepl("Harold",FROM,ignore.case=TRUE)&grepl("Rogers",FROM,ignore.case=TRUE), "Harold", first_name)) %>% #no error

    mutate(first_name = ifelse( grepl("James",FROM,ignore.case=TRUE)&grepl("Sensenbrenner",FROM,ignore.case=TRUE), "James", first_name)) %>% #no error
    mutate(first_name = ifelse( grepl("Richard",FROM,ignore.case=TRUE)&grepl("Blumenthal",FROM,ignore.case=TRUE), "Richard", first_name)) %>% #no error
    mutate(first_name = ifelse( grepl("Bill",FROM,ignore.case=TRUE)&grepl("Nelson",FROM,ignore.case=TRUE), "Clarence", first_name)) %>% #fixed in namecongress
    mutate(first_name = ifelse( grepl("Fred",FROM,ignore.case=TRUE)&grepl("Upton",FROM,ignore.case=TRUE), "Frederick", first_name)) %>% #fixed in namecongress
    mutate(first_name = ifelse( grepl("Thad",FROM,ignore.case=TRUE)&grepl("Cochran",FROM,ignore.case=TRUE), "William", first_name)) %>% #fixed in namecongress
    mutate(first_name = ifelse( grepl("Kristen",FROM,ignore.case=TRUE)&grepl("Gillibrand",FROM,ignore.case=TRUE), "Kirsten", first_name)) %>% #fixed
    mutate(first_name = ifelse( grepl("C",FROM,ignore.case=TRUE)&grepl("Ruppersberger",FROM,ignore.case=TRUE), "Dutch", first_name)) %>% #fixed
    mutate(first_name = ifelse( grepl("Paul",FROM,ignore.case=TRUE)&grepl("Gosar",FROM,ignore.case=TRUE), "Paul", first_name)) %>% #fixed
    mutate(first_name = ifelse( grepl("Ros-Lehtinen",FROM,ignore.case=TRUE), "Ileana", first_name)) %>% #no error
    mutate(first_name = ifelse( grepl("Beutler",FROM,ignore.case=TRUE)&grepl("Herrera",FROM,ignore.case=TRUE), "Jaime", first_name)) %>% #fixed
    mutate(first_name = ifelse( grepl("Will|Bill",FROM,ignore.case=TRUE)&grepl("Owens",FROM,ignore.case=TRUE), "William", first_name)) %>% #fixed
    mutate(first_name = ifelse( grepl("Butterfield",FROM,ignore.case=TRUE)&grepl("G",FROM,ignore.case=TRUE), "George", first_name)) %>% #fixed
    mutate(first_name = ifelse( grepl("G. K.",FROM,ignore.case=TRUE), "G.K.", first_name)) %>% #fixed
    mutate(first_name = ifelse( grepl("Nelson",FROM,ignore.case=TRUE)&grepl("Ben",FROM,ignore.case=TRUE), "Earl", first_name)) %>% #fixed in namecongress
    #mutate(first_name = ifelse( grepl("Carson",FROM,ignore.case=TRUE)&grepl("Andr",FROM,ignore.case=TRUE), "André", first_name)) %>% #fixed
    #mutate(first_name = ifelse( grepl("Griv",FROM,ignore.case=TRUE)&grepl("Raul",FROM,ignore.case=TRUE), "Raúl", first_name)) %>%
    mutate(first_name = ifelse( grepl("Scott",FROM,ignore.case=TRUE)&grepl("Bobby",FROM,ignore.case=TRUE), "Bob", first_name)) %>% #fixed


    mutate(first_name = ifelse( grepl("Young",FROM,ignore.case=TRUE)&grepl("C.W|C. W|CW",FROM,ignore.case=TRUE), "Charles", first_name)) %>%  #fixed
    mutate(first_name = ifelse( grepl("Jackson",FROM,ignore.case=TRUE)&grepl("She",FROM)&grepl("Lee",FROM,ignore.case=TRUE), "Sheila", first_name)) %>% #fixed
    mutate(first_name = ifelse( grepl("Gresham",FROM,ignore.case=TRUE)&grepl("Barrett",FROM,ignore.case=TRUE), "James", first_name)) %>% #fixed
    mutate(first_name = ifelse( grepl("Putnam",FROM,ignore.case=TRUE)&grepl("Ad",FROM,ignore.case=TRUE), "Adam", first_name)) %>% #no error
    mutate(first_name = ifelse( grepl("Lind",FROM,ignore.case=TRUE)&grepl("Graham",FROM,ignore.case=TRUE), "Lindsey", first_name)) %>% #no error
    mutate(first_name = ifelse( grepl("SERRANO",FROM,ignore.case=TRUE)&grepl("Jos",FROM,ignore.case=TRUE), "Jose", first_name)) %>% #fixed

    mutate(first_name = gsub(pattern = "Christoher", replacement = "Christopher", first_name,ignore.case=TRUE)) %>% #fixed
    mutate(first_name = gsub(pattern = "Hilllary|Hilary|Fillary", replacement = "Hillary", first_name,ignore.case=TRUE)) %>% #fixed
    mutate(first_name = gsub(pattern = "Babara", replacement = "Barbara", first_name,ignore.case=TRUE)) %>% #fixed
    mutate(first_name = gsub(pattern = "Colin", replacement = "Collin", first_name,ignore.case=TRUE)) %>% #fixed
    mutate(first_name = gsub(pattern = "Melisssa", replacement = "Melissa", first_name,ignore.case=TRUE)) %>% #fixed
    mutate(first_name = gsub(pattern = "Denis", replacement = "Dennis", first_name,ignore.case=TRUE)) %>% #fixed
    mutate(first_name = gsub("Eliott", replacement = "Eliot", first_name)) %>% #fixed
    mutate(first_name = gsub("Brain", replacement = "Brian", first_name)) %>% #fixed

    mutate(first_name = gsub("Duncan John.*", replacement = "John", first_name)) %>% #fixed
    mutate(first_name = gsub("Johnson Henry.*", replacement = "Henry", first_name)) #fixed

  data$first_name %<>% trimws()
  data$first_name <- gsub("(^ |^  |^   |\n)", "", data$first_name)

  return(data$first_name)

}
