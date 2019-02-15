library(data.table)



#This reads in the flight data and stores it as an object called 'DT'
DT<-fread("./Lectures/Data/Flights/2008.csv")

#lets subset out the columns that have to do with types of delays
Delay_DT<-DT[,.(Origin,CarrierDelay,WeatherDelay,NASDelay,SecurityDelay,LateAircraftDelay)]

# clean up NAs
Delay_DT[is.na(Delay_DT)]<-0

#melt into a long format
m_Delay_DT<-melt(Delay_DT,id="Origin")


#Get the counts for each delay type
Delay_tab<-dcast(m_Delay_DT,Origin~variable,mean,value.var=c("value"))
# for long format
Delay_avg<-dcast(m_Delay_DT,Origin+variable~.,mean,value.var=c("value"))

#set the names
setnames(Delay_avg,c("variable", "."),c("delay_type","avg_delay"))


#set the order before using the duplicate function
Delay_avg<-Delay_avg[order(Origin,-avg_delay)]

#get the row indexes for the ones we want to keep
largest_delay<-!duplicated(Delay_avg[,.(Origin)])

#get the largest delay type for each airport
AP_largest_delay<-Delay_avg[largest_delay,]
