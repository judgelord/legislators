ocr.errors <- function(FROM){

  # adds deleted "ll" to last names
  #CAN EDIT HERE
  FROM <- gsub("Hiary", "Hillary", FROM)
  FROM <- gsub("(^| )Dinge($| )", "\\1Dingell\\2", FROM)
  FROM <- gsub("Connoy", "Connolly", FROM)
  FROM <- gsub("(^| )Russe($| )", "\\1Russell\\2", FROM)
  FROM <- gsub("(^| )Swalwe($| )", "\\1Swalwell\\2", FROM)
  FROM <- gsub("Cheie", "Chellie", FROM)
  FROM <- gsub("(^| )Uda($| )", "\\1Udall\\2", FROM)
  FROM <- gsub("(^| )Wooda($| )", "\\1Woodall\\2", FROM)
  # FROM <- gsub("Marsha$", "Marshall", FROM)
  FROM <- gsub("Wiiam", "William", FROM)
  FROM <- gsub("(^| )Cantwe($| )", "\\1Cantwell\\2", FROM)
  FROM <- gsub("Mier$", "Miller", FROM)
  FROM <- gsub("Way$", "Wally", FROM)
  FROM <- gsub("Aen$", "Allen", FROM)
  FROM <- gsub("(^| )Bi($| )", "\\1Bill\\2", FROM)
  FROM <- gsub("Coins", "Collins", FROM)
  FROM <- gsub("Paone|Pal lone", "Pallone", FROM)
  FROM <- gsub("(^| )Campbe($| )", "\\1Campell\\2", FROM)
  FROM <- gsub("Hoen", "Hollen", FROM)
  FROM <- gsub("(^| )Darre($| )", "\\1Darrell\\2", FROM)
  FROM <- gsub("Gaegly", "Gallegly", FROM)
  FROM <- gsub("Giibrand", "Gillibrand", FROM)
  FROM <- gsub("(^| )McConne( |$)", "\\1McConnell\\2", FROM, ignore.case = TRUE)
  FROM <- gsub("(^| )Ayson", "\\1Allyson", FROM)
  FROM <- gsub("Keer($| |,)", "Keller\\1", FROM)
  FROM <- gsub("(^| )Een($| )", "\\1Ellen\\2", FROM)
  FROM <- gsub("Roybal-Aard", "Roybal-Allard", FROM)
  FROM <- gsub("Cuear($| |,)", "Cuellar\\1", FROM)
  FROM <- gsub("Pascre($| |,)", "Pascrell\\1", FROM)
  FROM <- gsub("Pa one", "Pallone", FROM)
  FROM <- gsub("Gabriee", "Gabrielle", FROM)
  FROM <- gsub("(^| )Aard", "\\1Allard", FROM)
  FROM <- gsub("McCoum", "McCollum", FROM, ignore.case = TRUE)
  FROM <- gsub("(^| )Eison( |$)", "\\1Ellison\\2", FROM)
  FROM <- gsub("(^| )Weer( |$)", "\\1Weller\\2", FROM)
  FROM <- gsub("Rockefeer", "Rockefeller", FROM)
  FROM <- gsub("(^| )Suivan( |$)", "\\1Sullivan\\2", FROM)
  FROM <- gsub("(^| )Tiis( |$)", "\\1Tillis\\2", FROM)
  FROM <- gsub("(^| )McCaski( |$)", "\\1McCaskill\\2", FROM)
  FROM <- gsub("(^| )Espaiat( |$)", "\\1Espalliat\\2", FROM)
  FROM <- gsub("(^| )Costeo( |$)", "\\1Costello\\2", FROM)
  FROM <- gsub("(^| )Hi( |$)", "\\1Hill\\2", FROM)
  FROM <- gsub("(^| )Gaego( |$)", "\\1Gallego\\2", FROM)
  FROM <- gsub("(^| )McSay( |$)", "\\1McSally\\2", FROM, ignore.case = TRUE)
  FROM <- gsub("(^| )Muin( |$)", "\\1Mullin\\2", FROM)
  FROM <- gsub("(^| )Ciciin.( |$)", "\\1Cicilline\\2", FROM)
  FROM <- gsub("(^| )Sewe( |$)", "\\1Sewell\\2", FROM)
  FROM <- gsub("(^| )Heer( |$)", "\\1Heller\\2", FROM)
  FROM <- gsub("(^| )Rige( |$)", "\\1Rigell\\2", FROM)
  FROM <- gsub("(^| )Emers( |$)", "\\1Ellmers\\2", FROM)
  FROM <- gsub("(^| )Mier( |$)", "\\1Miller\\2", FROM)
  FROM <- gsub("(^| )Ha( |$)", "\\1Hall\\2", FROM)
  FROM <- gsub("(^| )McAISTER( |$)", "\\1McAllister\\2", FROM, ignore.case = TRUE)
  FROM <- gsub("(^| )Boswe( |$)", "\\1Boswell\\2", FROM)
  FROM <- gsub("(^| )Manzuo( |$)", "\\1Manzullo\\2", FROM)
  FROM <- gsub("(^| )Schiing( |$)", "\\1Shilling\\2", FROM)
  FROM <- gsub("(^| )Kisse( |$)", "\\1Kissell\\2", FROM)
  FROM <- gsub("(^| )Hoingsworth( |$)", "\\1Hollingsworth\\2", FROM)
  FROM <- gsub("(^| )Gaagher( |$)", "\\1Gallagher\\2", FROM)
  FROM <- gsub("(^| )Joy( |$)", "\\1Jolly\\2", FROM)
  FROM <- gsub("(^| )Raha( |$)", "\\1Rahall\\2", FROM)
  FROM <- gsub("(^| )Boswe( |$)", "\\1Boswell\\2", FROM)
  FROM <- gsub("(^| )Perrieo( |$)", "\\1Perriello\\2", FROM)
  FROM <- gsub("(^| )Fain( |$)", "\\1Fallin\\2", FROM)
  FROM <- gsub("(^| )Esworth( |$)", "\\1Ellsworth\\2", FROM)
  FROM <- gsub("(^| )Moohan( |$)", "\\1Mollohan\\2", FROM)
  FROM <- gsub("(^| )Fossea( |$)", "\\1Fossella\\2", FROM)
  FROM <- gsub("(^| )Miender-McDonald( |$)", "\\1Millender-McDonald\\2", FROM, ignore.case = TRUE)
  FROM <- gsub("(^| )Knoenberg( |$)", "\\1Knollenberg\\2", FROM)
  FROM <- gsub("(^| )Gimor( |$)", "\\1Gillmor\\2", FROM)
  FROM <- gsub("(^| )Jewe( |$)", "\\1Jewell\\2", FROM)
  # add 'll' to first names
  FROM <- gsub("(^| )oyd( |$)", "\\1Lloyd\\2", FROM)
  FROM <- gsub("(^| )Lucie( |$)", "\\1Lucille\\2", FROM)
  FROM <- gsub("(^| )Michee( |$)", "\\1Michelle\\2", FROM)
  FROM <- gsub("(^| )Bi( |$)", "\\1Bill\\2", FROM)
  FROM <- gsub("(^| )Biy( |$)", "\\1Billy\\2", FROM)
  FROM <- gsub("(^| )Coeen( |$)", "\\1Colleen\\2", FROM)
  FROM <- gsub("(^| )Cheie( |$)", "\\1Chellie\\2", FROM)
  FROM <- gsub("(^| )Sheey( |$)", "\\1Shelley\\2", FROM)
  FROM <- gsub("(^| )Darre( |$)", "\\1Darrell\\2", FROM)
  FROM <- gsub("(^| )Ayson( |$)", "\\1Allyson\\2", FROM)
  FROM <- gsub("(^| )Aen( |$)", "\\1JAllen\\2", FROM)
  FROM <- gsub("(^| )Say( |$)", "\\1Sally\\2", FROM)
  FROM <- gsub("(^| )Wi( |$)", "\\1Will\\2", FROM)
  FROM <- gsub("(^| )Way( |$)", "\\1Wally\\2", FROM)
  FROM <- gsub("(^| )Key( |$)", "\\1Kelly\\2", FROM)
  FROM <- gsub("([A-Z])(55)([A-Z])", "\\1SS\\2",FROM)
  FROM <- gsub("([A-Z])(5)([A-Z])", "\\1S\\2",FROM)
  FROM <- gsub("A1 ", "Al ", FROM)
  FROM <- gsub(" 1. ", " L. ", FROM)
  FROM <- gsub("Hany", "Harry", FROM)



  # other errors
  #FIXED
  FROM <- gsub(".1.", "", FROM)
  FROM <- ifelse(grepl(" Cha", FROM)&grepl("((^| )Ja)|(J a.son)", FROM)&grepl('etz', FROM), gsub("J.*?n","Jason", FROM), FROM) #not sure if we should make this correction
  FROM <- ifelse(grepl(" Cha", FROM)&grepl("((^| )Ja)|(J a.son)", FROM)&grepl('etz', FROM), gsub("Chaf.*?z","Chaffetz", FROM), FROM) #also not sure if we should make this correction
  FROM <- ifelse(grepl("Tom", FROM)&grepl("Cobum|Co bum", FROM), gsub("Cobum|Co bum", "Coburn", FROM), FROM) #fixed
  FROM <- ifelse(grepl("DarrellIssa", FROM), 'Darrell Issa', FROM) #fixed
  FROM <- ifelse(grepl("Trent|Robin|Mike", FROM)&grepl("Key", FROM), gsub("(Trent|Robin|Mike) Key", "\\1 Kelly",FROM), FROM) #this goes in OCR errors/last name errors
  FROM <- ifelse(grepl("Comyn|Com yn|Cobum|Corvyn", FROM)&grepl("John", FROM), gsub("Comyn|Com yn|Corvyn","Cornyn", FROM), FROM) #fixed
  FROM <- ifelse(grepl("Jon", FROM)&grepl("(^| )Kyi( |$)", FROM), gsub("Kyi","Kyl", FROM), FROM) #fixed
  FROM <- ifelse(grepl("Diane", FROM)&grepl("(^| )Feinstein( |$|,)", FROM), gsub("Diane","Dianne", FROM), FROM) #fixed

  # FROM <- ifelse(grepl("Cliff", FROM)&grepl("Steams", FROM), gsub("Steams","Stearns", FROM), FROM) #fixed

  #FIXED

  FROM <- gsub("Cwnmings", 'Cummings', FROM) # fixed
  FROM <- gsub("Tnhofe", "Inhofe", FROM) # fixed
  FROM <- gsub("Ellrners","Ellmers", FROM) # fixed
  FROM <- gsub("TONKA", "TONKO", FROM) #fixed
  FROM <- gsub("Mcarthur|Mccarthur", "MacArthur", FROM, ignore.case = TRUE) #fixed
  FROM <- gsub("(^| )Coryn( |$|,)", "\\1Cornyn\\2", FROM, ignore.case = TRUE) #fixed
  FROM <- gsub("(^| )Connelly( |$|,)", "\\1Connolly\\2", FROM, ignore.case = TRUE) #fixed
  FROM <- gsub("(^| )Heitkmap( |$|,)", "\\1Heitkamp\\2", FROM, ignore.case = TRUE) #fixed
  FROM <- gsub("(^| )Micahel( |$)", "\\1Michael\\2", FROM, ignore.case = TRUE) #fixed
  FROM <- gsub("(^| )Farenhold( |$|,)", "\\1Farenthold\\2", FROM, ignore.case = TRUE) #fixed
  FROM <- gsub("(^| )Eschoo( |$|,)", "\\1Eshoo\\2", FROM, ignore.case = TRUE) #fixed
  FROM <- gsub("(^| )Lary( |$)", "\\1Larry\\2", FROM, ignore.case = TRUE) #fixed
  FROM <- gsub("Christophers", "Christopher", FROM, ignore.case = TRUE) #fixed
  FROM <- gsub("Courntey", "Courtney", FROM, ignore.case = TRUE) #fixed
  FROM <- gsub("(^| )Martrin( |$)", "\\1Martin\\2", FROM, ignore.case = TRUE) #fixed
  FROM <- gsub("(^| )Machin( |$|,)", "\\1Manchin\\2", FROM, ignore.case = TRUE) #fixed
  FROM <- gsub("(^| )Marry( |$|,)", "\\1Mary\\2", FROM, ignore.case = TRUE) # might not need this code because it is Harry not Marry
  FROM <- gsub("(^| )T MOTHY( |$|,)", "\\1Timothy\\2", FROM, ignore.case = TRUE) #fixed
  FROM <- gsub("(^| )L NCOLN( |$|,)", "\\1Lincoln\\2", FROM, ignore.case = TRUE) #fixed
  FROM <- gsub("(^| )Wydon( |$|,)", "\\1Wyden\\2", FROM, ignore.case = TRUE) #fixed
  FROM <- gsub("(^| )Klobachur( |$|,)", "\\1Klobuchar\\2", FROM, ignore.case = TRUE) #fixed



  return(FROM)
}
