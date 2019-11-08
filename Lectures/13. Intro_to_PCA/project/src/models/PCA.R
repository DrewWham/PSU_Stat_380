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

j_data<-data.frame(lapply(data, jitter,factor=0.01))

# do a pca
pca<-prcomp(j_data)

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
ggplot(pca_dt,aes(x=PC1,y=PC2,col=party))+geom_point()




# run t-sne on the PCAs, note that if you already have PCAs you need to set pca=F or it will run a pca again. 
# pca is built into Rtsne, ive run it seperatly for you to see the internal steps

tsne<-Rtsne(pca_dt,pca = F)

# grab out the coordinates
tsne_dt<-data.table(tsne$Y)

# add back in party and cats so we can see what the analysis did with them
tsne_dt$party<-party
tsne_dt$Cats<-data$Cats

# plot, note that in this case I have access to party so I can see that it seems to have worked, You do not have access
# to species so you will just be plotting in black to see if there are groups. 
ggplot(tsne_dt,aes(x=V1,y=V2,col=party))+geom_point()
