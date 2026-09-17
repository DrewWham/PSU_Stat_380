library(caret)
library(data.table)
set.seed(77)

train<-fread('./project/volume/data/interim/train.csv')
test<-fread('./project/volume/data/interim/test.csv')
submit<-fread('./project/volume/data/raw/sample_submission.csv')

train_y<-train$SalePrice
test_y<-test$SalePrice

master<-rbind(train,test)

dummies <- dummyVars(SalePrice ~ ., data = master)
train<-predict(dummies, newdata = train)
test<-predict(dummies, newdata = test)

#reformat after dummyVars and add back response Var

train<-data.table(train)
train$SalePrice<-train_y
test<-data.table(test)



#fit a linear model
lm_model<-lm(SalePrice~. ,data=train)


#assess model
summary(lm_model)



#save model
saveRDS(dummies,"./project/volume/models/DepDelay_lm.dummies")
saveRDS(lm_model,"./project/volume/models/DepDelay_lm.model")

test$SalePrice<-predict(lm_model,newdata = test)

#our file needs to follow the example submission file format. So we need to only have the Id and saleprice column and
#we also need the rows to be in the correct order
submit$SalePrice<-test$SalePrice


#now we can write out a submission
fwrite(submit,"./project/volume/data/processed/submit_lm.csv")

