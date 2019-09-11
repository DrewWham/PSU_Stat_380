#load in libraries
library(data.table)


#read in data, notice the path will always look like this because the assumed working directory is the repo level folder
train<-fread("./project/volume/data/raw/Stat_380_train.csv")
test<-fread("./project/volume/data/raw/Stat_380_test.csv")


sub_train<-train[,.(OverallQual,SalePrice)]


#fit a linear model
lm_model<-lm(SalePrice~OverallQual,data=sub_train)


#assess model
summary(lm_model)


#plot model
ggplot(sub_train,aes(OverallQual,SalePrice)) + geom_point()+
  geom_smooth(method='lm',formula=y~x)

#or
pred_dt<-data.table(OverallQual=c(1:10))
pred_vals<-predict(lm_model,newdata = pred_dt)

pred_dt$SalePrice<-pred_vals

ggplot(sub_train, aes(x = OverallQual, y = SalePrice)) + 
  geom_point(color='blue') +
  geom_line(color='red',data = pred_dt, aes(x = OverallQual, y = SalePrice))


#save model
saveRDS(lm_model,"./project/volume/models/OverallQual_lm.model")

test$SalePrice<-predict(lm_model,newdata = test[,.(OverallQual)])

#our file needs to follow the example submission file format. So we need to only have the Id and saleprice column and
#we also need the rows to be in the correct order

submit<-test[,.(Id,SalePrice)][order(Id)]

#now we can write out a submission
fwrite(submit,"./project/volume/data/processed/submit_OverallQual_lm.csv")
