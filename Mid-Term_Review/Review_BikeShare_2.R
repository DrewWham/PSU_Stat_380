library(data.table)
library(reshape2)
library(ggplot2)
library(geosphere)

#download data to your local computer
download.file(url="https://s3.amazonaws.com/stat.184.data/BikeShare/Trips.csv",destfile='Trips.csv', method='curl')
download.file(url="https://s3.amazonaws.com/stat.184.data/BikeShare/DC_Stations.csv",destfile='DC_Stations.csv', method='curl')

#Read in the data
#Stations gives information about each bike share station location
Stations<-fread("DC_Stations.csv")
#Trips gives information about the rental history over the last quarter of 2014
Trips<-fread("Trips.csv")

#inspect both data objects
head(Trips)
head(Stations)
str(Trips)
str(Stations)


#We are interested in the distance between start and end stations, notice the Lat Lon for each station is 
#in the Stations dataset and the information about each trip is in the Trip dataset. 
#using the merge function, make new columns in the trip dataset that give the lat and lon of both the 
#start and end station. Use setnames to chang columns names where necessary
setnames(Stations,c("name","lat","long"),c("sstation","slat","slon"))
Trips<-merge(Trips,Stations[,c('sstation','slat','slon')],all.x=T)
setnames(Stations,c("sstation","slat","slon"),c("estation","elat","elon"))
Trips<-merge(Trips,Stations[,c('estation','elat','elon')],by="estation",all.x=T)



#the function distHaversine will calculate the distance between 2 sets of lat lon values. Make a new column 
#that gives the distance between the start and end points of every trip. I have provided an example of 
#one way to set up the arguments for distm below


Trips$distance<-distHaversine(Trips[,c('slon','slat')], Trips[,c('elon','elat')])

#on average, do casual or registered clients travel farther?

#From which station on average do clients travel the farthest from?

#Frequently clients rent and return bikes from the same station. What station has the highest frequency of self-returns for 
#its rentals?

#Plot the relationship between the number of rentals per station vs the number of docks at a station 
#Hint: The Stations data represents a snapshot in time, you will need to derive the number of docks from the
#information available. 

#Plot the distribution of distance traveled for bikes during the time period of data collection. 
#Hint: use geom_density()


