library(httr)
library(data.table)
library(Rtsne)
library(ggplot2)


getEmbeddings<-function(text){
input <- list(
  instances =list( text)
)
res <- POST("https://dsalpha.vmhost.psu.edu/api/use/v1/models/use:predict", body = input,encode = "json", verbose())
emb<-unlist(content(res)$predictions)
emb
}



data<-fread('./project/volume/data/raw/Pets.csv')

emb_dt<-NULL
as.data.frame.table(emb_dt)

for (i in 1:length(data$text)){
  emb_dt<-rbind(emb_dt,getEmbeddings(data$text[i]))
  
}
emb_dt<-data.table(emb_dt)

tsne<-Rtsne(emb_dt,perplexity=5)

tsne_dt<-data.table(tsne$Y)

tsne_dt$pet<-data$Pet
tsne_dt$id<-data$PSU_access_id 

ggplot(tsne_dt,aes(x=V1,y=V2,col=pet,label=id))+geom_text()
