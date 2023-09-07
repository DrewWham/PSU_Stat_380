set.seed(77)

train<-fread('./project/volume/data/raw/train.csv')
test<-fread('./project/volume/data/raw/test.csv')

train<-train[,.(DepTime,Distance,UniqueCarrier,DepDelay)]
test<-test[,.(DepTime,UniqueCarrier,Distance)]

fwrite(train,"./project/volume/data/interim/train.csv")
fwrite(test,"./project/volume/data/interim/test.csv")

