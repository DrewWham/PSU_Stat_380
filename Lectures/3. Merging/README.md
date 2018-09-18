 ### Merging
 
 
We'd like to merge using the Airport codes (a common value between datasets), but they are named "iata_code" in the Airports dataset and "Origin" and "Dest" in the Flights dataset. We will be focusing on departure delays in our analysis so we will be merging to "Origin".

`setnames(AP,"iata_code","Origin")` #this changes the name of the "iata_code" column to "Origin"

`setkey(DT,Origin)` #before merging we can re-order the datasets by what we want to merge on

`setkey(AP,Origin)` #this will match the order for both data frames, this will significantly speed up the merge 

`DT<-merge(DT,AP,all.x=T)` #Now we can merge, notice the "all.x=T" 
