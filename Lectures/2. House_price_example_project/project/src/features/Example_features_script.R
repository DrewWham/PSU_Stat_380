library(data.table)
set.seed(77)

DT<-fread('./project/volume/data/raw/2008.csv')

sub_DT<-DT[!is.na(DT$DepDelay)][,.(UniqueCarrier,Origin,DepDelay)]

# here I divide the data into train and test so that I'm working on a similar problem as all of you
# note that you do not need to do this on your dataset
rand_inx<-sample(1:nrow(sub_DT),1000000)

train<-sub_DT[!rand_inx,]
test<-sub_DT[rand_inx,]

train$id<-1:nrow(train)
test$id<-1:nrow(test)

fwrite(train,'./project/volume/data/interim/train.csv')
fwrite(test[,.(id,DepDelay)],'./project/volume/data/interim/solution.csv')
fwrite(test[,.(id,UniqueCarrier, Origin)],'./project/volume/data/interim/test.csv')

test$DepDelay<-1
fwrite(test[,.(id,DepDelay)],'./project/volume/data/interim/example_sub.csv')
