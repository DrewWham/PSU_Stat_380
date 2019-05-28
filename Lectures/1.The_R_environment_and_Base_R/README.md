### Loading Data
### 1)Download and install R and RStudio
Follow the below links download and install the appropriate version of R and R Studio for your operating system
* [R](https://www.r-project.org)
* [RStudio](https://www.rstudio.com/products/RStudio/)

## Opening R, setting working directory, Base R, downloading & loading packages
* [Base R - Cheatsheet](http://github.com/rstudio/cheatsheets/raw/master/base-r.pdf)
* [R Studio - Cheatsheet](https://github.com/rstudio/cheatsheets/raw/master/rstudio-ide.pdf)

R has a "working drectory" which is the folder where R will load data from and write files out to; You will need to set the working directory in the R GUI, the R-Studio GUI or by writing in the command line:

`setwd("~/Desktop/Stat_184")`

The utility of R is in the hundereds of packages which offer thousands of pre-made functions. Packages will need to be installed; you can install them in the R GUI, the R-Studio GUI or by writing in the command line:

`install.packages("data.table")`

Once packages are installed you will still need to load them in order to use their functions; you can load them with the 'library()' function:

`library(data.table)`

This course will leverage functions from several packages, you can install and load all of them with the following command:

`source("course_packages.R")`

## Data Structures,Loading Data, Indexing & Functions

R has some basic data structures we will primarily use just two, vectors and data_tables

`Vec <- 7` #this is a vector

`num_Vec <- c(1,2.5,3,4.7)` #this is also a vector

`Log_Vec <- c(TRUE,TRUE,FALSE,TRUE)` #this is a vector of logical statements

`Chr_Vec <- c("This", "is a", "character", "vector")` #this is a character vector

`DT1 <- data.table(V1=num_Vec,V2=Log_Vec,V3=Chr_Vec)` #DT1 is now a data.table

`str(DT1)` #the str() function will tell you about the types of each column in a data.table

Indexing allows you to retrieve values or subset a data_table

`DT1[1,]` #returns the first row, notice that this is a data_table

`DT1[,V2]` #returns the column named "V2", notice that this is a vector

".csv" files are a common way to store data, we can load ".csv" files with the fread() function:

`DT<-fread("2008.csv")` #This reads in the flight data and stores it as an object called 'DT'

`AP<-fread("airports.csv")` #This reads in the data about airports and stores it as an object called 'AP'

We can now look at the data with some useful functions

`dim(DT)` #the dim() function will show you the number of rows and the number of columns in a data_table

`DT` #this is okay with a data_table but it is bad practice

`head(DT)` #this is the preferred way to look at the top of an object

`tail(DT)` #this is the preferred way to look at the bottom of an object

`str(DT)` #we learned about data types above, this is a useful way to inspect a data object and see column types
