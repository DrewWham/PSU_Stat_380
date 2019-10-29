#load in libraries
library(data.table)
library(caret)





means<-data.table(x1=1,x2=4,x3=2,x4=9,x5=22)
group<-c("A","B","C")

#make data
new_train<-NULL
new_test<-NULL


for(i in 1:10000){
  
  new_row<-c(sample(group,1),apply(means,2,function(x){rnorm(1,x,x)}))
  new_train<-rbind(new_train,new_row)
  message(i)
}

for(i in 1:2000){
  
  new_row<-c(sample(group,1),apply(means,2,function(x){rnorm(1,x,x)}))
  new_test<-rbind(new_test,new_row)
  message(i)
}

new_train<-data.table(new_train)
setnames(new_train,"V1","group")

new_train$x1<-as.numeric(new_train$x1)
new_train$x2<-as.numeric(new_train$x2)
new_train$x3<-as.numeric(new_train$x3)
new_train$x4<-as.numeric(new_train$x4)
new_train$x5<-as.numeric(new_train$x5)
new_test$x1<-as.numeric(new_test$x1)
new_test$x2<-as.numeric(new_test$x2)
new_test$x3<-as.numeric(new_test$x3)
new_test$x4<-as.numeric(new_test$x4)
new_test$x5<-as.numeric(new_test$x5)

new_test<-data.table(new_test)
setnames(new_test,"V1","group")

new_train$y<-0
new_train[group=="A"]$y<-new_train[group=="A"]$x1+new_train[group=="A"]$x2+new_train[group=="A"]$x3
new_train[group=="B"]$y<-new_train[group=="B"]$x1+new_train[group=="B"]$x2+new_train[group=="B"]$x4
new_train[group=="C"]$y<-new_train[group=="C"]$x1*(new_train[group=="C"]$x2+new_train[group=="C"]$x4)

new_test$y<-0
new_test[group=="A"]$y<-new_test[group=="A"]$x1+new_test[group=="A"]$x2+new_test[group=="A"]$x3
new_test[group=="B"]$y<-new_test[group=="B"]$x1+new_test[group=="B"]$x2+new_test[group=="B"]$x4
new_test[group=="C"]$y<-new_test[group=="C"]$x1*(new_test[group=="C"]$x2+new_test[group=="C"]$x4)

########################
# write out to interim #
########################

fwrite(new_train,"./project/volume/data/raw/train.csv")
fwrite(new_test,"./project/volume/data/raw/test.csv")
