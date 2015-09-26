## Run_analysis.R - Sept 2015
## Getting and Cleaning Data - Course Project

## Read in data:

fileName1 <-"/Users/tomcorbeil/Desktop/Coursera/Getting and Cleaning Data/CourseProjectGACD/test/X_test.txt"
testX <- read.table(fileName1)

fileName2 <-"/Users/tomcorbeil/Desktop/Coursera/Getting and Cleaning Data/CourseProjectGACD/test/y_test.txt"
testY <- read.table(fileName2)

fileName3 <-"/Users/tomcorbeil/Desktop/Coursera/Getting and Cleaning Data/CourseProjectGACD/train/X_train.txt"
trainX <- read.table(fileName3)

fileName4 <-"/Users/tomcorbeil/Desktop/Coursera/Getting and Cleaning Data/CourseProjectGACD/train/y_train.txt"
trainY <- read.table(fileName4)

fileName5 <-"/Users/tomcorbeil/Desktop/Coursera/Getting and Cleaning Data/CourseProjectGACD/test/subject_test.txt"
testSub <- read.table(fileName5)

fileName6 <-"/Users/tomcorbeil/Desktop/Coursera/Getting and Cleaning Data/CourseProjectGACD/train/subject_train.txt"
trainSub <- read.table(fileName6)

fileName7 <-"/Users/tomcorbeil/Desktop/Coursera/Getting and Cleaning Data/CourseProjectGACD/features.txt"
features <- read.table(fileName7)

## Add column names to testX and trainX:

features1 <- as.vector(as.character(features[, 2]))
features1 <- make.names(features1, unique=TRUE) 
      # make the variable names valid R names
colnames(testX) <- features1
colnames(trainX) <- features1

## Keep mean and std columns:

testX <- testX[, grep("mean|std", names(testX))]
trainX <- trainX[, grep("mean|std", names(trainX))]

#library(dplyr)
#testX1 <- select(testX, matches("mean|std", ignore.case=TRUE))

## Add column names for ID and activity label sets:

colnames(testSub) <- "ID"
colnames(trainSub) <- "ID"
colnames(testY) <- "activity"
colnames(trainY) <- "activity"

## Bind IDs & activity type to main datasets:

testSet <- cbind(testSub, testY, testX)
trainSet <- cbind(trainSub, trainY, trainX)

## Merge 

fullSet <- rbind(testSet, trainSet)

## Sort on ID and activity
library(dplyr)

fullSetSorted <- arrange(fullSet, ID, activity)

## Label "activity" variable - change to class 'factor':

activity_labels <- c("Walking", "WalkingUpstairs", 
                     "WalkingDownstairs", "Sitting", "Standing",
                     "Laying")
fullSetSorted$activity <- factor(fullSetSorted$activity, 
                                 labels = activity_labels)
#class(fullSetSorted$activity)

## Get averages across ID and activity:

melted <- melt(fullSetSorted, id=c("ID", "activity"))
RunData <- dcast(melted, ID + activity ~ variable, mean)

## Output final dataset:

write.table(RunData, file="RunData.txt", row.names=FALSE)



