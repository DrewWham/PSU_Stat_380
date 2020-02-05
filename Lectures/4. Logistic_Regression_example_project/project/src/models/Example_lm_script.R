library(caret) #http://topepo.github.io/caret/index.html
library(data.table)
library(Metrics)

set.seed(77)

train<-fread('./project/volume/data/interim/train.csv')
test<-fread('./project/volume/data/interim/test.csv')

train_y<-train$Direction
test_y<-test$Direction

dummies <- dummyVars(Direction ~ ., data = train)
train<-predict(dummies, newdata = train)
test<-predict(dummies, newdata = test)

#reformat after dummyVars and add back response Var

train<-data.table(train)
train$Direction<-train_y
test<-data.table(test)


#fit a linear model
glm_model<-glm(Direction~.,family=binomial,data=train)


#assess model
summary(glm_model)

coef(glm_model)

#save model
saveRDS(dummies,"./project/volume/models/DepDelay_lm.dummies")
saveRDS(lm_model,"./project/volume/models/DepDelay_lm.model")

test$pred<-predict(glm_model,newdata = test,type="response")

#our file needs to follow the example submission file format. So we need to only have the Id and saleprice column and
#we also need the rows to be in the correct order

submit<-test[,.(pred)]

#now we can write out a submission
fwrite(submit,"./project/volume/data/processed/submit_glm.csv")

mean(ll(test_y,test$pred))

#null model rmse
mean(ll(test_y,0.5))

