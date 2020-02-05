library(data.table)
library(ISLR)
set.seed(77)

market_DT<-data.table(Smarket)

market_DT$Today<-NULL
market_DT$Year<-NULL

market_DT$Direction<-1*(market_DT$Direction=="Up")


# here I divide the data into train and test so that I'm working on a similar problem as all of you
# note that you do not need to do this on your dataset
rand_inx<-sample(1:nrow(market_DT),250)

train<-market_DT[!rand_inx,]
test<-market_DT[rand_inx,]

fwrite(train,'./project/volume/data/interim/train.csv')
fwrite(test,'./project/volume/data/interim/test.csv')

