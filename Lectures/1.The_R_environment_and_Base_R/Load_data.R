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


# Subsetting a data.table

# get only the rows from flights out of univerity park airport, subset with a logical statement

SCE<-DT[Origin == "SCE"]

# use a vector to subset all rows where a value is in the vector

WF<-DT[Origin %in% c('DCA','IAD','BWI')]

#or

WashAP<-c('DCA','IAD','BWI')

WF<-DT[Origin %in% WashAP]

# select only some of the columns in DT and return as a new data.table

delay_tab<-WF[,.(Origin,ArrDelay,DepDelay,CarrierDelay,WeatherDelay,NASDelay,SecurityDelay,LateAircraftDelay)]

head(delay_tab)

# we can also sort

delay_tab<-delay_tab[order(DepDelay)]
# or
delay_tab<-delay_tab[order(-DepDelay)]


# notice that some flights have NA for all of their delay-type values even though they were delayed
# we can remove all of them by subsetting with a logical statement

delay_tab<-delay_tab[!is.na(delay_tab$CarrierDelay)]

# get the average DepDelay

mean(delay_tab$DepDelay)

# or

delay_tab[,mean(DepDelay)]

# also this method will let you build a new data table, it is less useful when you are just getting a single value

delay_tab[,.(Avg_DepDelay=mean(DepDelay))]

delay_tab[,.(Avg_ArrDelay=mean(ArrDelay),Avg_DepDelay=mean(DepDelay))]

#however, it is very useful once you start using the "by" operation

delay_tab[,.(Avg_ArrDelay=mean(ArrDelay),Avg_DepDelay=mean(DepDelay)), by=Origin]




# In class work: Build a R script to answer these questions. A canvas quiz will be available for you to enter your answers tomorrow
# in class. The quiz will be due Sunday by midnight. 

# 1) What was the average DepDelay for flights leaving 'SFO'?

# 2) How many flights originated out of the Charleston SC airport 'CHS'

# 3) How many unique airports did flights leaving the university park airport fly to?

# 4) Whats the average airtime for a flight between SFO and ATL?

# 5) Considering only the New York city area airports (John F. Kennedy, LaGuardia and Newark Liberty), which airport 
# has the largest average departure delay

# 6) Considering only the New York city area airports, which airport has the largest number of unique destinations?

# 7) Considering only the airports in this dataset with more than 1000 flights, which airport has the lowest average DepDelay?












