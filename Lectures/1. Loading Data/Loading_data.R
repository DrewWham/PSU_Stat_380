#load libraries
library(ggplot2)
library(dplyr)
library(reshape2)
library(stringr)
library(lubridate)
library(data.table)

#set working directory
setwd("/Users/few5014/Desktop/Stat_184/Flights")

#This reads in the flight data and stores it as an object called 'DT'
DT<-fread("2008.csv")
#This reads in the data about airports and stores it as an object called 'AP'
AP<-fread("airports.csv")
