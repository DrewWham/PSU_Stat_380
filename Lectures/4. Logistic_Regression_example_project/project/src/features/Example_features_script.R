library(data.table)
library(ISLR)
set.seed(77)

market_DT<-data.table(Smarket)

market_DT$Today<-NULL


market_DT$Direction<-1*(market_DT$Direction=="Up")


# here I divide the data into train and test so that I'm working on a similar problem as all of you
# note that you do not need to do this on your dataset

train<-market_DT[!Year==2005,]
test<-market_DT[Year==2005,]

train$Year<-NULL
test$Year<-NULL

fwrite(train,'./project/volume/data/interim/train.csv')
fwrite(test,'./project/volume/data/interim/test.csv')

