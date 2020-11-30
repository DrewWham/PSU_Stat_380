library(data.table)


#how do you transform the training data into a format that can be used by xgboost


#make example data:
id_col<-paste0("sample_",1:1000)

set<-c("cat_1","cat_2","cat_3")
category<-sample(set,1000,replace=T)

DT<-data.table(id=id_col,category=category)

DT$order<-1:nrow(DT)

DT<-dcast(DT,id+order~category,value.var="category")
DT$cat_1[!is.na(DT$cat_1)]<-1
DT$cat_2[!is.na(DT$cat_2)]<-1
DT$cat_3[!is.na(DT$cat_3)]<-1
DT[is.na(DT)]<-0

# transform format:

m_DT<-melt(DT,id=c("id","order"),variable.name = "category")
m_DT<-m_DT[value==1][order(order)][,.(id,category)]
m_DT$category<-as.integer(m_DT$category)-1



#how do format the predictions to add them to the submission file

#make example data that looks like the output of the xgboost model:
pred<-lapply(1:10,function(x){paste0("sample_",x,"_reddit_",1:10)})
pred<-unlist(pred)

# reformat
results<-matrix(pred,ncol=10,byrow=T)

