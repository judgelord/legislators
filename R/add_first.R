add_first <- function(data){

  twolastnames  <- members %>% group_by(last_name, congress) %>% tally() %>% filter(n>1)  %>% distinct()
  membersOneLastName <- members %>% select(last_name, first_name, congress) %>% anti_join(twolastnames)

  if(!"first_name" %in% names(data)){
    data %<>% left_join(membersOneLastName)
    return(data)
  } else{
    stop("add_first adds a missing first_name column. Rename the existing first_name column or use addFirst() to complete an existing but incomplete first_name columns")
  }
}
