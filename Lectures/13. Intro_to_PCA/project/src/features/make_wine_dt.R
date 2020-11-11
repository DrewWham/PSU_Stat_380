# Data found at: https://www.kaggle.com/danielpanizzo/wine-quality
library(data.table)


reds_dt<-fread("./project/volume/data/raw/wineQualityReds.csv")
whites_dt<-fread("./project/volume/data/raw/wineQualityWhites.csv")

reds_dt$type<-"red"
whites_dt$type<-"white"

wines_dt<-rbind(reds_dt,whites_dt)


wines_dt<-wines_dt[sample(1:nrow(wines_dt),nrow(wines_dt)),]

wines_dt$V1<-NULL

fwrite(wines_dt,"./project/volume/data/interim/wine.csv")




