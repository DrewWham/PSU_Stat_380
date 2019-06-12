library(data.table)
library(lubridate)
library(ggplot2)


#This reads in the flight data and stores it as an object called 'DT'
DT<-fread("./Lectures/Data/BikeShare/Trips.csv")

#look at the data type for each coloumn
str(DT)

#notice that sdate and edate are not data/time objects
#we will attempt to use as_date
test<-as_date(DT$sdate)
head(test)

#notice that it did not parse correctly
test2<-ymd_hms(DT$sdate)
head(test2)

#that looks like it did work lets do the same thing to the real data
DT$sdate<-ymd_hms(DT$sdate)
DT$edate<-ymd_hms(DT$edate)

#now  lets look at the data type again
str(DT)


#we can now extract units from the date/time object
DT$Day<-wday(DT$sdate,label = T,abbr = F)

# one of the great things about date/time columns is that you can do math on them
time_diff<-DT$edate-DT$sdate
DT$trip_time<-interval(DT$sdate,DT$edate)
# 'trip_time' is now a difftime data column
str(DT)


# homework: make a bar plot of showing the number of rentals for each client type for each day of the week.
# use blue for registered clients and orange for casual clients. Each day of the week should be represented
# on the x axis.  
