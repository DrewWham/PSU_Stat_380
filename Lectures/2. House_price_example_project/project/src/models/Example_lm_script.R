library(caret)
library(data.table)
set.seed(77)

train<-fread('./project/volume/data/interim/train.csv')
test<-fread('./project/volume/data/interim/test.csv')

train_y<-train$DepDelay
test_y<-test$DepDelay

dummies <- dummyVars(DepDelay ~ ., data = train)
train<-predict(dummies, newdata = train)
test<-predict(dummies, newdata = test)

#reformat after dummyVars and add back response Var

train<-data.table(train)
train$DepDelay<-train_y
test<-data.table(test)
