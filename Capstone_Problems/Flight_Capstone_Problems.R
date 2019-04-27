#capstone problem set 2

library(data.table)
library(ggplot2)

# All of these questions will reference the Flights dataset and will require both 
# the "2008.csv" and "airports.csv" tables.

DT<-fread("./Lectures/Data/Flights/2008.csv")
AP<-fread("./Lectures/Data/Flights/airports.csv")

setnames(AP,"iata_code","Origin")
setkey(AP,Origin)
setkey(DT,Origin)
DT<-merge(DT,AP,all.x=T)
#1
# On average, flights that leave which airport travel the longest distance?

avg_dist<-dcast(DT,Origin+name~.,mean,na.rm=T,value.var = "Distance")[order(-.)]
avg_dist

#2
# US Airways Express (OH),ExpressJet Airlines (EV) and Endeavor Air (9E) are the primary carriers for passenger airlines out of the 
# University Park Airport. Which of these airlines has the lowest average departure delay? 
SCE<-DT[Origin=="SCE"]
car_avg_delay<-dcast(SCE,UniqueCarrier~.,mean,,na.rm=T,value.var="DepDelay")


#3
# In terms of departure delay what is the best month for travel out of the University Park Airport?
<<<<<<< HEAD

month_avg_delay<-dcast(SCE,Month~.,mean,,na.rm=T,value.var="DepDelay")[order(-.)]
=======
>>>>>>> 86477db2b1a42a651044b0f645360fe43aa92ce7

#4
# Format the date and time as a date-time object. Then use geom_smooth to plot the average departure delay for Delta, American Airlines
# and United across time. Select a unique color for each carrier. According to the geom_smooth plot, which carrier has the largest 
# average delay in July? 

DT$ymd<-paste0(DT$Year,"-",DT$Month,"-",DT$DayofMonth)
DT$date<-as_date(DT$ymd)

sub_DT<-DT[UniqueCarrier %in% c("AA","DL","UA")]

sub_DT<-sub_DT[!is.na(sub_DT$DepDelay)]

ggplot(sub_DT,aes(x=date,y=DepDelay,col=UniqueCarrier))+geom_smooth()


#5
# Re-plot the data over time of day. What is the relationship between time of day and average departure delay?

ggplot(sub_DT,aes(x=DepTime,y=DepDelay,col=UniqueCarrier))+geom_smooth()


#6 
# Re-plot the data over the days of the week. What is the relationship between the day of the week and average departure delay?
ggplot(sub_DT,aes(x= jitter(DayOfWeek),y=DepDelay,col=UniqueCarrier))+geom_smooth()

#7
# Only considering Flights between SFO and ATL, what is the relationship between departure delay and airtime?

SFO2ATL<-DT[Origin=="SFO"]
SFO2ATL<-SFO2ATL[Dest=="ATL"]
ggplot(SFO2ATL,aes(x=DepDelay,y=AirTime))+geom_smooth()

#8
# What type of delay is responsible for the largest amount of delay time for flights leaving O'Hare Int airport?
ORD<-DT[Origin=="ORD"]
ORD<-ORD[,.(CarrierDelay,WeatherDelay,NASDelay,SecurityDelay,LateAircraftDelay)]
ORD[is.na(ORD)]<-0

dcast(ORD,.~.,mean,value.var = c("CarrierDelay","WeatherDelay","NASDelay","SecurityDelay","LateAircraftDelay"))

#9
# only considering flights that occure on the same day, if an airplane (TailNum) experiances a delay what
# is the average delay time for that aircrafts next flight?
roll_DT<-DT[,.(Year,Month,DayofMonth,TailNum,DepTime,DepDelay)]

roll_DT$DepDelay[is.na(roll_DT$DepDelay)]<-0

 # need to remove rows where the tail number is missing or date is missing which causes rows with identical id.vars, this cleans that up
roll_DT<-roll_DT[!duplicated(roll_DT[,.(Year,Month,DayofMonth,TailNum,DepTime)])]

roll_DT2<-roll_DT
roll_DT$DT_DepTime<-roll_DT$DepTime
roll_DT2$DT2_DepTime<-roll_DT2$DepTime
roll_DT2$DepTime<-roll_DT2$DepTime-1

setkey(roll_DT,Year,Month,DayofMonth,TailNum,DepTime)
setkey(roll_DT2,Year,Month,DayofMonth,TailNum,DepTime)



rolled_DT<-roll_DT[roll_DT2,roll=T]
rolled_DT<-rolled_DT[!is.na(rolled_DT$DepDelay)]

Delay_rolled_DT<-rolled_DT[DepDelay>0]
mean(Delay_rolled_DT$i.DepDelay)

#10
# only considering flights that occure on the same day, if an airplane (TailNum) does not experiances a 
# delay what is the average delay time for that aircrafts next flight?

No_Delay_rolled_DT<-rolled_DT[DepDelay<1]
mean(No_Delay_rolled_DT$i.DepDelay)

