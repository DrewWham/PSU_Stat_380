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
total<-10
set<-c(0,NA,1)
rand_samp<-sample(set,total,replace=T)

cumulative_avg<-NULL
j<-NULL
for (i in 1:length(rand_samp)){

	
	if (is.na(rand_samp[i])){
		j<-j
		cumulative_avg<-cumulative_avg
	}
	else {
	j<-c(j,rand_samp[i])
	cumulative_avg<-c(cumulative_avg,sum(j)/length(j))	
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
n<-1000
samp_sizes<-c(5,10,50,100,1000)
for(i in 1:length(samp_sizes)){
	jDT<-NULL
	for(j in 1:n){
		freq<-coin_flips(samp_sizes[i])
		result<-data.table(sample_size=samp_sizes[i],frequency=freq)
		jDT<-rbind(jDT,result)
	}
DT<-rbind(DT,jDT)
}

ggplot(DT,aes(x=frequency,col=as.factor(sample_size)))+geom_density()


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




