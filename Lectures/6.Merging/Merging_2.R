library(data.table)


#This reads in the flight data and stores it as an object called 'DT'
ind<-fread("./Lectures/Data/PUBG/ind_rip_stats.csv")

mat<-fread("./Lectures/Data/PUBG/match_stats.csv")
#This reads in the data about airports and stores it as an object called 'AP'



mat<-mat[,c("match_id","party_size","game_size","player_kills")]

mat<-mat[!duplicated(mat$match_id),]

system.time(merge(ind,mat,all.x=T))

setkey(mat,match_id)
setkey(ind,match_id)

system.time(merge(ind,mat,all.x=T))



mat_stats<-merge(ind,mat,all.x=T)

ggplot(mat_stats[killer_placement==1],aes(x=victim_placement))+geom_density()





