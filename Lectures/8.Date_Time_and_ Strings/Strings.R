library(data.table)
library(stringr)
library(stringi)
library(ggplot2)


#This reads in the flight data and stores it as an object called 'DT'
DT<-fread("./Lectures/Data/BikeShare/Trips.csv")

#look at the data type for each coloumn
str(DT)


# use gsub on bikeno 
# https://www.cheatography.com/davechild/cheat-sheets/regular-expressions/

DT$bike_num<-gsub("[0-9]", "", DT$bikeno) 
DT$bike_letter<-gsub("[0-9]", "", DT$bikeno) 

# solution using stringi

DT$bike_letter<- unlist(stri_extract_all_regex(DT$bikeno, "[A-Za-z]+"))

#using substring
DT$bike_num<-substring(DT$bikeno,2)

# using string split

test<-strsplit(DT$sdate,"T")
test<-matrix(unlist(strsplit(DT$sdate,"T")),ncol=2,byrow=T)

Time<-data.table(matrix(unlist(strsplit(DT$sdate,"T")),ncol=2,byrow=T))

# using stringi match
location<-"wisconson ave $ O st nw"
sub_DT<-DT[stri_startswith_fixed(DT$sstation,"Wis")]

# homework: make a bar plot of showing the number of rentals for each client type for each day of the week.
# use a red for registered clients and green for casual clients. Each day of the week should be represented
# on the x axis. Note that you will need to reshape the data in order to build this plot.  
