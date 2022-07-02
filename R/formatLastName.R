# Formats col_name (usually last_name) to similiar format as members$last_name
# Capitalizes letters and fixes common errors
formatLastName <- function(data, col_name){

  data$last_name <- data[[col_name]]

  # trim white space and paragraph breaks
  data$last_name  %<>%
    str_squish() %>%
    # correct capitalization to match last names in voteview data
    # Last names in voteview are upper case
    str_to_upper() %>%
    str_replace_all(" NA ", " ") %>%
    str_replace_all(" NA ", " ") %>%
    str_replace_all(" NA ", " ") %>%
    str_remove_all("^NA | NA$") %>%
    str_remove_all("^NA | NA$") %>%
    # remove anything in parentheses
    str_remove_all("\\(.*\\)") %>%
    str_squish()

  # THIS WILL STAY IN THE FUNCTION formatLastName
  data %<>%
    #case corrections, not touching at the moment
    mutate(last_name = gsub("^MC", replacement = "Mc", last_name)) %>%
    mutate(last_name = gsub("McEACHIN", replacement = "MCEACHIN", last_name, ignore.case = TRUE)) %>%
    mutate(last_name = gsub("DEFAZIO", replacement = "DeFAZIO", last_name, ignore.case = TRUE)) %>%
    mutate(last_name = gsub("DELAURO", replacement = "DeLAURO", last_name)) %>%
    mutate(last_name = gsub("DEMINT", replacement = "DeMINT", last_name)) %>%
    mutate(last_name = gsub("LOBIONDO", replacement = "LoBIONDO", last_name)) %>%
    mutate(last_name = gsub("LATOURETTE", replacement = "LaTOURETTE", last_name)) %>%
    mutate(last_name = gsub("LAHOOD", replacement = "LaHOOD", last_name)) %>%
    mutate(last_name = gsub("DEGETTE", replacement = "DeGETTE", last_name)) %>%
    mutate(last_name = gsub("DELBENE", replacement = "DelBENE", last_name)) %>%
    mutate(last_name = gsub("DESANTIS", replacement = "DeSANTIS", last_name)) %>%
    mutate(last_name = gsub("MACARTHUR", replacement = "MacARTHUR", last_name)) %>%
    mutate(last_name = gsub("LAMALFA", replacement = "LaMALFA", last_name)) %>%

    # Commented this out because we modified the members file instead, but maybe it would better to modify just the search pattern to be Luj.n as a typo
    # FIXED
    # mutate(last_name = ifelse(grepl("Lujan", FROM,ignore.case=TRUE)&grepl("Ben", FROM,ignore.case=TRUE), "LUJÁN", last_name)) %>%
    # mutate(last_name = ifelse( grepl("Lujan",FROM,ignore.case=TRUE)&grepl("Ben",FROM,ignore.case=TRUE), "LUJÁN", last_name)) %>%


    ##############################################################################################################################
  # FIXED
  # All of the below should be corrected with the typos tables (if a typo) or in nameCongress.R (if a name that needs expanding)
  # Spelling and specific corrections

  # FIXED and added names to typo tables
  mutate(last_name = gsub("DENIS", replacement = "DENNIS", last_name)) %>% #fixed
    mutate(last_name = gsub("DUNCAN JOHN.*", replacement = "DUNCAN", last_name)) %>% #fixed
    mutate(last_name = gsub("JOHNSON HENRY.*", replacement = "JOHNSON", last_name)) %>% #fixed
    mutate(last_name = gsub("BONO MACK.*", replacement = "BONO", last_name)) %>% #this should be Mary not Mack #fixed
    mutate(last_name = gsub(".*ROCKEFELLER.*|.*ROCKFELLER.*", replacement = "ROCKEFELLER", last_name)) %>% #fixed
    mutate(last_name = gsub(".*SANDLIN.*", replacement = "HERSETH SANDLIN", last_name)) %>%  #fixed


    mutate(last_name = gsub("MOORE CAPITO.*", replacement = "CAPITO", last_name)) %>% #fixed
    mutate(last_name = ifelse(grepl("Milkulski, Barbara", FROM), "MIKULSKI", last_name)) %>% #fixed
    mutate(last_name = ifelse(grepl("GRESHAM BARRETT", last_name,ignore.case=TRUE), "BARRETT", last_name)) %>% #fixed
    mutate(last_name = ifelse(grepl("Shelley Moore", FROM,ignore.case=TRUE), "CAPITO", last_name)) %>% #fixed
    mutate(last_name = gsub(".*SCHULTZ.*", replacement = "WASSERMAN SCHULTZ", last_name)) %>% #will be fixed below
    mutate(last_name = ifelse( grepl("Jackson",FROM,ignore.case=TRUE)&grepl("She",FROM)&grepl("Lee",FROM), "JACKSON LEE", last_name)) %>% #fixed
    mutate(last_name = ifelse( (grepl("McMorris|Rodgers",FROM,ignore.case=TRUE))&grepl("Cathy|McMorris",FROM), "McMORRIS RODGERS", last_name)) %>% #fixed below
    mutate(last_name = ifelse( grepl("Michael|(^| )K",FROM,ignore.case=TRUE)&grepl("Conaway",FROM,ignore.case=TRUE), "CONAWAY", last_name)) %>% #fixed
    mutate(last_name = ifelse( grepl("Ben",FROM)&grepl("Nelson",FROM), "NELSON", last_name)) %>% #fixed
    mutate(last_name = ifelse( grepl("Beutler",FROM,ignore.case=TRUE)&grepl("Herrera",FROM,ignore.case=TRUE), "HERRERA BEUTLER", last_name)) %>% #fixed
    mutate(last_name = ifelse( grepl("Gillbrand",FROM,ignore.case=TRUE), "GILLIBRAND", last_name)) %>% #fixed
    mutate(last_name = ifelse( grepl("Hillary|Hilary",FROM,ignore.case=TRUE)&grepl("Rodham",FROM), "CLINTON", last_name)) %>% #fixed
    mutate(last_name = ifelse(grepl("Sandlin", FROM,ignore.case=TRUE), "HERSETH SANDLIN", last_name)) %>%  #fixed
    mutate(last_name = ifelse(grepl("Murhpy", FROM,ignore.case=TRUE), "MURPHY", last_name)) %>% #fixed
    #mutate(last_name = ifelse( grepl("Linda",FROM,ignore.case=TRUE)&grepl("Sanchez",FROM,ignore.case=TRUE), "SÁNCHEZ", last_name)) %>% #fixed
    mutate(last_name = ifelse(grepl("Wasserman", FROM,ignore.case=TRUE), "WASSERMAN SCHULTZ", last_name)) %>% #fixed
    mutate(last_name = ifelse(grepl("McMorris", FROM,ignore.case=TRUE), "McMORRIS RODGERS", last_name)) %>% #fixed
    mutate(last_name = ifelse(grepl("ROS-LEHTINEN", FROM ,ignore.case=TRUE), "ROS-LEHTINEN", last_name)) %>% #not an error
    mutate(last_name = ifelse(grepl(".ISCLOSKY", FROM,ignore.case=TRUE), "VISCLOSKY", last_name)) %>% #fixed
    mutate(last_name = ifelse(grepl("Guitierrez", FROM,ignore.case=TRUE), "GUTIERREZ", last_name)) %>% #fixed
    mutate(last_name = ifelse(grepl("Harmon", FROM,ignore.case=TRUE), "HARMAN", last_name)) %>% #fixed
    mutate(last_name = ifelse(grepl("Hollen", FROM,ignore.case=TRUE), "VAN HOLLEN", last_name)) %>% #fixed
    mutate(last_name = ifelse(grepl("Masto", FROM,ignore.case=TRUE), "CORTEZ MASTO", last_name)) %>%  #fixed

    mutate(last_name = ifelse(grepl("Roybal", last_name,ignore.case=TRUE), "ROYBAL-ALLARD", last_name)) %>% #fixed
    mutate(last_name = ifelse(grepl("RAHALL", last_name,ignore.case=TRUE), "RAHALL", last_name)) %>% #fixed
    mutate(last_name = ifelse(grepl("BEUTLER", last_name,ignore.case=TRUE), "HERRERA BEUTLER", last_name)) %>% #fixed
    mutate(last_name = ifelse(grepl("Inholfe|Imhofe|Imholfe|Inhoffe", last_name,ignore.case=TRUE), "INHOFE", last_name)) %>% #fixed
    mutate(last_name = ifelse(grepl("Barrat|Barret", last_name,ignore.case=TRUE), "BARRETT", last_name)) %>%  #fixed
    mutate(last_name = ifelse(grepl("Stebenow", last_name,ignore.case=TRUE), "STABENOW", last_name)) %>% #fixed
    mutate(last_name = ifelse(grepl("C.rdenas", last_name,ignore.case=TRUE), "CARDENAS", last_name)) %>% #fixed
    mutate(last_name = ifelse(grepl("Vel.zquez", last_name,ignore.case=TRUE), "VELAZQUEZ", last_name)) %>% #fixed


    mutate(last_name = gsub("GONZALES", replacement = "GONZALEZ", last_name)) #fixed


  # data %>% filter(str_detect(last_name, "INHOF")) %>% .$last_name



  data$last_name %<>% str_replace(" ,", ", ")
  data$last_name %<>% str_squish()

  return(data$last_name)

}
