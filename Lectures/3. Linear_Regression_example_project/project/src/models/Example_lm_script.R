library(caret) #http://topepo.github.io/caret/index.html
library(data.table)
library(Metrics)

set.seed(770)

train<-fread('./project/volume/data/interim/train.csv')
test<-fread('./project/volume/data/interim/test.csv')
submit<-fread('./project/volume/data/raw/solution.csv')

test_y<-submit$DepDelay

train_y<-train$DepDelay
test$DepDelay<-0

master<-rbind(train,test)
#test
dummies <- dummyVars(DepDelay ~ ., data = master)
train<-predict(dummies, newdata = train)
test<-predict(dummies, newdata = test)

#reformat after dummyVars and add back response Var

train<-data.table(train)
train$DepDelay<-train_y
test<-data.table(test)


#fit a linear model
lm_model<-lm(DepDelay~ .,data=train)


#assess model
summary(lm_model)



#save model
saveRDS(dummies,"./project/volume/models/DepDelay_lm.dummies")
saveRDS(lm_model,"./project/volume/models/DepDelay_lm.model")

test$DepDelay<-predict(lm_model,newdata = test)

#our file needs to follow the example submission file format. So we need to only have the Id and saleprice column and
#we also need the rows to be in the correct order
submit$DepDelay<-test$DepDelay


#now we can write out a submission
fwrite(submit,"./project/volume/data/processed/submit_lm.csv")

#null model rmse
rmse(test_y,mean(train_y))

rmse(test_y,test$DepDelay)

