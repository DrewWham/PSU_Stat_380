#load in libraries
library(data.table)
library(carat)


#read in data, notice the path will always look like this because the assumed working directory is the repo level folder
train<-fread("./project/volume/data/raw/Stat_380_train.csv")
test<-fread("./project/volume/data/raw/Stat_380_test.csv")

#subset the data
sub_train<-train[,.(OverallQual,BldgType,SalePrice)]
sub_test<-test[,.(OverallQual,BldgType)]

#add a column to test so that it is the same size as train
sub_test$SalePrice<-1
#save the response var because dummyVars will remove
sub_train_y<-sub_train$SalePrice


dummies <- dummyVars(SalePrice ~ ., data = sub_train)
sub_train<-predict(dummies, newdata = sub_train)
sub_test<-predict(dummies, newdata = sub_test)

#reformat after dummyVars and add back response Var

sub_train<-data.table(sub_train)
sub_train$SalePrice<-sub_train_y
sub_test<-data.table(sub_test)


#fit a linear model
lm_model<-lm(SalePrice~OverallQual+BldgType1Fam+BldgType2fmCon+BldgTypeDuplex+BldgTypeTwnhs+BldgTypeTwnhsE,data=sub_train)


#assess model
summary(lm_model)



#save model
saveRDS(dummies,"./project/volume/models/OverallQual_BldgType_lm.dummies")
saveRDS(lm_model,"./project/volume/models/OverallQual_BldgType_lm.model")

test$SalePrice<-predict(lm_model,newdata = sub_test)

#our file needs to follow the example submission file format. So we need to only have the Id and saleprice column and
#we also need the rows to be in the correct order

submit<-test[,.(Id,SalePrice)][order(Id)]

#now we can write out a submission
fwrite(submit,"./project/volume/data/processed/OverallQual_BldgType_lm.csv")
