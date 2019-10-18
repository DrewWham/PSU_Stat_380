#load in libraries
library(data.table)
library(caret)
library(Metrics)
library(glmnet)
library(plotmo)
library(lubridate)



#read in data, notice the path will always look like this because the assumed working directory is the repo level folder
train<-fread("./project/volume/data/interim/train_v1.csv")
test<-fread("./project/volume/data/interim/test_v1.csv")
example_sub<-fread("./project/volume/data/raw/example_submission.csv")

##########################
# Prep Data for Modeling #
##########################

# make train and test have the same columns
test$future_price<-0

Q1_train<-train[!current_date %in% c("2019-01-25","2019-05-03","2019-07-12")]
Q1_test<-train[current_date %in% c("2019-01-25")]
Q2_train<-train[!current_date %in% c("2019-05-03","2019-07-12")]
Q2_test<-train[current_date %in% c("2019-05-03")]
Q3_train<-train[!current_date %in% c("2019-07-12")]
Q3_test<-train[current_date %in% c("2019-07-12")]

Q1_year_num<-as.numeric(as.factor(year(as_date(Q1_train$current_date))))
Q2_year_num<-as.numeric(as.factor(year(as_date(Q2_train$current_date))))
Q3_year_num<-as.numeric(as.factor(year(as_date(Q3_train$current_date))))

# keep the full test for evaluation

Q1_full<-Q1_test
Q2_full<-Q2_test
Q3_full<-Q3_test

# subset out only the columns to model

drops<- c('id','future_date','current_date')
Q1_train<-Q1_train[, !drops, with = FALSE]
Q1_test<-Q1_test[, !drops, with = FALSE]
Q2_train<-Q2_train[, !drops, with = FALSE]
Q2_test<-Q2_test[, !drops, with = FALSE]
Q3_train<-Q3_train[, !drops, with = FALSE]
Q3_test<-Q3_test[, !drops, with = FALSE]

#save the response var because dummyVars will remove
Q1_train_y<-Q1_train$future_price
Q2_train_y<-Q2_train$future_price
Q3_train_y<-Q3_train$future_price

# work with dummies

dummies <- dummyVars(future_price ~ ., data = Q1_train)
Q1_train<-predict(dummies, newdata = Q1_train)
Q1_test<-predict(dummies, newdata = Q1_test)


dummies <- dummyVars(future_price ~ ., data = Q2_train)
Q2_train<-predict(dummies, newdata = Q2_train)
Q2_test<-predict(dummies, newdata = Q2_test)


dummies <- dummyVars(future_price ~ ., data = Q3_train)
Q3_train<-predict(dummies, newdata = Q3_train)
Q3_test<-predict(dummies, newdata = Q3_test)


Q1_train<-data.table(Q1_train)
Q1_test<-data.table(Q1_test)

Q2_train<-data.table(Q2_train)
Q2_test<-data.table(Q2_test)

Q3_train<-data.table(Q3_train)
Q3_test<-data.table(Q3_test)

########################
# Use cross validation #
########################

Q1_train<-as.matrix(Q1_train)
Q1_gl_model<-cv.glmnet(Q1_train, Q1_train_y, alpha = 1,family="gaussian",foldid = Q1_year_num,nfolds = length(unique(Q1_year_num)))
Q1_bestlam<-Q1_gl_model$lambda.min

Q2_train<-as.matrix(Q2_train)
Q2_gl_model<-cv.glmnet(Q2_train, Q2_train_y, alpha = 1,family="gaussian",foldid = Q2_year_num,nfolds = length(unique(Q2_year_num)))
Q2_bestlam<-Q2_gl_model$lambda.min

Q3_train<-as.matrix(Q3_train)
Q3_gl_model<-cv.glmnet(Q3_train, Q3_train_y, alpha = 1,family="gaussian",foldid = Q3_year_num,nfolds = length(unique(Q3_year_num)))
Q3_bestlam<-Q3_gl_model$lambda.min

####################################
# fit the model to all of the data #
####################################


#now fit the full model

#fit a logistic model
Q1_gl_model<-glmnet(Q1_train, Q1_train_y, alpha = 1,family="gaussian")
Q2_gl_model<-glmnet(Q2_train, Q2_train_y, alpha = 1,family="gaussian")
Q3_gl_model<-glmnet(Q3_train, Q3_train_y, alpha = 1,family="gaussian")

plot_glmnet(Q1_gl_model)
plot_glmnet(Q2_gl_model)
plot_glmnet(Q3_gl_model)

predict(Q1_gl_model,type="coefficients",s=Q1_bestlam, newx = Q1_test)
predict(Q2_gl_model,type="coefficients",s=Q2_bestlam, newx = Q2_test)
predict(Q3_gl_model,type="coefficients",s=Q3_bestlam, newx = Q3_test)


Q1_test<-as.matrix(Q1_test)
Q2_test<-as.matrix(Q2_test)
Q3_test<-as.matrix(Q3_test)

#use the full model
Q1_pred<-predict(Q1_gl_model,s=Q1_bestlam, newx = Q1_test)
Q2_pred<-predict(Q2_gl_model,s=Q2_bestlam, newx = Q2_test)
Q3_pred<-predict(Q3_gl_model,s=Q3_bestlam, newx = Q3_test)

#########################
# make a submision file #
#########################


#our file needs to follow the example submission file format.
#we need the rows to be in the correct order

Q1_full$pred_price<-Q1_pred
Q2_full$pred_price<-Q2_pred
Q3_full$pred_price<-Q3_pred

full_eval<-rbind(Q1_full,Q2_full)
full_eval<-rbind(full_eval,Q3_full)

mae(full_eval$future_price,full_eval$pred_price)

#now we can write out the eval
fwrite(full_eval,"./project/volume/data/processed/full_eval.csv")
