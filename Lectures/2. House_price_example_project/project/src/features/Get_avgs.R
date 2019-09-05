#load in libraries
library(data.table)

#read in data, notice the path will always look like this because the assumed working directory is the repo level folder
train<-fread("./project/volume/data/raw/Stat_380_train.csv")


#make a simple model
#here I will make a simple mode where I get the average by the number of bedrooms then I will guess that the
#test set houses will be priced at the average price for houses in the training set with the same number of bedrooms

#notice that I'm calling this "SalePrice" obviously it is not, but in this case I'm going to submit it as my prediction
#for the sale price. Having this name will make things easy later. We could also give it a more logical name then
#change the name later before we submit

bedroom_avg<-train[,.(SalePrice=mean(SalePrice)),by="BedroomAbvGr"][order(-SalePrice)]


#this new table will be useful in making our predictions, lets save it so we can use it

fwrite(bedroom_avg,"./project/volume/data/interim/bedroom_model.csv")
