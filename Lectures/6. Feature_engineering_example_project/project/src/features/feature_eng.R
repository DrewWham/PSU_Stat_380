#load in libraries
library(data.table)
library(caret)
library(Metrics)


#read in data, notice the path will always look like this because the assumed working directory is the repo level folder
train<-fread("./project/volume/data/raw/train_file.csv")
test<-fread("./project/volume/data/raw/test_file.csv")


#Split data into train and eval

indx <- createDataPartition(train$result, p = .8, 
                                  list = FALSE, 
                                  times = 1)
head(indx)


sub_train<-train[indx,]
eval<-train[-indx,]





#fit a logistic model
sub_logr_model<-glm(result ~ V1 + V2,data=sub_train, family=binomial)


#assess model
summary(sub_logr_model)


#predict on subtrain

eval_pred<-predict(logr_model, newdata = eval, type="response")


mean(ll(eval$result,eval_pred))

#now fit the full model

#fit a logistic model
logr_model<-glm(result ~ V1 + V2,data=train, family=binomial)

#save model
saveRDS(logr_model,"./project/volume/models/logr_lm.model")

#use the full model
pred<-predict(logr_model, newdata = test, type="response")


#our file needs to follow the example submission file format.
#we also need the rows to be in the correct order

submit<-data.table(id=c(1:100000))
submit$result<-pred


#now we can write out a submission
fwrite(submit,"./project/volume/data/processed/submit_logr_2.csv")
