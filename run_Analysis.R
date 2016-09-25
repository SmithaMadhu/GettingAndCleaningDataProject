library(reshape2)

#Download the Project file
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURl,"ProjectData.zip")

#Unzip the file
if(!(file.exists("UCI HAR Dataset"))) 
  unzip("D:/R/Workspace/Cleaning Data/data/ProjectData.zip")

# Load activity labels 
activityLabels <- read.table("./Project/UCI HAR Dataset/activity_labels.txt")
summary(activityLabels)
activityLabels[,2] <- as.character(activityLabels[,2])

#Load Features
features <- read.table("./Project/UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

#Filter Features with mean and standard deviation
featuresFiltered <- grep(".*mean.*|.*std.*",features[,2])
featuresFiltered.names <- features[featuresFiltered,2]
featuresFiltered.names <- gsub('-mean','Mean',featuresFiltered.names)
featuresFiltered.names <- gsub('-std','Std',featuresFiltered.names)
featuresFiltered.names <- gsub('[-()]', '', featuresFiltered.names)


#Load Training Data
train <- read.table("./Project/UCI HAR Dataset/train/X_train.txt")[featuresFiltered]
trainActivities <- read.table("./Project/UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("./Project/UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

#Load Test Data
test <- read.table("./Project/UCI HAR Dataset/test/X_test.txt")[featuresFiltered]
testActivities <- read.table("./Project/UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("./Project/UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merge datasets and add labels
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresFiltered.names)

# turn activities & subjects into factors
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "./Project/UCI HAR Dataset/tidy.txt", row.names = FALSE, quote = FALSE)


