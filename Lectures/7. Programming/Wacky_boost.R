library(data.table)
library(optparse)
library(jsonlite)


# make an options parsing list
option_list = list(
make_option(c("-u", "--user"), type="character", default=NULL,
help="user_id", metavar="character")
);

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

# get the arguments that were passed in
user_id<-opt$user


# function that will make a random string in the forma that can be submitted to the API
rand_code<-function(){
	set<-c(1,0)
	rand_vec<-sample(set,256,replace=T)
	rand_string<-paste0(rand_vec,collapse="")
	rand_string
}

# function that will invert a given string
flip_code<-function(code){
	char_string<-strsplit(code,"")
	num_vec<-as.numeric(char_string[[1]])
	rev_logic_vec<-!as.logical(num_vec)
	rev_num_vec<-rev_logic_vec*1
	rev_string<-paste0(rev_num_vec,collapse="")
	rev_string
}

# function that will submit a given string and return the % matched
submitCode<-function(user_id,code){
	url <- paste0("https://dsdemo.vmhost.psu.edu/api/nlp/CodeBreak_256?user_id=",user_id,"&x=",code)
	read_json(url)[[1]]
}

# function that will take a bunch of strings and return the most common value in each position
string_vote<-function(binary_strings){
	char_string<-strsplit(binary_strings,"")
	num_vecs<-lapply(char_string,as.numeric)
	code_tab<-data.table(do.call(rbind,num_vecs))
	maj_vote<-round(colMeans(code_tab))
	vote_string<-paste0(maj_vote,collapse="")
	vote_string
}

# submits a random string then inverts it if it isnt above average
getAboveAvg<-function(user_id){
    code<-rand_code()
    eval<-submitCode(user_id,code)[[1]]
    
    # make sure it wasnt the password (this will never happen)
    if (is.character(eval)){
        eval<-1
    }
    # invert if below avg
    if (eval<0.5){
        code<-flip_code(code)
        eval<-1-eval
        }
    DT<-data.table(eval,code)
    DT
}


########
##main##
########


DT<-NULL
eval<-0
i=0
checks<-seq(1,100000,100)-1
while(eval<1){
    # make a bunch of above average strings then ensamble them
    i<-i+1
    out<-getAboveAvg(user_id)
    DT<-rbind(DT,out)
    
    # only check if the ensamble has solved once every 100
    if (i %in% checks){
        ensamble_code<-string_vote(c(DT$code))
        eval<-submitCode(user_id,ensamble_code)[[1]]
        message(paste0("ensambled strings: ",i,"             percent correct: ",eval))
    }

}


ensamble_code<-string_vote(c(DT$code))
submitCode(user_id,ensamble_code)[[1]]






