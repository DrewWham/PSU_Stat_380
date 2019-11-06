library(data.table)
library(Rtsne)
library(ggplot2)
library(caret)
library(ggplot2)


# load in data 
data<-fread("./project/volume/data/raw/data.csv")

# we are not supposed to know the party of the individuals so we should hide this
party<-data$party
data$party<-NULL

# do a pca
pca<-prcomp(data)

# look at the percent variance explained by each pca
screeplot(pca)

# look at the rotation of the variables on the PCs
pca

# see the values of the scree plot in a table 
summary(pca)

# see a biplot of the first 2 PCs
biplot(pca)

# use the unclass() function to get the data in PCA space
pca_dt<-data.table(unclass(pca)$x)

# add back the party to prove to ourselves that this works
pca_dt$party<-party

# see a plot with the party data 
ggplot(pca_dt,aes(x=PC1,y=PC4,col=party))+geom_point()
