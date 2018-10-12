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

#We are interested in the distance between start and end stations, notice the Lat Lon for each station is 
#in the Stations dataset and the information about each trip is in the Trip dataset. 
#using the merge function, make new columns in the trip dataset that give the lat and lon of both the 
#start and end station. Use setnames to chang columns names where necessary


#the function distm() will calculate the distance between 2 sets of lat lon values. Make a new column 
#that gives the distance between the start and end points of every trip. I have provided an example of 
#one way to set up the arguments for distm below

distHaversine(Trips[,c('slon','slat')], Trips[,c('elon','elat')])

#make a density plot with geom_dist for the frequency of trips across every distance observed in the dataset
