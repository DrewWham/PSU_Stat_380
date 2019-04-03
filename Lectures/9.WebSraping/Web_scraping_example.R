library(rvest)
library(XML)
library(data.table)



# this function is useful for grabing all links on a page
links <- function(URL) 
{
    getLinks <- function() {
        links <- character()
        list(a = function(node, ...) {
                links <<- c(links, xmlGetAttr(node, "href"))
                node
             },
             links = function() links)
        }
    h1 <- getLinks()
    htmlTreeParse(URL, handlers = h1)
    h1$links()
}

# this function gets a single value from a page (player name in this case)
get_name<-function(url){
page<-read_html(url)
node<-html_nodes(page,".player-name")
player_name<-html_text(node)
player_name
}



# Set start web url
NFL <- read_html("http://www.nfl.com/stats/categorystats?tabSeq=1&statisticPositionCategory=QUARTERBACK&qualified=true&season=2015&seasonType=REG")
# get all the players names
p2<-links(NFL)[grep("p=2&statistic",links(NFL))][1]
pl<-links(NFL)[grep("players/",links(NFL))]
page2<-read_html(paste("http://www.nfl.com",p2,sep=""))
pl2<-links(page2)[grep("players/",links(page2))]
players<-c(pl,pl2)




# make a for loop to get all the players
data<-NULL
for (i in 1:length(players)){
	# go to each player page
	goto<-paste("http://www.nfl.com",players[i],sep="")
	# get the tables on the page
	tables<-html_table(read_html(goto),fill = TRUE)
	# figure out which table is the one we want
	target_tab<-grep("Season",tables)
	# get the table we want
	table<-tables[[target_tab]][-1,]
	# get the two header rows
	header1<-table[1,]
	header2<-table[2,]
	# paste the header rows into one row
	header<-paste0(header1,header2)
	# format to a data.table and remove a leading row
	table<-data.table(table[-1,])
	# remove leading row
	table<-table[-1,]
	setnames(table,names(table),header)
	# get the players name and add as a column
	player_name<-get_name(goto)
	table$Player_Name<-player_name
	# remove the totals column
	table<-head(table,-1)
	if (dim(table)[2]==21){
		data<-rbind(data,table)
		}
	message(player_name)
	}

fwrite(data,"NFL_QB_stats.csv")







  
  



