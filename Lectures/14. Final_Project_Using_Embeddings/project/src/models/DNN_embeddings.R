library(httr)
library(data.table)
library(Rtsne)
library(ggplot2)
library(reticulate)
source("./project/src/models/cosine.R")

tf<-import("tensorflow")
hub<-import("tensorflow_hub")
np<-import("numpy")

module_url <- "https://tfhub.dev/google/universal-sentence-encoder/4"
model = hub$load(module_url)

set.seed(21)


getEmbeddings<-function(text){
  emb<-np$array(model(list(text)))
  emb
}



data<-fread('./project/volume/data/raw/Pets.csv')

emb_dt<-NULL


for (i in 1:length(data$text)){
  emb_dt<-rbind(emb_dt,getEmbeddings(data$text[i]))
  
}
emb_dt<-data.table(emb_dt)

tsne<-Rtsne(emb_dt,perplexity=10)

tsne_dt<-data.table(tsne$Y)

tsne_dt$pet<-data$Pet
tsne_dt$id<-data$PSU_access_id 

ggplot(tsne_dt,aes(x=V1,y=V2,col=pet,label=id))+geom_text()



neural_search<-function(new_text,n){
  new_emb<-getEmbeddings(new_text)
  data$cos_dist<-apply(emb_dt,1,function(x){return(cosine(as.numeric(new_emb),as.numeric(x)))})
  out<-data[order(-cos_dist)][1:n,]
  out
}

new_text<-"I have a tiny old dog that likes me to take him places."

neural_search(new_text,5)
