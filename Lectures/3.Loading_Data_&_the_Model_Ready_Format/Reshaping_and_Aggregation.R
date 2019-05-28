#load libraries
library(ggplot2)
library(stringr)
library(lubridate)
library(data.table)


#This reads in the flight data and stores it as an object called 'DT'
DT<-fread("./Lectures/Data/Flights/2008.csv")
#This reads in the data about airports and stores it as an object called 'AP'
AP<-fread("./Lectures/Data/Flights/airports.csv")

#there are several ways to subset

#select all rows with vlaue 'IAD' as 'Origin'

sub_IAD<-DT[Origin=='IAD',]

#subset with a vector is also very useful
#make a vector with all of the washington area airports
WashAP<-c('DCA','IAD','BWI')

WF<-DT[Origin %in% WashAP]

dim(WF)

WF<-WF[Cancelled==0]

#Reshaping and aggregating are two of the most important functions you will use in data wrangling
#We will use two methods

#data.table has built in aggregation function
WF[,.(Avg_Delay=mean(DepDelay)),by=Origin]

#dcast offeres a larger set of reshaping options
Avg_Delay_tab<-dcast(WF,Origin ~ .,mean,value.var= c("DepDelay"))
#dcast allows you to define multiple groupings
Avg_Delay_tab<-dcast(WF,Origin ~ UniqueCarrier,mean,value.var= c("DepDelay"))

#this is the same information in tidy format
Avg_Delay_tab<-dcast(WF,Origin + UniqueCarrier~.,mean,value.var= c("DepDelay"))

#rename the '.' column
setnames(Avg_Delay_tab,".","Average_Delay")

fwrite(Avg_Delay_tab,"Avg_Delay_tab.csv")
