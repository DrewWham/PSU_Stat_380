#load in libraries
library(data.table)
library(caret)
library(Metrics)
library(xgboost)




#read in data, notice the path will always look like this because the assumed working directory is the repo level folder
train<-fread("./project/volume/data/raw/train.csv")
test<-fread("./project/volume/data/raw/test.csv")


##########################
# Prep Data for Modeling #
##########################
y.train<-train$y
y.test<-test$y

# work with dummies

dummies <- dummyVars(y~ ., data = train)
x.train<-predict(dummies, newdata = train)
x.test<-predict(dummies, newdata = test)




dtrain <- xgb.DMatrix(x.train,label=y.train,missing=NA)
dtest <- xgb.DMatrix(x.test,label=y.test,missing=NA)


########################
# Use cross validation #
########################

param <- list(  objective           = "reg:linear",
                gamma               =0.02,
                booster             = "gbtree",
                eval_metric         = "rmse",
                eta                 = 0.02,
                max_depth           = 10,
                subsample           = 0.9,
                colsample_bytree    = 0.9,
                tree_method = 'hist'
)


XGBm<-xgb.cv( params=param,nfold=5,nrounds=2000,missing=NA,data=dtrain,print_every_n=1)


####################################
# fit the model to all of the data #
####################################

watchlist <- list(eval = dtest, train = dtrain)
#now fit the full model
XGBm<-xgb.train( params=param,nrounds=200,missing=NA,data=dtrain,watchlist,early_stop_round=20,print_every_n=1)

