library(data.table)
library(Rtsne)
library(ggplot2)
library(caret)

set.seed(27)

Ap_Pres<-c(0,1)
UBC<-c(0,1)
R2C<-c(0,1)
GSHC<-c(0,1)
Fox<-c(0,1)
CNN<-c(0,1)
Lower_Immigration<-c(0,1)
Glob_W<-c(0,1)
Tax_high_income<-c(0,1)
Death_Pen<-c(0,1)
Fed_too_much_Power<-c(0,1)
Stricter_Gun_Laws<-c(0,1)
Stricter_Env_laws<-c(0,1)


R_Q1<-c(0.11,0.89) #https://news.gallup.com/poll/203198/presidential-approval-ratings-donald-trump.aspx
R_Q2<-c(.15,0.85) #https://www.washingtonpost.com/politics/americans-of-both-parties-overwhelmingly-support-red-flag-laws-expanded-gun-background-checks-washington-post-abc-news-poll-finds/2019/09/08/97208916-ca75-11e9-a4f3-c081a126de70_story.html
R_Q3<-c(0.65,0.35) #https://fivethirtyeight.com/features/the-abortion-debate-isnt-as-partisan-as-politicians-make-it-seem/
R_Q4<-c(0.88,0.12) #https://www.pewresearch.org/fact-tank/2018/10/03/most-continue-to-say-ensuring-health-care-coverage-is-governments-responsibility/
R_Q5<-c(0.3,0.7) #https://www.businessinsider.com/most-and-least-trusted-news-outlets-in-america-cnn-fox-news-new-york-times-2019-4
R_Q6<-c(0.7,0.3) #https://www.businessinsider.com/most-and-least-trusted-news-outlets-in-america-cnn-fox-news-new-york-times-2019-4
R_Q7<-c(0.4,0.6) #https://news.gallup.com/opinion/polling-matters/215210/partisan-differences-growing-number-issues.aspx
R_Q8<-c(0.6,0.4) #https://news.gallup.com/opinion/polling-matters/215210/partisan-differences-growing-number-issues.aspx
R_Q9<-c(0.6,0.4) #https://news.gallup.com/opinion/polling-matters/215210/partisan-differences-growing-number-issues.aspx
R_Q10<-c(0.2,0.8) #https://news.gallup.com/opinion/polling-matters/215210/partisan-differences-growing-number-issues.aspx
R_Q11<-c(0.18,0.82) #https://news.gallup.com/opinion/polling-matters/215210/partisan-differences-growing-number-issues.aspx
R_Q12<-c(0.66,0.34) #https://news.gallup.com/opinion/polling-matters/215210/partisan-differences-growing-number-issues.aspx
R_Q13<-c(0.65,0.35) #https://news.gallup.com/opinion/polling-matters/215210/partisan-differences-growing-number-issues.aspx

D_Q1<-c(0.93,0.07) #https://news.gallup.com/poll/203198/presidential-approval-ratings-donald-trump.aspx
D_Q2<-c(0.05,0.95) #https://www.washingtonpost.com/politics/americans-of-both-parties-overwhelmingly-support-red-flag-laws-expanded-gun-background-checks-washington-post-abc-news-poll-finds/2019/09/08/97208916-ca75-11e9-a4f3-c081a126de70_story.html
D_Q3<-c(0.25,0.75) #https://fivethirtyeight.com/features/the-abortion-debate-isnt-as-partisan-as-politicians-make-it-seem/
D_Q4<-c(0.49,0.51) #https://www.pewresearch.org/fact-tank/2018/10/03/most-continue-to-say-ensuring-health-care-coverage-is-governments-responsibility/
D_Q5<-c(0.58,0.42) #https://www.businessinsider.com/most-and-least-trusted-news-outlets-in-america-cnn-fox-news-new-york-times-2019-4
D_Q6<-c(0.18,0.82) #https://www.businessinsider.com/most-and-least-trusted-news-outlets-in-america-cnn-fox-news-new-york-times-2019-4
D_Q7<-c(0.8,0.2) #https://news.gallup.com/opinion/polling-matters/215210/partisan-differences-growing-number-issues.aspx
D_Q8<-c(0.11,0.89) #https://news.gallup.com/opinion/polling-matters/215210/partisan-differences-growing-number-issues.aspx
D_Q9<-c(0.18,0.82) #https://news.gallup.com/opinion/polling-matters/215210/partisan-differences-growing-number-issues.aspx
D_Q10<-c(0.59,0.41) #https://news.gallup.com/opinion/polling-matters/215210/partisan-differences-growing-number-issues.aspx
D_Q11<-c(0.64,0.36) #https://news.gallup.com/opinion/polling-matters/215210/partisan-differences-growing-number-issues.aspx
D_Q12<-c(0.23,0.77) #https://news.gallup.com/opinion/polling-matters/215210/partisan-differences-growing-number-issues.aspx
D_Q13<-c(0.21,0.79) #https://news.gallup.com/opinion/polling-matters/215210/partisan-differences-growing-number-issues.aspx



Qs<-c("Ap_Pres","UBC","R2C","GSHC","Fox","CNN","Lower_Immigration","Glob_W","Tax_high_income","Death_Pen","Fed_too_much_Power","Stricter_Gun_Laws","Stricter_Env_laws")
party<-c("R","D")


q_data<-NULL

for (j in 1:length(party)){
  sp_tab<-NULL
  for (i in 1:length(Qs)){
    msats<-sample(get(Qs[i]),5000,replace=T,prob=get(paste0(party[j],"_Q",i)))
    sp_tab<-cbind(sp_tab,msats)
    sp_tab<-data.table(sp_tab)
    names(sp_tab)[i]<-Qs[i]
  }
  sp_tab$party<-party[j]
  q_data<-rbind(q_data,sp_tab)
}



q_data$Cats<-sample(c(0,1),dim(q_data)[1],replace=T)
q_data$Knitting<-0
q_data[Cats==1]$Knitting<-sample(c(0,1),dim(q_data[Cats==1])[1],replace=T,prob=c(0.15,0.85))
q_data[Cats==0]$Knitting<-sample(c(0,1),dim(q_data[Cats==0])[1],replace=T,prob=c(0.85,0.15))

q_data<-q_data[,.(party,Ap_Pres,UBC,R2C,GSHC,Fox,CNN,Lower_Immigration,Glob_W,Tax_high_income,Death_Pen,Fed_too_much_Power,Stricter_Gun_Laws,Stricter_Env_laws,Cats,Knitting)]

fwrite(q_data,"./project/volume/data/raw/data.csv")

