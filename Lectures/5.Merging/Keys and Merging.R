#load libraries
library(data.table)




#This reads in the flight data and stores it as an object called 'DT'
DT<-fread("./Lectures/Data/Flights/2008.csv")
#This reads in the data about airports and stores it as an object called 'AP'
AP<-fread("./Lectures/Data/Flights/airports.csv")


merge_DT<-merge(DT,AP,by.x = "Origin",by.y="iata_code")


system.time(DT[Origin == "SFO"])
system.time(merge(DT,AP,by.x = "Origin",by.y="iata_code"))


setnames(AP,"iata_code","Origin")

setkey(DT,Origin)
setkey(AP,iata_code)

system.time(merge(DT,AP))


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

#merge

Airport_stats<-merge(Avg_DepDelay,AP,all.x=T)
Airport_stats<-merge(Airport_stats,Avg_Dist,all.x=T)
Airport_stats<-merge(Airport_stats,Avg_TaxTime,all.x=T)

fwrite(Airport_stats,"./Homework/Airport_stats.csv")
