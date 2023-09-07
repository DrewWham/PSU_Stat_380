library(data.table)
set.seed(77)

DT<-fread('./project/volume/data/raw/2008.csv')

sub_DT<-DT[!is.na(DT$DepDelay)]

# here I divide the data into train and test so that I'm working on a similar problem as all of you
# note that you do not need to do this on your dataset
rand_inx<-sample(1:nrow(sub_DT),1000000)

train<-sub_DT[!rand_inx,]
test<-sub_DT[rand_inx,]

train$id<-1:nrow(train)
test$id<-1:nrow(test)

train$id<-paste0("train_",train$id)
test$id<-paste0("test_",test$id)

fwrite(train,'./project/volume/data/raw/train.csv')
fwrite(test[,.(id,DepDelay)],'./project/volume/data/raw/solution.csv')
test$DepDelay<-1
fwrite(test,'./project/volume/data/raw/test.csv')



