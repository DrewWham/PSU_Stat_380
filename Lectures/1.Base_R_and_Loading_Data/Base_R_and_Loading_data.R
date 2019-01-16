#load libraries
library(reshape2)
library(data.table)

# set your working directory to the PSU_Stat_184 directory, this is my location but you may have your directory in another location

#setwd("~/Desktop/PSU_Stat_184")


#this is a vector
Vec <- 7
#number vector
num_Vec<-c(3,6,5,1)
#this is a vector of logical statements
Log_Vec <- c(TRUE,TRUE,FALSE,TRUE)
#this is a character vector
Chr_Vec <- c("This", "is a", "character", "vector")
#DT1 is now a data.table
DT1 <- data.table(V1=num_Vec,V2=Log_Vec,V3=Chr_Vec)
#the str() function will tell you about the types of each column in a data.table
str(DT1)

#Indexing allows you to retrieve values or subset a data_table

#returns the first row, notice that this is a data_table
DT1[1,]
#returns the column named "V2", notice that this is a vector
DT1[,V2]

#".csv" files are a common way to store data, we can load ".csv" files with the fread() function:
# first, you will need to download the flights data
source("./Lectures/Data/download_flights.R")

#This reads in the flight data and stores it as an object called 'DT'
DT<-fread("./Lectures/Data/Flights/2008.csv")
#This reads in the data about airports and stores it as an object called 'AP'
AP<-fread("./Lectures/Data/Flights/airports.csv")
#sometimes data files are large and you might want to just load a subset to investigate
#use the 'nrows' argument to bring a few rows in

DT_subset<-fread("./Lectures/Data/Flights/2008.csv",nrows=100)

#We can now look at the data with some useful functions

#the dim() function will show you the number of rows and the number of columns in a data_table
dim(DT)

#this is okay with a data_table but it is bad practice
DT

#this is the preferred way to look at the top of an object
head(DT)

#this is the preferred way to look at the bottom of an object
tail(DT)

#we learned about data types above, this is a useful way to inspect a data object and see column types
str(DT)

#we can write out data with the fwrite command
fwrite(DT_subset, "./Lectures/Data/Flights/subset_2008.csv")




# you homework is to run this to get all of the data for this class, it will take some time to download all of the data

source("./Lectures/Data/download_data.R")



