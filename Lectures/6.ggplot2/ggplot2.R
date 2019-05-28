library(data.table)
library(ggplot2)

# What is the relationship between Airport size and Delay?

#This reads in the flight data and stores it as an object called 'DT'
DT<-fread("./Lectures/Data/Flights/2008.csv")

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


#get the total number of flights for each airport
#AP_flight_count<-DT[,.N,by=Origin]
AP_flight_count<-dcast(DT,Origin~.,length,value.var="Origin")
setnames(AP_flight_count,".","N")

#merge the total number of flights to the counts of each type of delay
Delay_Count<-merge(Delay_Count,AP_flight_count,all.x=T)

#calculate the frequency from counts
Delay_Count$Delay_freq<-Delay_Count$Delay_Count/Delay_Count$N

#remove the airports with less than 100 flights
Delay_Count<-Delay_Count[N>100,]

#plot
ggplot(Delay_Count[Delay_Type=="CarrierDelay",],aes(x=N,y=Delay_freq))+geom_point()

#what is the distribution of total flights per airport
ggplot(Delay_Count[Delay_Type=="CarrierDelay",],aes(x=N))+geom_histogram(bins = 50)

#does a log transform help?
ggplot(Delay_Count[Delay_Type=="CarrierDelay",],aes(x=log(N)))+geom_histogram(bins = 50)

#log transform the x axis
ggplot(Delay_Count[Delay_Type=="CarrierDelay",],aes(x=log(N),y=Delay_freq))+geom_point()

#plot all the delay types in facets
ggplot(Delay_Count,aes(x=log(N),y=Delay_freq,col=Delay_Type))+geom_point()+facet_grid(.~Delay_Type)

#add a title
ggplot(Delay_Count,aes(x=log(N),y=Delay_freq,col=Delay_Type))+geom_point()+facet_grid(.~Delay_Type)+ggtitle("Flight Delay Frequency by Airport Size")

#adjust title to center
ggplot(Delay_Count,aes(x=log(N),y=Delay_freq,col=Delay_Type))+geom_point()+facet_grid(.~Delay_Type)+ggtitle("Flight Delay Frequency by Airport Size")+theme(plot.title = element_text(hjust = 0.5))

#change x and y axis names
ggplot(Delay_Count,aes(x=log(N),y=Delay_freq,col=Delay_Type))+geom_point()+facet_grid(.~Delay_Type)+ggtitle("Flight Delay Frequency by Airport Size")+theme(plot.title = element_text(hjust = 0.5))+xlab("Log Number of Flights per Year")+ylab("Frequency of Delay")





