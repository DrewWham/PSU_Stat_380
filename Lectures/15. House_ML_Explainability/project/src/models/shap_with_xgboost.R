library(xgboost)
library(caret)
library(data.table)
library(ggplot2)
library(tidyverse)
#devtools::install_github("liuyanguu/SHAPforxgboost")

#for R
#https://liuyanguu.github.io/post/2019/07/18/visualization-of-shap-for-xgboost/

#for Python
#https://github.com/slundberg/shap

library('SHAPforxgboost')
#source("../../shap.R")

set.seed(777)


train<-fread('./project/volume/data/raw/Stat_380_train.csv')
test<-fread('./project/volume/data/raw/Stat_380_test.csv')

train$Id<-NULL
test$Id<-NULL

y.train<-train$SalePrice

test$SalePrice<-100


dummies <- dummyVars(SalePrice ~ ., data = train)
train<-predict(dummies, newdata = train)
test<-predict(dummies, newdata = test)


dtrain<-xgb.DMatrix(train, label=y.train,missing=NA)
dtest<-xgb.DMatrix(test,missing=NA)

watchlist <- list(train = dtrain)

params <- list(  objective           = "reg:linear",
                 gamma               =0.02,
                 booster             = "gbtree",
                 eval_metric         = "rmse",
                 eta                 = 0.005,
                 max_depth           = 10,
                 subsample           = 0.8,
                 colsample_bytree    = 0.8
)


xgbst_m <- xgb.train(params, dtrain, nrounds = 1400, watchlist)

preds<-predict(xgbst_m, newdata=dtest,missing=NA)


## Calculate shap values

shap_values <- shap.values(xgb_model = xgbst_m , X_train = train[1:1000,])



## Prepare data for top N variables
shap_long <- shap.prep(shap_contrib = shap_values$shap_score, X_train = train[1:1000,])


#shap summary
shap.plot.summary(shap_long)

shap.plot.dependence(data_long = shap_long, x = 'OverallQual', y = 'OverallQual', color_feature = 'TotRmsAbvGrd') + ggtitle("(A) SHAP values")
shap.plot.dependence(data_long = shap_long, x = 'TotRmsAbvGrd', y = 'TotRmsAbvGrd', color_feature = 'OverallQual') + ggtitle("(A) SHAP values")
shap.plot.dependence(data_long = shap_long, x = 'TotalBsmtSF', y = 'TotalBsmtSF', color_feature = 'OverallQual') + ggtitle("(A) SHAP values")
shap.plot.dependence(data_long = shap_long, x = 'LotFrontage', y = 'LotFrontage', color_feature = 'OverallQual') + ggtitle("(A) SHAP values")
shap.plot.dependence(data_long = shap_long, x = 'OverallCond', y = 'OverallCond', color_feature = 'OverallQual') + ggtitle("(A) SHAP values")


#shap_int <- shap.prep.interaction(xgb_mod = xgbst_m, X_train = train[1:100,])

#shap.plot.dependence(data_long = shap_long,data_int = shap_int,x= "OverallQual", y = "TotRmsAbvGrd", color_feature = "TotRmsAbvGrd")

test<-fread('Stat_380_test.csv')

test<-test[,.(Id)]
test$SalePrice<-preds


fwrite(test,"Submit.csv")