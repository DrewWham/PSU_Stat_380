# ".csv" files are a common way to store data, we can load ".csv" files with the fread() function:
# first, you will need to download the flights data
source("./Lectures/Data/download_flights.R")

# This reads in the flight data and stores it as an object called 'DT'
DT<-fread("./Lectures/Data/Flights/2008.csv")
# This reads in the data about airports and stores it as an object called 'AP'
AP<-fread("./Lectures/Data/Flights/airports.csv")
# sometimes data files are large and you might want to just load a subset to investigate
# use the 'nrows' argument to bring a few rows in

DT_subset<-fread("./Lectures/Data/Flights/2008.csv",nrows=100)

# We can now look at the data with some useful functions

# the dim() function will show you the number of rows and the number of columns in a data_table
dim(DT)

# this is okay with a data_table but it is bad practice
DT

# this is the preferred way to look at the top of an object
head(DT)

# this is the preferred way to look at the bottom of an object
tail(DT)

# we learned about data types above, this is a useful way to inspect a data object and see column types
str(DT)

# we can write out data with the fwrite command
fwrite(DT_subset, "./Lectures/Data/Flights/subset_2008.csv")