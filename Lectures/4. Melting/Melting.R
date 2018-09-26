library(data.table)
library(reshape2)
#set working directory

setwd("/Users/few5014/Desktop/Stat_184/Flights")

#This reads in the flight data and stores it as an object called 'DT'
DT<-fread("2008.csv")

#lets subset out the columns that have to do with types of delays
Delay_DT<-DT[,c("Origin","CarrierDelay","WeatherDelay","NASDelay","SecurityDelay","LateAircraftDelay")]


#melt into a long format
m_Delay_DT<-melt(Delay_DT,id="Origin")

#clean the NAs and low delay times
m_Delay_DT<-m_Delay_DT[!is.na(m_Delay_DT$value)]
m_Delay_DT<-m_Delay_DT[value>0]

#Get the counts for each delay type
Delay_Count<-dcast(m_Delay_DT,Origin+variable~.,length,value.var=c("value"))
Delay_Count<-data.table(Delay_Count)

#set the names
setnames(Delay_Count,".","Delay_Count")
setnames(Delay_Count,"variable","Delay_Type")

#set the order before using the duplicate function
Delay_Count<-Delay_Count[order(Origin,-Delay_Count)]

#get the row indexes for the ones we want to keep 
row2keep<-!duplicated(Delay_Count[,c("Origin")])

#index the most frequent delays by airport
Most_Freq_Delay<-Delay_Count[row2keep,]
