library(data.table)
library(Rtsne)
library(ggplot2)
library(caret)
library(ggplot2)
library(ClusterR)

set.seed(3)

# load in data 
gen_data<-fread("./project/volume/data/raw/data.csv")

id<-data$id

gen_data$locus_1<-as.character(gen_data$locus_1)
gen_data$locus_2<-as.character(gen_data$locus_2)
gen_data$locus_3<-as.character(gen_data$locus_3)
gen_data$locus_4<-as.character(gen_data$locus_4)
gen_data$locus_5<-as.character(gen_data$locus_5)
gen_data$locus_6<-as.character(gen_data$locus_6)
gen_data$locus_7<-as.character(gen_data$locus_7)
gen_data$locus_8<-as.character(gen_data$locus_8)
gen_data$locus_9<-as.character(gen_data$locus_9)
gen_data$locus_10<-as.character(gen_data$locus_10)
gen_data$locus_11<-as.character(gen_data$locus_11)
gen_data$locus_12<-as.character(gen_data$locus_12)
gen_data$locus_13<-as.character(gen_data$locus_13)
gen_data$locus_14<-as.character(gen_data$locus_14)
gen_data$locus_15<-as.character(gen_data$locus_15)


dummies <- dummyVars(id~ ., data = gen_data)
gen_data<-predict(dummies, newdata = gen_data)

# do a pca
pca<-prcomp(gen_data)

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


# see a plot with the party data 
ggplot(pca_dt,aes(x=PC1,y=PC2))+geom_point()




# run t-sne on the PCAs, note that if you already have PCAs you need to set pca=F or it will run a pca again. 
# pca is built into Rtsne, ive run it seperatly for you to see the internal steps

tsne<-Rtsne(gen_data)

# grab out the coordinates
tsne_dt<-data.table(tsne$Y)


# plot, note that in this case I have access to party so I can see that it seems to have worked, You do not have access
# to species so you will just be plotting in black to see if there are groups. 
ggplot(tsne_dt,aes(x=V1,y=V2))+geom_point()



# use a gaussian mixture model to find optimal k and then get probability of membership for each row to each group

# this fits a gmm to the data for all k=1 to k= max_clusters, we then look for a major change in likelihood between k values
k_bic<-Optimal_Clusters_GMM(pca_dt[,.(PC1,PC2)],max_clusters = 10,criterion = "BIC")

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

# now we run the model with our chosen k value
gmm_data<-GMM(pca_dt[,.(PC1,PC2)],opt_k)

# the model gives a log-likelihood for each datapoint's membership to each cluster, me need to convert this 
# log-likelihood into a probability

l_clust<-gmm_data$Log_likelihood

l_clust<-data.table(l_clust)

net_lh<-apply(l_clust,1,FUN=function(x){sum(1/x)})

cluster_prob<-1/l_clust/net_lh

# we can now plot to see what cluster 1 looks like

pca_dt$Cluster_1_prob<-cluster_prob$V1
pca_dt$Cluster_2_prob<-cluster_prob$V2
pca_dt$Cluster_3_prob<-cluster_prob$V3

ggplot(pca_dt,aes(x=PC1,y=PC2,col=Cluster_1_prob))+geom_point()

cluster_prob$id<-id

setnames(cluster_prob, c("V1","V2","V3"),c("species3","species1","species2"))

cluster_prob<-cluster_prob[,.(id,species1,species2,species3)]

cluster_prob$species4<-0
cluster_prob$species5<-0
cluster_prob$species6<-0
cluster_prob$species7<-0
cluster_prob$species8<-0
cluster_prob$species9<-0
cluster_prob$species10<-0

fwrite(cluster_prob,"sub9.csv")




