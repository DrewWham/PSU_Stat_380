#load in libraries
library(data.table)
library(caret)
library(Metrics)
library(xgboost)

#advanced methods of hyperparameter tuning discussed here:
#https://rpubs.com/jeandsantos88/search_methods_for_hyperparameter_tuning_in_r


#read in data, notice the path will always look like this because the assumed working directory is the repo level folder
test<-fread("./project/volume/data/interim/test_concrete.csv")
train<-fread("./project/volume/data/interim/train_concrete.csv")



##########################
# Prep Data for Modeling #
##########################
y.train<-train$Strength
y.test<-test$Strength

# work with dummies

dummies <- dummyVars(Strength~ ., data = train)
x.train<-predict(dummies, newdata = train)
x.test<-predict(dummies, newdata = test)



# notice that I've removed label=departure delay in the dtest line, I have departure delay available to me with the in my dataset but
# you dont have price for the house prices.
dtrain <- xgb.DMatrix(x.train,label=y.train,missing=NA)
dtest <- xgb.DMatrix(x.test,missing=NA)

hyper_perm_tune<-NULL
########################
# Use cross validation #
########################

param <- list(  objective           = "reg:linear",
                gamma               =0.00,
                booster             = "gbtree",
                eval_metric         = "rmse",
                eta                 = 0.02,
                max_depth           = 15,
                min_child_weight    = 1,
                subsample           = 1.0,
                colsample_bytree    = 1.0,
                tree_method = 'hist'
)


XGBm<-xgb.cv( params=param,nfold=5,nrounds=10000,missing=NA,data=dtrain,print_every_n=1,early_stopping_rounds=25)

best_ntrees<-unclass(XGBm)$best_iteration

new_row<-data.table(t(param))

new_row$best_ntrees<-best_ntrees

test_error<-unclass(XGBm)$evaluation_log[best_ntrees,]$test_rmse_mean
new_row$test_error<-test_error
hyper_perm_tune<-rbind(new_row,hyper_perm_tune)

####################################
# fit the model to all of the data #
####################################


# the watchlist will let you see the evaluation metric of the model for the current number of trees.
# in the case of the house price project you do not have the true houseprice on hand so you do not add it to the watchlist, just the dtrain
watchlist <- list( train = dtrain)

# now fit the full model
# I have removed the "early_stop_rounds" argument, you can use it to have the model stop training on its own, but
# you need an evaluation set for that, you do not have that available to you for the house data. You also should have 
# figured out the number of trees (nrounds) from the cross validation step above. 

XGBm<-xgb.train( params=param,nrounds=best_ntrees,missing=NA,data=dtrain,watchlist=watchlist,print_every_n=1)


# just like the other model fitting methods we have seen, we can use the predict function to get predictions from the 
# model object as long as the new data is identical in format to the training data. Note that this code saves the
# predictions as a vector, you will need to get this vector into the correct column to make a submission file. 
pred<-predict(XGBm, newdata = dtest)


# here I am not making a submission file because this data is not on kaggle, instead
# I am using the metrics package to check my test error

rmse(y.test,pred)


