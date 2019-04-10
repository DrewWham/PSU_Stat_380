library(data.table)
library(lubridate)

# read in data
games<-fread("./Lectures/Data/DataFest/games.csv")
wellness<-fread("./Lectures/Data/DataFest/wellness.csv")

# force the data to have both date and time because we will need time for making windows later
games$Date<-paste(games$Date,"00:00:01",sep=" ")
wellness$Date<-paste(wellness$Date,"00:00:01",sep=" ")

# make date a date-time object
games$Date<-ymd_hms(games$Date)
wellness$Date<-ymd_hms(wellness$Date)

# we are going to merge on date, it will be useful to keep a seperate column for the original date from each table
wellness$wellness_day<-wellness$Date
games$game_day<-games$Date


# subset the games data to only have the columns we need
game_results<-games[,.(GameID,Date,Outcome,TeamPoints,TeamPointsAllowed)]

# setting a key will tell the upcoming merge what to merge on
setkey(game_results,Date)
setkey(wellness,Date)

# make a period of time for the window
three_days<-60*60*24*3

# this is a rolling backwards merge, we also force a many-to-one merge with allow.cartesian=TRUE
Wellness_B4_game<-game_results[wellness,roll= -three_days,allow.cartesian=TRUE]

# now we can aggrigate the multiple wellness records for a given game down to a single value
avg_game_wellness<-dcast(Wellness_B4_game,GameID+Outcome+TeamPoints+TeamPointsAllowed+PlayerID~.,mean,value.var=c("Fatigue","Soreness","Desire","Irritability","SleepHours"))

# clean up the rows that did not merge to a game
avg_game_wellness<-avg_game_wellness[!is.na(avg_game_wellness$GameID)]


