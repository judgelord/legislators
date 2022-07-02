# A helper function to return the full regex pattern string (so that we can join on pattern) where it finds a match
str_detect_replace <- function(string_to_search, pattern){
  out <- ifelse(str_detect(string_to_search, pattern), pattern, "404error")
  out %<>% str_squish()
  return(out)
}
