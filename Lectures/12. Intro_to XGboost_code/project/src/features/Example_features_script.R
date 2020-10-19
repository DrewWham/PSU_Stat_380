library(data.table)
set.seed(77)

DT<-fread('./project/volume/data/raw/2008.csv')

pairs(DepDelay~CRSDepTime+Distance,data=DT[1:1000,])

DT[is.na(DT$DepDelay)]$DepDelay<-0

sub_DT<-DT[,.(UniqueCarrier,CRSDepTime,Distance,DepDelay)]

# here I divide the data into train and test so that I'm working on a similar problem as all of you
# note that you do not need to do this on your dataset
rand_inx<-sample(1:nrow(sub_DT),1000000)

train<-sub_DT[!rand_inx,]
test<-sub_DT[rand_inx,]

fwrite(train[1:100000,],'./project/volume/data/interim/train.csv')
fwrite(test,'./project/volume/data/interim/test.csv')

