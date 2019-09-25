#load in libraries
library(data.table)
library(caret)
library(Metrics)


#read in data, notice the path will always look like this because the assumed working directory is the repo level folder
train<-fread("./project/volume/data/interim/train_v1.csv")
test<-fread("./project/volume/data/interim/test_v1.csv")
example_sub<-fread("./project/volume/data/raw/example_submission.csv")

##########################
# Prep Data for Modeling #
##########################

# make train and test have the same columns
test$future_price<-0

# subset out only the columns to model

keep<- c('current_price','rarity','future_price')
train<-train[,..keep]
test<-test[,..keep]

#save the response var because dummyVars will remove
train_y<-train$future_price


# work with dummies

dummies <- dummyVars(future_price ~ ., data = train)
train<-predict(dummies, newdata = train)
test<-predict(dummies, newdata = test)

train<-data.table(train)
test<-data.table(test)

train$future_price<-train_y

###########################################
# Use a hold-out set for local validation #
###########################################

#Split data into train and eval

indx <- createDataPartition(train$future_price, p = .8, 
                                  list = FALSE, 
                                  times = 1)
head(indx)


sub_train<-train[indx,]
eval<-train[-indx,]



#fit a linear model
line_model<-lm(future_price ~ current_price + rarityCommon + rarityMythic + rarityRare + rarityUncommon,data=sub_train)


#assess model
summary(line_model)


#predict eval
eval_y<-eval$future_price
eval$future_price<-NULL
eval_pred<-predict(line_model, newdata = eval)


eval_pred[is.na(eval_pred)]<-mean(sub_train$future_price)

mean(ae(eval_y,eval_pred))

####################################
# fit the model to all of the data #
####################################


#now fit the full model

#fit a logistic model
line_model<-lm(future_price ~ current_price + rarityCommon + rarityMythic + rarityRare + rarityUncommon,data=train)

#save model
saveRDS(line_model,"./project/volume/models/line_model.model")

#use the full model
pred<-predict(line_model, newdata = test)

#########################
# make a submision file #
#########################


#our file needs to follow the example submission file format.
#we need the rows to be in the correct order

example_sub$future_price<-pred


#now we can write out a submission
fwrite(example_sub,"./project/volume/data/processed/submit_1.csv")
