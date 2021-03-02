library(caret) #http://topepo.github.io/caret/index.html
library(data.table)

 

set.seed(77)

train<-fread('./project/volume/data/interim/train.csv')
test<-fread('./project/volume/data/interim/test.csv')

train_y<-train$result

train$team_1<-NULL
train$team_2<-NULL
test$team_1<-NULL
test$team_2<-NULL



dummies <- dummyVars(result ~ ., data = train)
train<-predict(dummies, newdata = train)
test<-predict(dummies, newdata = test)

#reformat after dummyVars and add back response Var

train<-data.table(train)
train$result<-train_y
test<-data.table(test)


#fit a linear model
glm_model<-glm(result~.,family=binomial,data=train)


#assess model
summary(glm_model)



#save model
saveRDS(dummies,"./project/volume/models/POM_glm.dummies")
saveRDS(glm_model,"./project/volume/models/POM_glm.model")

pred<-predict(glm_model,newdata = test,type="response")

test<-fread('./project/volume/data/interim/test.csv')
test$result<-pred
#our file needs to follow the example submission file format. So we need to only have the Id and saleprice column and
#we also need the rows to be in the correct order

sub<-fread('./project/volume/data/raw/examp_sub.csv')
sub$order<-1:nrow(sub)
teams<-data.table(matrix(unlist(strsplit(sub$id,"_")),ncol=2,byrow=T))
setnames(teams,c("V1","V2"),c("team_1","team_2"))

sub$team_1<-teams$team_1
sub$team_2<-teams$team_2

sub$team_1<-as.character(sub$team_1)
sub$team_2<-as.character(sub$team_2)
test$team_1<-as.character(test$team_1)
test$team_2<-as.character(test$team_2)

sub$Result<-NULL

submit<-merge(sub,test,all.x=T, by=c("team_1","team_2"))

submit<-submit[order(order)]

submit<-submit[,.(id,result)]

#now we can write out a submission
fwrite(submit,"./project/volume/data/processed/submit_POM.csv")

