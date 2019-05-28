#load libraries
library(ggplot2)
library(stringr)
library(lubridate)
library(data.table)

# extra reading and examples:
# https://cloud.r-project.org/web/packages/data.table/vignettes/datatable-reshape.html


#This reads in the flight data and stores it as an object called 'DT'
DT<-fread("./Lectures/Data/Flights/2008.csv")
#This reads in the data about airports and stores it as an object called 'AP'
AP<-fread("./Lectures/Data/Flights/airports.csv")


#Reshaping and aggregating are two of the most important functions you will use in data wrangling
#We will use two methods

#data.table has built in aggregation function that we have already used
DT[,.(Avg_Delay=mean(DepDelay)),by=Origin]

#dcast offeres a larger set of reshaping options
Avg_Delay_tab<-dcast(DT,Origin ~ .,mean,na.rm=T,value.var= c("DepDelay"))

# dcast can scale your aggregations in many directions

#dcast allows you to define multiple groupings
Avg_Delay_tab<-dcast(DT,Origin ~ UniqueCarrier,mean,na.rm=T,value.var= c("DepDelay"))

#dcast allows you calculate multiple summary stats
Sum_Delay_tab<-dcast(DT,Origin ~ .,c(mean,sd),na.rm=T,value.var= c("DepDelay"))

#dcast allows you calculate multiple summary stats on multiple columns 
Sum_Delay_tab<-dcast(DT,Origin ~ .,c(mean,sd),na.rm=T,value.var= c("DepDelay", "ArrDelay"))

#dcast allows you calculate multiple summary stats on multiple columns 
Sum_Delay_Car_tab<-dcast(DT,Origin ~  UniqueCarrier,c(mean,sd),na.rm=T,value.var= c("DepDelay", "ArrDelay"))

#this is the same information in tidy format
Avg_Delay_tab<-dcast(DT,Origin + UniqueCarrier~.,mean,na.rm=T,value.var= c("DepDelay"))

#rename the '.' column
setnames(Avg_Delay_tab,".","Average_Delay")

fwrite(Avg_Delay_tab,"Avg_Delay_tab.csv")
