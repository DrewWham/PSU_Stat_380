#load libraries
library(ggplot2)
library(dplyr)
library(reshape2)
library(stringr)
library(lubridate)
library(data.table)

#set working directory
setwd("/Users/few5014/Desktop/Stat_184/Flights")



#this is also a vector
Vec <- 7
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

#This reads in the flight data and stores it as an object called 'DT'
DT<-fread("2008.csv")
#This reads in the data about airports and stores it as an object called 'AP'
AP<-fread("airports.csv")
#sometimes data files are large and you might want to just load a subset to investigate
#use the 'nrows' argument to bring a few rows in

DT_subset<-fread("2008.csv",nrows=100)

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
fwrite(DT_subset, "subset_2008.csv")








