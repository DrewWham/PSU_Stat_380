#load in libraries
library(data.table)

#read in data, notice the path will always look like this because the assumed working directory is the repo level folder
test<-fread("./project/volume/data/raw/Stat_380_test.csv")
avg_model<-fread("./project/volume/data/interim/bedroom_model.csv")

#if we set keys the subsequent merge will assume that the common keys are the columns that should be merged on. 
#also, if we were working with a large dataset this would speed up the merge significantly. 

setkey(test,BedroomAbvGr)
setkey(avg_model,BedroomAbvGr)

#merge the average table onto the larger test set table, then you will have a sale price value for every house
test<-merge(test,avg_model)

#our file needs to follow the example submission file format. So we need to only have the Id and saleprice column and
#we also need the rows to be in the correct order

submit<-test[,.(Id,SalePrice)][order(Id)]

#now we can write out a submission
fwrite(submit,"./project/volume/data/processed/submit_1.csv")