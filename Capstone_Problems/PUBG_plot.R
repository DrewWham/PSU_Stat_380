library(data.table)
library(ggplot2)
DT<-fread("./Lectures/Data/PUBG/ind_rip_stats.csv")


W<-DT[,.(match_id,killer_name,time)]
L<-DT[,.(match_id,victim_name,time)]

setnames(W,"killer_name","player_name")
setnames(L,"victim_name","player_name")

W$success<-1
L$success<-0

nDT<-rbind(W,L)

#free up space
DT<-NULL
L<-NULL
gc()

nDT2<-nDT
nDT2$DT2_time<-nDT2$time
nDT$DT1_time<-nDT$time
nDT2$time<-nDT2$time-1


setkey(nDT,match_id,player_name,time)
setkey(nDT2,match_id,player_name,time)

rolled_DT<-nDT[nDT2,roll=T]

rolled_DT[player_name=="PDDBOSS",-1]

rolled_DT$success=NULL
rolled_DT$time=NULL
setnames(rolled_DT,c("i.success","DT1_time","DT2_time"),c("success","time_1","time_2"))


rolled_DT<-rolled_DT[!is.na(rolled_DT$time_1)]

rolled_DT$time_dif<-rolled_DT$time_2-rolled_DT$time_1

ggplot(rolled_DT,aes(x=time_dif,y=success))+geom_smooth()



