library(data.table)
library(Rtsne)
library(ggplot2)
library(caret)
library(ggplot2)
library(ClusterR)

set.seed(3)

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
ggplot(tsne_dt,aes(x=V1,y=V2,col=Cats))+geom_point()



# use a gaussian mixture model to find optimal k and then get probability of membership for each row to each group

# this fits a gmm to the data for all k=1 to k= max_clusters, we then look for a major change in likelihood between k values
k_bic<-Optimal_Clusters_GMM(tsne_dt[,.(V1,V2)],max_clusters = 10,criterion = "BIC")

# now we will look at the change in model fit between successive k values
delta_k<-c(NA,k_bic[-1] - k_bic[-length(k_bic)])

# I'm going to make a plot so you can see the values, this part isnt necessary
del_k_tab<-data.table(delta_k=delta_k,k=1:length(delta_k))

# plot 
ggplot(del_k_tab,aes(x=k,y=-delta_k))+geom_point()+geom_line()+
  scale_x_continuous(breaks = scales::pretty_breaks(n = 10))+
  geom_text(aes(label=k),hjust=0, vjust=-1)



##########################
# function for picking k #
##########################

getOptK <- function(x){
  x <- abs(x)
  max_delta_k_pos <- which.max(x)
  max_delta_k <- max(na.omit(x))
  n2eval<-(length(x) - max_delta_k_pos) - 2
  for(i in max_delta_k_pos:(max_delta_k_pos+n2eval)){
    if(x[max_delta_k_pos + 1]/max_delta_k < 0.15 & x[max_delta_k_pos + 2]/max_delta_k < 0.15 & x[max_delta_k_pos + 3]/max_delta_k < 0.15){
    }else{
      max_delta_k_pos <- max_delta_k_pos + 1
    }
  }
  max_delta_k_pos
}


# You may visualy inspect the plot to pick the optimal k, I have writen a function that expresses the logic that I use
opt_k<-getOptK(delta_k)

opt_k<-2

# now we run the model with our chosen k value
gmm_data<-GMM(tsne_dt[,.(V1,V2)],opt_k)

# the model gives a log-likelihood for each datapoint's membership to each cluster, me need to convert this 
# log-likelihood into a probability

l_clust<-gmm_data$Log_likelihood^10

l_clust<-data.table(l_clust)

net_lh<-apply(l_clust,1,FUN=function(x){sum(1/x)})

cluster_prob<-1/l_clust/net_lh

# we can now plot to see what cluster 1 looks like

tsne_dt$Cluster_1_prob<-cluster_prob$V1

ggplot(tsne_dt,aes(x=V1,y=V2,col=Cluster_1_prob))+geom_point()








