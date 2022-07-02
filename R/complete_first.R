# same as addFirst, but with a better name, keeping the old for posterity, but should replace with this one and make it congress-specific
complete_first <- function(first_name, last_name){

  twolastnames  <- members %>% group_by(last_name, congress) %>% tally() %>% filter(n>1) %>% select(-congress, -n) %>% distinct()
  membersOneLastName <- members[!(members$last_name %in% twolastnames$last_name),]

  i <- 1
  for(i in 1:length(membersOneLastName$id)){
    first_name = ifelse(last_name == membersOneLastName$last_name[i] & is.na(first_name), membersOneLastName$first_name[i],first_name)

  }
  return(first_name)
}
