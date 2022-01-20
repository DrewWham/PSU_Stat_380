library(data.table)
library(Metrics)


#download.file(url="https://s3.amazonaws.com/stat.184.data/Flights/2008.csv",destfile='./project/volume/data/raw/2008.csv', method='curl')
#download.file(url="https://s3.amazonaws.com/stat.184.data/Flights/airports.csv",destfile='./project/volume/data/raw/airports.csv', method='curl')

train<-fread('./project/volume/data/interim/train.csv')
test<-fread('./project/volume/data/interim/test.csv')



# make a null model

avg_delay<-mean(train$DepDelay)

test$DepDelay<-avg_delay

fwrite(test[,.(id,DepDelay)],'./project/volume/data/processed/Null_model.csv')

test$DepDelay<-NULL

#This solution file can be tested on kaggle https://www.kaggle.com/t/8c4f411c42c84d45add3a44cbd516046


#group by airport first to make a little more interesting model

origin_delay<-train[,.(DepDelay=mean(DepDelay)),by=Origin]

setkey(origin_delay,Origin)
setkey(test,Origin)

test<-merge(test,origin_delay, all.x=T)

test<-test[order(id)]

fwrite(test[,.(id,DepDelay)],'./project/volume/data/processed/Origin_avg.csv')

test$DepDelay<-NULL

# group by Carrier and Origin

originCarrier_delay<-train[,.(DepDelay=mean(DepDelay)),by=c('Origin','UniqueCarrier')]

setkey(originCarrier_delay,Origin, UniqueCarrier)
setkey(test,Origin,UniqueCarrier)

test<-merge(test,originCarrier_delay, all.x=T)

test<-test[order(id)]

fwrite(test[,.(id,DepDelay)],'./project/volume/data/processed/OriginCarrier_avg.csv')




