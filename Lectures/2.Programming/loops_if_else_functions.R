library(data.table)
library(rvest)
library(reshape2)
library(ggplot2)
library(jsonlite)

#for loop
series<-NULL
for (i in 1:50){
	k<-2^i	
	series<-c(series,k)	
}





#while loop
series<-NULL
sec<-0
start<-Sys.time()
while (sec < 30){
	i<-i+1
	k<-2^i	
	series<-c(series,k)	
	sec<-Sys.time()-start
}



#if else statement
set<-c(0,NA,1)
rand_samp<-sample(set,10,replace=T)

series<-NULL
j<-NULL
for (i in 1:length(rand_samp)){

	
	if (is.na(rand_samp[i])){
		j<-j
		series<-series
	}
	else {
	j<-c(j,rand_samp[i])
	series<-c(series,sum(j)/i)	
	}
	
}



#function

coin_flips<-function(n){
	rand_samp<-sample(c(1,0),n,replace=T)
	freq<-mean(rand_samp)
	freq
}



#nested for loops and a plot
DT<-NULL
for(i in 1:10000){

	samp_sizes<-c(5,10,50,100,1000)
	series<-NULL
	for(j in 1:length(samp_sizes)){
		freq<-coin_flips(samp_sizes[j])
		series<-c(series,freq)
	}

DT<-rbind(DT,series)
}

DT<-data.table(DT)
setnames(DT,c("V1","V2","V3","V4","V5"),c("samp_5","samp_10","samp_50","samp_100","samp_1000"))
m_DT<-melt(DT,measure=names(DT))
ggplot(m_DT,aes(x=value,col=variable))+geom_density()


#a classroom exercise and a challange:

#This function takes 2 arguments, a username and code made of zeros and ones. it will reply back with a % correct
#write a function to solve the 5 binary unit code
submitCode<-function(user_id,code){
url <- paste0("https://dsdemo.vmhost.psu.edu/api/nlp/CodeBreak_5?user_id=",user_id,"&x=",code)
read_json(url)[[1]]
}

#as a challange i have set up another binary code that is 256 units long. I will give you a 100% on your lowest homework
#if you break it. I will also give a lettergrade on the final to the student that breaks it in the lowest number of submissions
#be careful to listen to the rules given in class and in the assignment email.
submitCode256<-function(user_id,x){
url <- paste0("https://dsdemo.vmhost.psu.edu/api/nlp/CodeBreak_256?user_id=",user_id,"&x=",x)
read_json(url)[[1]]
}

#example

submitCode("fcw5014","11111")




