

##### read file ####

data <- read.csv("WineData.csv", header=TRUE, sep=",")
str(data)

library("caret")

set.seed(8)

split <- createDataPartition(data$variety, p=0.6, list=FALSE)

train<- data[split,]
test<- data[-split,]

str(train)
str(test)
