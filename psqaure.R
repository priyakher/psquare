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

# start bag of words
for (i in unique(train$variety)){
  
  # Nebbiolo <- subset(train, variety=="Nebbiolo")
  
  Nebbiolo <- subset(train, variety==i)
  corpus = Corpus(VectorSource(Nebbiolo$stemDescription))
  frequencies = DocumentTermMatrix(corpus)
  # Let us only keep words that appear in at least 1% of the tweets. We 
  # create a list of these words as follows. 
  sparse = removeSparseTerms(frequencies, 0.99)
  fqt <- findFreqTerms(sparse, lowfreq=300)
  bagOfWords <- data.frame(term = character(0))
  for(t in fqt){
    bagOfWords <- rbind(bagOfWords, data.frame(term = t))
  }  
  
  mainDir <- "/Users/priyashamehta/Documents/Spring2018/1.001/project/git/psquare"
  subDir <- "BagOfWords"
  dir.create(file.path(mainDir, subDir), showWarnings = FALSE)
  setwd(file.path(mainDir, subDir))
  
  write.csv(bagOfWords, paste0("bagOfWords_", i,".csv"))

}




# We now have 155 terms instead of 12790. 

# 5. We first create a new data frame. Each variable corresponds 
# to one of the 155 words, and each row corresponds to one of the tweets.
#document_terms = as.data.frame(as.matrix(sparse))
#str(document_terms)

# bagOfWords <- data.frame(term = character(0), freq = integer(0))
#similarity between c1 and c2
#for(t in ft1){
 # find <- agrep(t, ft2)
 # if(length(find) != 0){
 #   common.c1c2 <- rbind(common.c1c2, data.frame(term = t, freq = length(find)))
 # }
  

# typeof(variable)


# https://stackoverflow.com/questions/45790815/compare-the-bag-of-words-in-two-document-and-find-the-matching-word-and-their-fr?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
# https://stackoverflow.com/questions/12693908/get-type-of-all-variables?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
# https://stackoverflow.com/questions/24703920/r-tm-package-vcorpus-error-in-converting-corpus-to-data-frame?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
# 





