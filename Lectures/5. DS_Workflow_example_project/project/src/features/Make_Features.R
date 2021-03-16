library(data.table)
set.seed(77)


test<-fread('./project/volume/data/raw/MSampleSubmissionStage2.csv')
season<-fread('./project/volume/data/raw/MRegularSeasonDetailedResults.csv')
tourney<-fread('./project/volume/data/raw/MNCAATourneyDetailedResults.csv')
ranks<-fread('./project/volume/data/raw/MMasseyOrdinals.csv')



# Clean test

test<-data.table(matrix(unlist(strsplit(test$ID,"_")),ncol=3,byrow=T))
setnames(test,c("V1","V2","V3"),c("Season","team_1","team_2"))

#test$Season<-2019
test$DayNum<-135

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

ranks$DayNum<-ranks$RankingDayNum+1


system_lst<-c("POM","SAG","MOR","DOK")

master$Season<-as.integer(master$Season)

for (i in 1:length(system_lst)){

  one_rank<-ranks[SystemName==system_lst[i]][,.(Season,DayNum,TeamID,OrdinalRank)]
  setnames(one_rank,"TeamID","team_1")

  one_rank$team_1<-as.character(one_rank$team_1)

  setkey(master,Season,team_1,DayNum)
  setkey(one_rank,Season,team_1,DayNum)

  master<-one_rank[master,roll=T]
  setnames(master,"OrdinalRank","team_1_rank")


  setnames(one_rank,"team_1","team_2")
  setkey(master,Season,team_2,DayNum)
  setkey(one_rank,Season,team_2,DayNum)

  master<-one_rank[master,roll=T]

  setnames(master,"OrdinalRank","team_2_rank")

  master$rank_dif<-master$team_2_rank-master$team_1_rank

  master$team_1_rank<-NULL
  master$team_2_rank<-NULL

  setnames(master,"rank_dif",paste0(system_lst[i],"_dif"))

}

master<-master[order(Season,DayNum)]

master<-master[,.(team_1,team_2,POM_dif, SAG_dif,MOR_dif,DOK_dif,result)]

master<-master[!is.na(master$POM_dif)]
master<-master[!is.na(master$SAG_dif)]
master<-master[!is.na(master$MOR_dif)]
master<-master[!is.na(master$DOK_dif)]

test<-master[result==0.5]
train<-master[result==1]

rand_inx<-sample(1:nrow(train),nrow(train)*0.5)
train_a<-train[rand_inx,]
train_b<-train[!rand_inx,]

train_b$result<-0
train_b$SAG_dif<-train_b$SAG_dif*-1
train_b$MOR_dif<-train_b$MOR_dif*-1
train_b$DOK_dif<-train_b$DOK_dif*-1
train_b$POM_dif<-train_b$POM_dif*-1

train<-rbind(train_a,train_b)

fwrite(test,'./project/volume/data/interim/test.csv')
fwrite(train,'./project/volume/data/interim/train.csv')



ggplot(train,aes(x=POM_dif,fill=as.factor(result)))+geom_density()





