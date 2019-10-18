#load in libraries
library(data.table)
library(Metrics)
library(ggplot2)

eval_data<-fread("./project/volume/data/processed/full_eval.csv")
card_tab<-fread("./project/volume/data/raw/card_tab.csv")

mae(eval_data$future_price,eval_data$pred_price)


eval_data$pred_profit<-eval_data$pred_price-eval_data$current_price
eval_data$actual_profit<-eval_data$future_price-eval_data$current_price

mean(eval_data$pred_profit)
mean(eval_data$actual_profit)


most_profit<-eval_data[order(-pred_profit)][pred_profit>0.5,]

mean(most_profit$pred_profit)
mean(most_profit$actual_profit)


ggplot(eval_data,aes(x=pred_profit,y=actual_profit))+geom_point()


card_tab[id==eval_data[order(-actual_profit)][1]$id]$card_name

card_tab[id==eval_data[order(actual_profit)][1]$id]$card_name

