library(data.table)
set.seed(77)

test<-fread('./project/volume/data/raw/examp_sub.csv')
season<-fread('./project/volume/data/raw/RegularSeasonDetailedResults.csv')
tourney<-fread('./project/volume/data/raw/NCAATourneyDetailedResults.csv')
ranks<-fread('./project/volume/data/raw/MasseyOrdinals_thru_2019_day_128.csv')



# Clean test

test<-data.table(matrix(unlist(strsplit(test$id,"_")),ncol=2,byrow=T))
setnames(test,c("V1","V2"),c("team_1","team_2"))

test$Season<-2019
test$DayNum<-133

test<-test[,.(team_1,team_2,Season,DayNum)]

test$result<-0.5

# make train

train<-rbind(season,tourney)
train<-train[,.(WTeamID,LTeamID,Season,DayNum)]
setnames(train,c("WTeamID","LTeamID"),c("team_1","team_2"))

train$result<-1

# make master data file

master<-rbind(train,test)
master$team_1<-as.character(master$team_1)
master$team_2<-as.character(master$team_2)

ranks$DayNum<-ranks$RankingDayNum-1

pom_ranks<-ranks[SystemName=="POM"][,.(Season,DayNum,TeamID,OrdinalRank)]
setnames(pom_ranks,"TeamID","team_1")

pom_ranks$team_1<-as.character(pom_ranks$team_1)

setkey(master,Season,team_1,DayNum)
setkey(pom_ranks,Season,team_1,DayNum)

master<-pom_ranks[master,roll=T]
setnames(master,"OrdinalRank","team_1_POM")


setnames(pom_ranks,"team_1","team_2")
setkey(master,Season,team_2,DayNum)
setkey(pom_ranks,Season,team_2,DayNum)

master<-pom_ranks[master,roll=T]

setnames(master,"OrdinalRank","team_2_POM")

master$POM_dif<-master$team_2_POM-master$team_1_POM

master<-master[order(Season,DayNum)]

master<-master[,.(team_1,team_2,POM_dif,result)]


master<-master[!is.na(master$POM_dif)]

test<-master[result==0.5]
train<-master[result==1]

rand_inx<-sample(1:nrow(train),nrow(train)*0.5)
train_a<-train[rand_inx,]
train_b<-train[!rand_inx,]

train_b$result<-0
train_b$POM_dif<-train_b$POM_dif*-1

train<-rbind(train_a,train_b)

fwrite(test,'./project/volume/data/interim/test.csv')
fwrite(train,'./project/volume/data/interim/train.csv')
