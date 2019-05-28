library(data.table)
library(jsonlite)



# arguments



# function that will submit a given string and return the % matched
submitCode256<-function(user_id,x){
url <- paste0("https://dsdemo.vmhost.psu.edu/api/nlp/CodeBreak_256?user_id=",user_id,"&x=",x)
read_json(url)[[1]]
}

# your functions


########
##main##
########


# your main script


# Homework this week: Make a working script that will solve the 256-code API
# in less than 512 submissions, it should report out to the user the current 
# number of submissions and the current number correct. It should run from the
# command line and take in a user_id as an argument. Note that you will not 
# learn how to make a script for the command line until friday. You can however
# start working on this by getting your code to run like todays lecture does 
# from within R using the source() function. 





