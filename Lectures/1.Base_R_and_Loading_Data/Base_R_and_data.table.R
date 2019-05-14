# we will use the package "data.table" in almost every thing we do this semester.
# You will need to load it in at the start of every script. 
library(data.table)

# this is a vector
Vec <- 7
# number vector
num_Vec<-c(3,6,5,1)
# this is a vector of logical statements
Log_Vec <- c(TRUE,TRUE,FALSE,TRUE)
# this is a character vector
Chr_Vec <- c("This", "is a", "character", "vector")
# DT1 is now a data.table
DT1 <- data.table(V1=num_Vec,V2=Log_Vec,V3=Chr_Vec)
# the str() function will tell you about the types of each column in a data.table
str(DT1)

# Indexing allows you to retrieve values or subset a data_table

# returns the first row, notice that this is a data_table
DT1[1,]
# returns the column named "V2", notice that this is a vector
DT1[,V2]

# you can also reference a column with the $ syntax

DT1$V2

# you can re-assighn values to a data.table

DT1[1,2]<-FALSE

# you can add new rows as long as they are correctly formatted

new_row<-data.table(V1=10,V2=TRUE,V3="column")

DT1<-rbind(DT1,new_row)

# you can add a new column by giving a set of values to a column that does not exist

DT1$V4<-c("G1","F1","G1","F1","P2")

# logical vectors can be converted to 0's and 1's
DT1$V2<-DT1$V2*1

# and then back again

DT1$V2<-as.logical(DT1$V2)

# There are other "as.'' functions

DT1$V1<-as.character(DT1$V1)

DT1$V4<-as.factor(DT1$V4)
str(DT1)
# and back again 

DT1$V1<-as.numeric(DT1$V1)

# we can change the names of columns

setnames(DT1, "V1", "Num_col")
# or
names(DT1)[2]<-"Log_col"
# or
setnames(DT1, c("V3","V4"), c("Chr_col","Fac_col"))

# Make your own data table that is 10 x 4, make the first column the odd numbers 1:19, the second column the 
# even numbers between 2:20, the third column your psu_id, the fourth column True of false based on if column 1
# and 2 are a multiple of 3 save your workflow as a script and upload your .r file to canvas. 




