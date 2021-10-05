library(data.table)
set.seed(77)

#data from https://www.kaggle.com/t/5c9cd23fa8e24861a574bd008bc3df76

test<-fread('./project/volume/data/raw/example_sub_MM.csv')
season<-fread('./project/volume/data/raw/season_MM.csv')
tourney<-fread('./project/volume/data/raw/tourney_MM.csv')
ranks<-fread('./project/volume/data/raw/ranks_MM.csv')

# Clean test

#########
#add this to deal with the new format of the id column
#this removes everything before the first underscore

test$id<-sub(".+?_","",test$id)

#I do it again to remove the year
test$id<-sub(".+?_","",test$id)

test<-data.table(matrix(unlist(strsplit(test$id,"_")),ncol=2,byrow=T))
setnames(test,c("V1","V2"),c("team_1","team_2"))

test$Season<-2019
test$DayNum<-120

# in order to keep track of the order of the test file I add in this column

test$id_num<-1:nrow(test)

test<-test[,.(id_num,team_1,team_2,Season,DayNum)]

test$result<-0.5

# make train

train<-rbind(season,tourney)
train<-train[,.(WTeamID,LTeamID,Season,DayNum)]
setnames(train,c("WTeamID","LTeamID"),c("team_1","team_2"))

train$result<-1

train$id_num<-1:nrow(train)

# make master data file

master<-rbind(train,test)
master$team_1<-as.character(master$team_1)
master$team_2<-as.character(master$team_2)

ranks$DayNum<-ranks$RankingDayNum+1


system_lst<-c("POM","PIG","SAG","MOR","DOK")

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

master<-master[,.(id_num,team_1,team_2,Season,POM_dif,PIG_dif, SAG_dif,MOR_dif,DOK_dif,result)]

# make all the NA values zero, there may be a better way to deal with NAs

master[is.na(master$POM_dif)]$POM_dif<-0
master[is.na(master$PIG_dif)]$PIG_dif<-0
master[is.na(master$SAG_dif)]$SAG_dif<-0
master[is.na(master$MOR_dif)]$MOR_dif<-0
master[is.na(master$DOK_dif)]$DOK_dif<-0

################
#add in your individual statistic diffs here
################

test<-master[result==0.5]
train<-master[result==1]
test<-test[order(id_num)]

test$id_num<-NULL
train$id_num<-NULL

rand_inx<-sample(1:nrow(train),nrow(train)*0.5)
train_a<-train[rand_inx,]
train_b<-train[!rand_inx,]

train_b$result<-0
train_b$PIG_dif<-train_b$PIG_dif*-1
train_b$SAG_dif<-train_b$SAG_dif*-1
train_b$MOR_dif<-train_b$MOR_dif*-1
train_b$DOK_dif<-train_b$DOK_dif*-1
train_b$POM_dif<-train_b$POM_dif*-1

train<-rbind(train_a,train_b)

fwrite(test,'./project/volume/data/interim/test.csv')
fwrite(train,'./project/volume/data/interim/train.csv')



ggplot(train,aes(x=POM_dif,fill=as.factor(result)))+geom_density()
