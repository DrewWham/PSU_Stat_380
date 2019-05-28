library(rvest)
library(data.table)

url <- "http://www.espn.com/college-football/team/stats/_/id/213/penn-state-nittany-lions"

#get the tables
Tables <- url %>%
  read_html() %>%
  html_table()

#clean the header  
Receiving<-Tables[[3]][-1,]
header<-Receiving[1,]
Receiving<-data.table(Receiving[-1,])
setnames(Receiving,names(Receiving),as.character(unlist(header[1,])))

#remove the totals from the bottom
Receiving<-head(Receiving,-1) 