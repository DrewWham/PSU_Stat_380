#load in libraries
library(data.table)
library(caret)
library(Metrics)
library(glmnet)
library(plotmo)
library(lubridate)



#read in data, notice the path will always look like this because the assumed working directory is the repo level folder
test<-fread("./project/volume/data/interim/test_v1.csv")
example_sub<-fread("./project/volume/data/raw/example_submission.csv")

##########################
# Prep Data for Modeling #
##########################

# make train and test have the same columns
test$future_price<-0

# subset out only the columns to model

drops<- c('id','future_date','current_date')
test<-test[, !drops, with = FALSE]


# work with dummies

dummies <- readRDS("./project/volume/models/glm_model.dummies")
test<-predict(dummies, newdata = test)


test<-data.table(test)



########################
# Use cross validation #
########################



bestlam<-0.03326094



####################################
# fit the model to all of the data #
####################################



#read model
gl_model<-readRDS("./project/volume/models/gl_model.model")

test<-as.matrix(test)

#use the full model
pred<-predict(gl_model,s=bestlam, newx = test)



#########################
# make a submision file #
#########################


#our file needs to follow the example submission file format.
#we need the rows to be in the correct order

example_sub$future_price<-pred


#now we can write out a submission
fwrite(example_sub,"./project/volume/data/processed/submit_mtg2_v2.csv")
