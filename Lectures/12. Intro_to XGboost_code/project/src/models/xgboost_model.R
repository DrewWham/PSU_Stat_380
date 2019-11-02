#load in libraries
library(data.table)
library(caret)
library(Metrics)
library(xgboost)




#read in data, notice the path will always look like this because the assumed working directory is the repo level folder
test<-fread("./project/volume/data/raw/test.csv")
train<-fread("./project/volume/data/raw/train.csv")



##########################
# Prep Data for Modeling #
##########################
y.train<-train$y
y.test<-test$y

# work with dummies

dummies <- dummyVars(y~ ., data = train)
x.train<-predict(dummies, newdata = train)
x.test<-predict(dummies, newdata = test)



# notice that I've removed label=y in the dtest line, I have y available to me with the fake data from class but
# you dont have that for the house prices.
dtrain <- xgb.DMatrix(x.train,label=y.train,missing=NA)
dtest <- xgb.DMatrix(x.test,missing=NA)


########################
# Use cross validation #
########################

param <- list(  objective           = "reg:linear",
                gamma               =0.02,
                booster             = "gbtree",
                eval_metric         = "rmse",
                eta                 = 0.002,
                max_depth           = 10,
                subsample           = 0.9,
                colsample_bytree    = 0.9,
                tree_method = 'hist'
)


XGBm<-xgb.cv( params=param,nfold=5,nrounds=1000,missing=NA,data=dtrain,print_every_n=1)


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

XGBm<-xgb.train( params=param,nrounds=1000,missing=NA,data=dtrain,watchlist=watchlist,print_every_n=1)

# just like the other model fitting methods we have seen, we can use the predict function to get predictions from the 
# model object as long as the new data is identical in format to the training data. Note that this code saves the
# predictions as a vector, you will need to get this vector into the correct column to make a submission file. 
pred<-predict(XGBm, newdata = dtest)


