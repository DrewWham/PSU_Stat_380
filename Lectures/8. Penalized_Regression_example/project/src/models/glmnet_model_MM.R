library(data.table)
library(caret)
library(Metrics)
library(glmnet)
library(plotmo)
library(lubridate)



#read in data, notice the path will always look like this because the assumed working directory is the repo level folder
train<-fread("./project/volume/data/interim/train.csv")
test<-fread("./project/volume/data/interim/test.csv")
example_sub<-fread("./project/volume/data/raw/example_sub_MM.csv")

##########################
# Prep Data for Modeling #
##########################


train_1<-train[Season<2015]
test_1<-train[Season==2015]

train_2<-train[Season<2016]
test_2<-train[Season==2016]

train_3<-train[Season<2017]
test_3<-train[Season==2017]



# subset out only the columns to model

drops<- c('team_1', 'team_2', 'Season')

train<-train[, !drops, with = FALSE]
test<-test[, !drops, with = FALSE]

train_1<-train_1[, !drops, with = FALSE]
test_1<-test_1[, !drops, with = FALSE]

train_2<-train_2[, !drops, with = FALSE]
test_2<-test_2[, !drops, with = FALSE]

train_3<-train_3[, !drops, with = FALSE]
test_3<-test_3[, !drops, with = FALSE]

#save the response var because dummyVars will remove
train_y<-train$result

train_1y<-train_1$result
train_2y<-train_2$result
train_3y<-train_3$result

test_1y<-test_1$result
test_2y<-test_2$result
test_3y<-test_3$result

test$result<-0

# work with dummies

dummies <- dummyVars(result ~ ., data = train)
train<-predict(dummies, newdata = train)
test<-predict(dummies, newdata = test)

train_1<-predict(dummies, newdata = train_1)
test_1<-predict(dummies, newdata = test_1)
train_2<-predict(dummies, newdata = train_2)
test_2<-predict(dummies, newdata = test_2)
train_3<-predict(dummies, newdata = train_3)
test_3<-predict(dummies, newdata = test_3)

train<-data.table(train)
test<-data.table(test)

train_1<-data.table(train_1)
test_1<-data.table(test_1)

train_2<-data.table(train_2)
test_2<-data.table(test_2)

train_3<-data.table(train_3)
test_3<-data.table(test_3)



########################
# Use cross validation #
########################




train<-as.matrix(train)
train_1<-as.matrix(train_1)
train_2<-as.matrix(train_2)
train_3<-as.matrix(train_3)

test<-as.matrix(test)
test_1<-as.matrix(test_1)
test_2<-as.matrix(test_2)
test_3<-as.matrix(test_3)

#note that your problem is a linear reg problem, this is a logistic regression problem
gl_model_1<-glmnet(train_1, train_1y, alpha = 1,family="binomial")

error_DT<-NULL
for (i in 1:length(unclass(gl_model_1)$lambda)){
  model_lambda<-unclass(gl_model_1)$lambda[i]
  pred<-predict(gl_model_1,s=model_lambda, newx = test_1,type="response")
  error<-mean(ll(test_1y,pred[,1]))
  new_row<-c(model_lambda,error)
  error_DT<-rbind(error_DT,new_row)
}

error_DT_1<-data.table(error_DT)
setnames(error_DT_1,c("V1","V2"),c("lambda","error"))

gl_model_2<-glmnet(train_2, train_2y, alpha = 1,"binomial")

error_DT<-NULL
for (i in 1:length(unclass(gl_model_2)$lambda)){
  model_lambda<-unclass(gl_model_2)$lambda[i]
  pred<-predict(gl_model_2,s=model_lambda, newx = test_2,type="response")
  error<-mean(ll(test_2y,pred[,1]))
  new_row<-c(model_lambda,error)
  error_DT<-rbind(error_DT,new_row)
}


error_DT_2<-data.table(error_DT)
setnames(error_DT_2,c("V1","V2"),c("lambda","error"))

gl_model_3<-glmnet(train_3, train_3y, alpha = 1,"binomial")

error_DT<-NULL
for (i in 1:length(unclass(gl_model_3)$lambda)){
  model_lambda<-unclass(gl_model_3)$lambda[i]
  pred<-predict(gl_model_3,s=model_lambda, newx = test_3,type="response")
  error<-mean(ll(test_3y,pred[,1]))
  new_row<-c(model_lambda,error)
  error_DT<-rbind(error_DT,new_row)
}

error_DT_3<-data.table(error_DT)
setnames(error_DT_3,c("V1","V2"),c("lambda","error"))

error_DT_1$Season<-2015
error_DT_2$Season<-2016
error_DT_3$Season<-2017

error_DT_full<-rbind(error_DT_1,error_DT_2,error_DT_3)

ggplot(error_DT_full,aes(x=log(lambda),y=error,col=Season))+geom_smooth()

lambda_1<-error_DT_full[error==min(error_DT_1$error)]$lambda
lambda_2<-error_DT_full[error==min(error_DT_2$error)]$lambda
lambda_3<-error_DT_full[error==min(error_DT_3$error)]$lambda
all_best_lambdas<-c(lambda_1,lambda_2,lambda_3)


bestlam<-mean(all_best_lambdas)

####################################
# fit the model to all of the data #
####################################


#now fit the full model

#fit a logistic model
gl_model<-glmnet(train, train_y, alpha = 1,"binomial")

plot_glmnet(gl_model)

#save model
saveRDS(gl_model,"./project/volume/models/gl_model.model")

test<-as.matrix(test)

#use the full model
pred<-predict(gl_model,s=bestlam, newx = test)

bestlam
predict(gl_model,s=bestlam, newx = test,type="coefficients")
gl_model

error_DT_full[error==min(error_DT_1$error)]
error_DT_full[error==min(error_DT_2$error)]
error_DT_full[error==min(error_DT_3$error)]

#########################
# make a submision file #
#########################


#our file needs to follow the example submission file format.
#we need the rows to be in the correct order

example_sub$future_price<-pred


#now we can write out a submission
fwrite(example_sub,"./project/volume/data/processed/submit_17.csv")
