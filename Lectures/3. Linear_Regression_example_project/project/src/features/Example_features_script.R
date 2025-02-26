library(data.table)
library(lubridate)
message("Feature Script running")
set.seed(77)

train<-fread('./project/volume/data/raw/train.csv')
test<-fread('./project/volume/data/raw/test.csv')

test$DepDelay<-0

train$train<-1
test$train<-0

train$sort_col<-1:nrow(train)
test$sort_col<-1:nrow(test)

master<-rbind(train,test)


# Convert the numeric time into a zero-padded string of length 4
master$DepTime <- sprintf("%04d", master$DepTime)
  
# Parse time as "hour:minute" using lubridate::hm
master$hour <- as.numeric(substr(master$DepTime, 1, 2))
master$minute<- as.numeric(substr(master$DepTime, 3, 4))
    
  
# Calculate total minutes past midnight
master$Dept_minute <- (master$hour * 60) + master$minute
  
 
train<-master[train==1]
test<-master[train==0]


train<-train[order(sort_col)]
test<-test[order(sort_col)]




train<-train[,.(Dept_minute,Distance,UniqueCarrier,DepDelay)]
test<-test[,.(Dept_minute,Distance,UniqueCarrier)]

fwrite(train,"./project/volume/data/interim/train.csv")
fwrite(test,"./project/volume/data/interim/test.csv")

message("Feature Script done")
