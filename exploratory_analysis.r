## Start from the clear slate
rm(list = ls())
## Set working directory
setwd("C:\\Users\\Nitika\\Desktop\\Kaggle\\01- GA Customer Revenue Prediction\\Data")
## Read in Data Sets
train_data<- read.csv("train.csv",stringsAsFactors = FALSE)
test_data<- read.csv("test.csv",stringsAsFactors = FALSE)
sample_submissions<- read.csv("sample_submission.csv")
## Read in Libraries
library(jsonlite,dplyr,purrr,tidyr)
## Sample out train data for quick stats
train_sample<- data.frame(train_data[1:5,], stringsAsFactors = FALSE ) 
train_sample$device<- as.character(train_sample$device)
## Append train and test for collective summary
train_data$train_flag<-1
test_data$train_flag<-0
all_data<- rbind(train_data, test_data)


## Flatten out data from JSON objects, put them into a table, merge it back in!

#for (mycol in c("device","geoNetwork","totals","trafficSource")){
for (mycol in c("device","geoNetwork")){

flattened_data<- as.data.frame(do.call( rbind, 
         lapply(all_data[,mycol], 
                function(j) as.list(unlist(fromJSON(j, flatten=TRUE)))
         )))

myiter<-1
for (mycol in colnames(flattened_data)) {
  if(myiter==1) {
    mydf<-as.data.frame(unlist(flattened_data[,mycol]))
  }
  if(myiter>1) {
  mydf<<- cbind(mydf,as.data.frame(unlist(flattened_data[,mycol])))
  }
  myiter<<-myiter+1
}
colnames(mydf)<- colnames(flattened_data)
flattened_data<-mydf
write.csv(flattened_data,paste("flattened_data_,",mycol,".csv", sep=''), row.names = F)
all_data[,mycol]<-NULL
all_data<<-cbind(all_data,flattened_data)
}
