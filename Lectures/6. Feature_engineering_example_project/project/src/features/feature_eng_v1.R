#load in libraries
library(data.table)
library(caret)



#read in data, notice the path will always look like this because the assumed working directory is the repo level folder
train<-fread("./project/volume/data/raw/start_train.csv")
test<-fread("./project/volume/data/raw/start_test.csv")
card_tab<-fread("./project/volume/data/raw/card_tab.csv")


#######################
# make a master table #
#######################

# First make train and test the same dim, then bind into one table so you can do the same thing to both datasets

# make a future price column for test, even though it is unknown. We will not use this, this is only to make
# them two tables the same size

test$future_price<-0

#add a column that lets you easily differentiate between train and test rows once they are together
test$train<-0
train$train<-1

#now bind them together

master<-rbind(train,test)


###################
# add in features #
###################

setkey(master,id)
setkey(card_tab,id)

master<-merge(master,card_tab[,.(id,rarity)],all.x=T)


############################
# split back to train/test #
############################

# split
train<-master[train==1]
test<-master[train==0]

# clean up columns
train$train<-NULL
test$train<-NULL
test$future_price<-NULL


########################
# write out to interim #
########################

fwrite(train,"./project/volume/data/interim/train_v1.csv")
fwrite(test,"./project/volume/data/interim/test_v1.csv")
