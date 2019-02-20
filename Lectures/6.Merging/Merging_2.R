library(data.table)


#This reads in the flight data and stores it as an object called 'DT'
ind<-fread("./Lectures/Data/PUBG/ind_rip_stats.csv")

mat<-fread("./Lectures/Data/PUBG/match_stats.csv")
#This reads in the data about airports and stores it as an object called 'AP'


win_kills<-ind[killer_placement==1,c("killer_placement","match_id")]

mat_win_kills<-dcast(win_kills,match_id~.,length,value.var=c("match_id"))

setnames(mat_win_kills,".","winner_total_kills")

mat_win_kills<-data.table(mat_win_kills)

mat<-mat[,c("match_id","party_size","game_size")]

mat<-mat[!duplicated(mat$match_id),]

system.time(merge(mat_win_kills,mat,all.x=T))

setkey(mat,match_id)
setkey(mat_win_kills,match_id)

system.time(merge(mat_win_kills,mat,all.x=T))



mat_stats<-merge(mat_win_kills,mat,all.x=T)




dcast(mat_stats,party_size~.,mean,value.var=c("winner_total_kills"))
dcast(mat_stats,party_size~game_size,length,value.var=c("winner_total_kills"))



