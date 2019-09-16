#load in libraries
library(data.table)


#read in data, notice the path will always look like this because the assumed working directory is the repo level folder
train<-fread("./project/volume/data/raw/train_file.csv")
test<-fread("./project/volume/data/raw/test_file.csv")



#fit a logistic model
logr_model<-glm(result ~ V1,data=train, family=binomial)


#assess model
summary(logr_model)


#save model
saveRDS(logr_model,"./project/volume/models/logr_lm.model")

pred<-predict(logr, newdata = test, type="response")

#our file needs to follow the example submission file format.
#we also need the rows to be in the correct order

submit<-data.table(id=c(1:100000))
submit$result<-pred


#now we can write out a submission
fwrite(submit,"./project/volume/data/processed/submit_logr.csv")
