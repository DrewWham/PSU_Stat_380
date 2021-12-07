library(httr)
library(data.table)
library(Rtsne)
library(ggplot2)
library(optparse)
library(xgboost)

# make an options parsing list
option_list = list(
  make_option(c("-t", "--text"), type="character", default=NULL,
              help="input text", metavar="character")
);

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

# get the arguments that were passed in
new_text<-opt$text

#new_text<- "How much would you pay for a 2020 model toyota tundra with the base package out the door?"

pca.model<-readRDS("./project/volume/models/pca.model")
xgb.model<-readRDS("./project/volume/models/XGBm.model")
ex_sub<-fread("./project/volume/data/raw/examp_sub.csv")

getEmbeddings<-function(text){
  input <- list(
    instances =list( text)
  )
  res <- POST("https://dsalpha.vmhost.psu.edu/api/use/v1/models/use:predict", body = input,encode = "json", verbose())
  emb<-unlist(content(res)$predictions)
  emb
}

new_text_emb<-getEmbeddings(new_text)



new_text_pca<-predict(pca.model,newdata=as.data.frame(t(new_text_emb)))

new_text_pca<-data.table(new_text_pca)

new_text_pca<-new_text_pca[,.(PC1,PC2,PC3,PC4,PC5,PC6,PC7)]

dtest <- xgb.DMatrix(as.matrix(new_text_pca),missing=NA)

pred<-predict(xgb.model, newdata = dtest )

results<-matrix(pred,ncol=11,byrow=T)
results<-data.table(results)

output<-ex_sub[1,2:ncol(ex_sub)]

output[1,]<-results

output$id<-1

output<-melt(output,id.vars = "id",variable.name = "reddit", value.name = "probability")

output<-output[order(-probability)]

output$id<-NULL

print(output)

