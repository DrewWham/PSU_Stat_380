 ### Merging
 
 
We'd like to merge using the Airport codes (a common value between datasets), but they are named "iata_code" in the Airports dataset and "Origin" and "Dest" in the Flights dataset. We will be focusing on departure delays in our analysis so we will be merging to "Origin".

#load libraries
library(data.table)
library(reshape2)
#set working directory
setwd("/Users/few5014/Desktop/Stat_184/Flights")

#This reads in the flight data and stores it as an object called 'DT'
DT<-fread("2008.csv")
#This reads in the data about airports and stores it as an object called 'AP'
AP<-fread("airports.csv")


#calculate some aggregate stats 
Avg_DepDelay<-dcast(DT,Origin~.,mean,na.rm=T,value.var=c("DepDelay"))
Avg_Dist<-dcast(DT,Origin~.,mean,na.rm=T,value.var=c("Distance"))
Avg_TaxTime<-dcast(DT,Origin~.,mean,na.rm=T,value.var=c("TaxiOut"))

#rename the new values
setnames(Avg_DepDelay,".","Avg_DepDelay")
setnames(Avg_Dist,".","Avg_Dist")
setnames(Avg_TaxTime,".","Avg_TaxTime")
setnames(AP,"iata_code","Origin")

#write out .csv to upload to canvas
fwrite(Avg_DepDelay[1:100,],"sub_Avg_DepDelay.csv")
fwrite(Avg_Dist[1:100,],"sub_Avg_Dist.csv")
fwrite(Avg_TaxTime[1:100,],"sub_Avg_TaxTime.csv")


#make sure the objects are data.tables
Avg_DepDelay<-data.table(Avg_DepDelay)
Avg_Dist<-data.table(Avg_Dist)
Avg_TaxTime<-data.table(Avg_TaxTime)

#merging with keys
#first set some keys
setkey(AP,Origin)
setkey(Avg_DepDelay, Origin)
setkey(Avg_Dist, Origin)
setkey(Avg_TaxTime, Origin)

#do the merging

Airport_stats<-merge(Avg_DepDelay,AP,all.x=T)
Airport_stats<-merge(Airport_stats,Avg_Dist,all.x=T)
Airport_stats<-merge(Airport_stats,Avg_TaxTime,all.x=T)

fwrite(Airport_stats,"Airport_stats.csv")
