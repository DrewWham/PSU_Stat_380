library(data.table)

bus<-fread("./Lectures/Data/Yelp/yelp_academic_dataset_business.csv")
rev<-fread("./Lectures/Data/Yelp/yelp_academic_dataset_reviews_no_text.csv")


# All questions should be answered considering only the businesses with 30 or more reviews, you can subset 
# the yelp_academic_dataset_business.csv table by review_count > 29 to do this 

# Which business in AZ has the most 5 star reviews


# Which city in the dataset has the most reviews marked as funny?


# Based on the frequency (percentage) of 1 star reviews, which of these cities has the highest rate of very low reviews?
# Las Vegas, Phoenix, Toronto, Charlotte, Scottsdale

# Based on this dataset what is the highest average rated Buisness in Pittsburgh serving coffee?
# Hint: grep("Coffee",bus$categories)


# Based on this dataset what is the worst place to get breakfast in Las Vegas?
# Hint: grep("Breakfast",bus$categories)














