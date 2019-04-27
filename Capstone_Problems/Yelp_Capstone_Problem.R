#capstone problem 1

# Using the Yelp review data, find the 5 businesses with the largest downward trend in reviews. 
# Plot the businesses average review over time in a faceted plot. 
# Select your own colors for the businesses plots using a manual color selection with hex values 
# you gather from googles color picking tool.  

library(data.table)
library(ggplot2)
library(lubridate)
DT<-fread("./Lectures/Data/Yelp/yelp_academic_dataset_reviews_no_text.csv")
Bus<-fread("./Lectures/Data/Yelp/yelp_academic_dataset_business.csv")

DT$date<-as_date(DT$date)
DT$n_month<-month(DT$date)
DT$n_year<-year(DT$date)
DT$n_date<-DT$n_year*100+DT$n_month

avg_star<-dcast(DT,business_id+n_date~.,mean,value.var="stars" )[order( business_id,n_date)]

setnames(avg_star,c("."),c("avg_star"))

num_rev<-dcast(DT,business_id+n_date~.,length,value.var="stars" )[order( business_id,n_date)]

setnames(num_rev,c("."),c("num_rev"))

setkey(avg_star,business_id,n_date)
setkey(num_rev,business_id,n_date)

master_DT<-merge(avg_star,num_rev)

sub_DT<-master_DT[num_rev>29]

rev_total_months<-dcast(sub_DT,business_id~.,length,value.var = "business_id")

setkey(master_DT,business_id)
setkey(rev_total_months,business_id)

sub_DT<-merge(sub_DT,rev_total_months,all.x=T)

setnames(sub_DT,c("."),c("rev_total_months"))


sub_DT<-sub_DT[rev_total_months>4]

dim(sub_DT)


sub_DT2<-sub_DT
sub_DT2$DT2_date<-sub_DT2$n_date
sub_DT$DT_date<-sub_DT$n_date
sub_DT2$n_date<-sub_DT2$n_date-0.1


setkey(sub_DT2,business_id ,n_date)
setkey(sub_DT,business_id ,n_date)

rolled_DT<-sub_DT[sub_DT2,roll=T]


rolled_DT<-rolled_DT[!is.na(rolled_DT$num_rev),]

rolled_DT$rev_diff<-rolled_DT$i.avg_star-rolled_DT$avg_star

bus_rev_dif<-dcast(rolled_DT,business_id~.,median,value.var = "rev_diff")

worst_5<-bus_rev_dif[order(.)][1:5]

Bus<-Bus[business_id %in% worst_5$business_id]

master_DT<-master_DT[business_id %in% worst_5$business_id]



setkey(Bus,business_id)
setkey(master_DT,business_id)

master<-merge(master_DT,Bus[,.(business_id,name)])

ggplot(master,aes(x=as.factor(n_date),y=avg_star,fill=name))+geom_bar(stat="identity")+facet_wrap(.~name,scales = "free")+theme(axis.text.x = element_text(angle = 45, hjust = 1))+geom_text(aes(label=num_rev), position=position_dodge(width=0.9), vjust=-0.25)+ theme(legend.position="none")

# We will define "downward trend" as the business whos median change in month-over-month average reviews is lowest.
# You should ignore any month for any business in which there were less than 30 reviews
# you should ignore any business that does not have 5 or more valid months
# once you have identified the 5 businesses be sure to include all of the data in your subsequent analysis



# make a faceted barplot that shows the monthly average reviews over time for each business. each business should appear in its own facet.
# give the business name at the top of each facet. Select a unique color for each business. Label each bar with
# the number of reviews in that month. 

