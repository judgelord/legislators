# This function cleans up text from which member names will be extracted.
# SUCH CODE SHOULD BE CONSOLIDATED HERE
# It is used in extractMemberNames etc. to preprocess text.
cleanFROMcolumn <- function(FROM){

  # remove +
  FROM %<>% str_remove('\\+') %>% str_remove("—")

  # remove common names in quotes
  FROM <- gsub('\\"(Bill|Bobby|Buddy|GT|Buck|Chuck|Hank|Rick|Duke|Randy|Andy)\\"', "", FROM, ignore.case = TRUE)

  # remove common names in parentheses
  FROM <- gsub('\\((Bill|Bobby|Buddy|GT|Buck|Chuck|Hank|Rick|Duke|Randy|Andy)\\)', "", FROM, ignore.case = TRUE)


  # remove paragraph breaks
  FROM %<>% str_replace_all("\n", " ")

  # remove extra white space inside strings
  FROM %<>% str_squish()

  # fix misplaced commas
  #FROM <- gsub("(\\w+) ,(\\w+)|(\\w+) , (\\w+)", "\\1, \\2", FROM)
  FROM  %<>% str_replace_all(" , | ,|,", ", ")

  # remove extra white space inside strings again
  FROM %<>% str_squish()

  # remove
  FROM %<>% str_remove(" Jr\\.| Jr| III| II| Ii| IV| ll| \\(Il\\)|, JR\\.")

  # replace with comma
  FROM %<>% str_replace(pattern = " Jr,| CPA,| M\\.D\\.,| MD,| M\\.C\\.,| P\\.E\\.,| Ii,",
                        replacement = ",")

  # remove paragraph breaks
  FROM %<>% str_replace_all("\n", " ")

  # remove extra white space inside strings again
  FROM %<>% str_squish()

  # Delete titles that appear after a commma
  # FROM %<>% str_replace(", (SEN|Sen)(-|\\b)", ", ")
  #FROM <- gsub(", (REP|Rep)(-|\\b)", ", ", FROM)

  # Replace titles at the beginning of a string or not after a comma
  FROM %<>% str_replace("\\b(SEN|Sen)( |- | - |\\. |\\.)|^S( |- | - |\\. |\\.)",
                        "Senator ")

  FROM %<>% str_replace("\\b(REP|Rep)( |- | - |\\. |\\.)|^R( |- | - |\\. |\\.)|Congressman|Congresswoman",
                        "Representative ")

  # trim down extra spaces
  FROM %<>% str_squish()

  # remove periods
  FROM %<>% str_replace_all("\\.", " ") %>% str_squish()

  #removing double commas
  FROM %<>% str_replace(",+ |, ,", ", ")
  FROM %<>% str_replace(",+ |, ,", ", ")
  FROM %<>% str_replace_all(",,", ",")

  #removing spaces before commas
  FROM %<>% str_replace(" ,", ", ")

  # replace spaces with a single space
  FROM %<>% str_squish()

  return(FROM)
}
