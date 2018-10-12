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
Trips<-merge(Trips,Stations[,c('estation','elat','elon')],all.x=T)
 Trips<-merge(Trips,Stations[,c('estation','elat','elon')],by="estation",all.x=T)



#the function distm() will calculate the distance between 2 sets of lat lon values. Make a new column 
#that gives the distance between the start and end points of every trip. I have provided an example of 
#one way to set up the arguments for distm below

#If you had trouble here with the distm function that was my fault. That function outputs a matrix not a vector. 
#the distHaversine function was what I was looking for. If you were able to diagnose that and still get the 
#final plot good on ya

Trips$distance<-distHaversine(Trips[,c('slon','slat')], Trips[,c('elon','elat')])

#make a density plot with geom_dist for the frequency of trips across every distance observed in the dataset

ggplot(Trips,aes(x=distance))+geom_density()