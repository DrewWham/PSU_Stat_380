library(lubridate)
library(data.table)


#Q1: You are playing no-limit texas holdem poker (standard 52 card deck). The two card hand you are dealt is the 8 of clubs and the 8 of hearts. The three cards on the common board are the 3 of spades, the Ace of hearts and the 3 of clubs. What is the probability that the next card the dealer puts on the board (aka, the turn card) will be another 8?
#2/47

#Q2: If you roll 2 six-sided dice. What is the probability of the two dice showing a 1 and a 6 ?
#2/6 * 1/6

stations<-fread("./Data/DC_Stations.csv")
trips<-fread("./Data/Trips.csv")

#Q3: How many rentals are represented in the "Trips" dataset?
nrow(trips)

#Q4: Which of these stations appears in the "DC_Stations" dataset but does not appear in the trips dataset as either a station that was rented from (sstation) or as a station that was returned to (estation)?

#get the rows in trips that have estations and sstations that 
missing_stations<-stations[!name %in% trips$estation]
missing_stations<-missing_stations[!name %in% trips$sstation]

unique(missing_stations$name)

#Q5: The most common trip for registered clients was from which station to which station?
#get the registered clients
reg_trips<-trips[client=="Registered"]
#get the number of trips between each station pair
trip_loc_counts<-reg_trips[,.N,by=c("sstation","estation")]
#sort so we can see the most easily
trip_loc_counts<-trip_loc_counts[order(-N)]


#Q6: The most common trip for casual clients was from which station to which station?
#get the casual clients
reg_trips<-trips[client=="Casual"]
#get the number of trips between each station pair
trip_loc_counts<-reg_trips[,.N,by=c("sstation","estation")]
#sort so we can see the most easily
trip_loc_counts<-trip_loc_counts[order(-N)]

#Q7: Which day of the week did registered clients have the most rentals?
#add the day of week 
trips$day<-wday(trips$sdate,label=T)
#get just the registered
reg_trips<-trips[client=="Registered"]

#sort
reg_trips[,.N,by="day"][order(-N)]

#Q8: How many trips started at a station with "Wisconsin" somewhere in the name?

wis_trips<-trips[grep("Wisconsin",trips$sstation)]
nrow(wis_trips)







