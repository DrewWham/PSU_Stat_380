library(data.table)
library(Metrics)


train<-fread('./project/volume/data/raw/train.csv')
test<-fread('./project/volume/data/raw/test.csv')
solution<-fread('./project/volume/data/raw/sample_submission.csv')


test$SalePrice<-0

train$train<-1
test$train<-0

master<-rbind(train,test)


sub_master<-master[,.(OverallCond,GrLivArea,SalePrice,train)]


train<-sub_master[train==1]
test<-sub_master[train==0]

train$train<-NULL
test$train<-NULL



fwrite(train,'./project/volume/data/interim/train.csv')
fwrite(test,'./project/volume/data/interim/test.csv')


