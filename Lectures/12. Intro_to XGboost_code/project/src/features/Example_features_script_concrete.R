library(data.table)
library(readxl)
library(GGally)
set.seed(77)

download.file(url = "http://archive.ics.uci.edu/ml/machine-learning-databases/concrete/compressive/Concrete_Data.xls", destfile = "./project/volume/data/raw/Concrete_Data.xls", method = "curl", quiet = TRUE)
concrete_data <- read_xls(path = "./project/volume/data/raw/Concrete_Data.xls", sheet = 1)
colnames(concrete_data) <- c("Cement", "Slag", "Ash", "Water", "Superplasticizer", "Coarse_Aggregate", "Fine_Aggregate", "Age", "Strength")
concrete_data[, 1:7] <- t(apply(X = concrete_data[, 1:7], MARGIN = 1, FUN = function(x) {x/sum(x)}))

concrete_data<-data.table(concrete_data)

ggduo(data = concrete_data, 
      columnsX = 1:8, 
      columnsY = 9, 
      types = list(continuous = "smooth_lm"),
      mapping = ggplot2::aes(color = -Strength, alpha = 0.3)
) +
  theme_bw()


# here I divide the data into train and test so that I'm working on a similar problem as all of you
# note that you do not need to do this on your dataset
rand_inx<-sample(1:nrow(concrete_data),800)

train<-concrete_data[!rand_inx,]
test<-concrete_data[rand_inx,]

fwrite(train,'./project/volume/data/interim/train_concrete.csv')
fwrite(test,'./project/volume/data/interim/test_concrete.csv')

