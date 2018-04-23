install.packages("rjson")
install.packages("tm")
install.packages("SnowballC")
library(tm) # Will use to create corpus and modify text therein.
library(SnowballC) # Will use for "stemming." 
library(rjson)
library(readr)
library(dplyr)
library(ggplot2)
library(caret)
# library(tidyverse)

rm(list = ls())

##### read file ####

#data <- read.csv("WineData.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
data <- read.csv("WineData.csv", header=TRUE, sep=",")

str(data)
# coverting description column to string
data$description <- as.character(data$description)

set.seed(8)

split <- createDataPartition(data$variety, p=0.6, list=FALSE)

train<- data[split,]
test<- data[-split,]

str(train)
str(test)


# Next we will manipulate the text in Description to stem the same 
# we will create a "corpus." 
corpus = Corpus(VectorSource(data$description))

corpus[[1]]
strwrap(corpus[[1]])

# Let us start processing the text in the corpus! Here is a 
# summary of how we shall process the text.  
# 1. Change all the text to lower case.  
# 2. Remove stop words and particular words. 
# 3. "Stem" the documents. 
# 4. Remove infrequent words. 
# 5. Create new data frame that contains word counts. 

# 1. Let's change all the text to lower case. 
corpus = tm_map(corpus, tolower)
# The function tm_map applies an operation to every document in the 
# corpus. In this case, the operation is 'tolower" (i.e. to lowercase). 

# Let us check:
strwrap(corpus[[1]])

# Sometimes 'tolower' does strange stuff (?) to the documents. 
# We run the next command to fix the strange stuff. 
if (!("PlainTextDocument" %in% class(corpus[[1]]))) 
  corpus = tm_map(corpus, PlainTextDocument)

# 2. Let us remove some words. First, we remove stop words:  
corpus = tm_map(corpus, removeWords, stopwords("english"))
# stopwords("english") is a dataframe that constains a list of 
# stop words. Let us look at the first ten stop words. 
stopwords("english")[1:10]

# Checking again:  
strwrap(corpus[[1]])

# Next, we remove the two particular words: realdonaldtrump, donaldtrump. 
#corpus = tm_map(corpus, removeWords, c("realdonaldtrump", "donaldtrump"))

corpus = tm_map(corpus, removeWords, c("e"))

# 3. Now we stem our documents. Recall that this corresponding to 
# removing the parts of words that are in some sense not 
# necessary (e.g. 'ing' and 'ed'). 
corpus = tm_map(corpus, stemDocument)

corpus <- tm_map(corpus, removeNumbers)

corpus <- tm_map(corpus, removePunctuation)

# We have: 
strwrap(corpus[[1]])

df <- data.frame(text = get("content", corpus))

str(df)

head(df)

data$stemDescription <- df$text

head(data)
str(data)

dataBackup <- data

data$description <- NULL

write.csv(data, "wineStem.csv")


#split the data
wine <- read.csv("wineStem.csv", header=TRUE, sep=",")

set.seed(8)

split <- createDataPartition(wine$variety, p=0.7, list=FALSE)

train<- wine[split,]
test<- wine[-split,]

str(train)
str(test)


write.csv(train, "wineTrain.csv")

write.csv(test, "wineTest.csv")
