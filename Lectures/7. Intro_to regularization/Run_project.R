library(data.table)
library(caret)
library(Metrics)
library(ggplot2)


#read in data, notice the path will always look like this because the assumed working directory is the repo level folder
train<-fread("train_file.csv")
test<-fread("test_file.csv")



logr_model<-glm(result ~ V1 + V2+V3+V4+V5+V6+V7+V8+V9+V10,data=train, family=binomial)

fake_data<-rbind(c(0,0,0,0,0,0,0,0,0,0),c(1,0,0,0,0,0,0,0,0,0))
fake_data<-rbind(fake_data,c(1,1,0,0,0,0,0,0,0,0))
fake_data<-rbind(fake_data,c(1,1,1,0,0,0,0,0,0,0))
fake_data<-rbind(fake_data,c(1,1,1,1,0,0,0,0,0,0))
fake_data<-rbind(fake_data,c(1,1,1,1,1,0,0,0,0,0))
fake_data<-rbind(fake_data,c(1,1,1,1,1,1,0,0,0,0))
fake_data<-rbind(fake_data,c(1,1,1,1,1,1,1,0,0,0))
fake_data<-rbind(fake_data,c(1,1,1,1,1,1,1,1,0,0))
fake_data<-rbind(fake_data,c(1,1,1,1,1,1,1,1,1,0))
fake_data<-rbind(fake_data,c(1,1,1,1,1,1,1,1,1,1))

fake_data<-data.table(fake_data)



pred<-predict(logr_model, newdata = fake_data, type="response")


reg_tab<-data.table(total=c(0:10),regression_preds=pred)

train$total<-rowSums(train[,2:11])

MAP<-function(a,b,l){
  
  y<-(l+a)/(2*l+a+b)
  y
}

a<-c(0,1,2,3,4,5,6,7,8,9,10)
b<-c(10,9,8,7,6,5,4,3,2,1,0)
l<-rep(1,11)

params<-data.table(a=a,b=b,l=l)

MAP_preds<-apply(params,1,FUN=function(x){MAP(x[1],x[2],x[3])})

MAP_tab<-data.table(total=c(0:10),MAP_preds=MAP_preds)

param_tab<-merge(reg_tab,MAP_tab)



MLE<-function(a,b){
  
  y<-(a)/(a+b)
  y
}

a<-c(0,1,2,3,4,5,6,7,8,9,10)
b<-c(10,9,8,7,6,5,4,3,2,1,0)

params<-data.table(a=a,b=b)

MLE_preds<-apply(params,1,FUN=function(x){MLE(x[1],x[2])})

MLE_tab<-data.table(total=c(0:10),MLE_preds=MLE_preds)

param_tab<-merge(param_tab,MLE_tab)



obs_tab<-train[,.(avg_obs=mean(result)),by=total][order(total)]

param_tab<-merge(param_tab,obs_tab)


m_param_tab<-melt(param_tab,id.vars='total')



#ggplot(m_param_tab,aes(x=value,y=total,col=variable))+geom_point()+geom_line()



#param_tab$regression_preds<-param_tab$regression_preds - c(0,0,0,0,0,0,1,1,1,1,1)
#param_tab$MAP_preds<-param_tab$MAP_preds - c(0,0,0,0,0,0,1,1,1,1,1)
#param_tab$avg_obs<-param_tab$avg_obs - c(0,0,0,0,0,0,1,1,1,1,1)

param_tab$total<-c(0,1,2,3,4,5,4,3,2,1,0)


m_param_tab2<-melt(param_tab,id.vars='total')
ggplot(m_param_tab2[variable=="MLE_preds"],aes(x=abs(value),y=total,col=variable))+geom_point()+geom_line()








