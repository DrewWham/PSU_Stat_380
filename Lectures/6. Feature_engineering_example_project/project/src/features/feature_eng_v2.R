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

card_tab$Legendary<-0
card_tab$Legendary[grep("Legendary",card_tab$supertypes)]<-1

types_tab<-as.data.table(tstrsplit(card_tab$types," "))
types_tab$id<-card_tab$id
m_types_tab<-melt(types_tab,id.vars = "id")
m_types_tab<-m_types_tab[!is.na(m_types_tab$value)]
m_types_tab$True<-1
types_tab<-dcast(m_types_tab,id ~ value,length,value.var="True")

master<-merge(master,card_tab[,.(id,rarity,Legendary)],all.x=T)
master<-merge(master,types_tab,all.x=T)

master$current_price[is.na(master$current_price)]<-mean(master$current_price,na.rm=T)

master[is.na(master)]<-0



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

fwrite(train,"./project/volume/data/interim/train_mtg.csv")
fwrite(test,"./project/volume/data/interim/test_mtg.csv")
