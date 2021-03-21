# This is the .R script for the Course Project of the "Getting and Cleaning Data"
# course on Coursera
library(stringr)
library(dplyr)

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)


act_names <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
act_names <- as.vector(act_names$V2)


features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
features <- as.vector(features$V2)
mean_or_std <- str_detect(features, "[mM][eE][aA][nN]") | str_detect(features, "[sS][tT][dD]")


subject <- rbind(subject_train, subject_test)
rm(subject_train, subject_test)
colnames(subject) <- "SubjectID"


y <- rbind(y_train, y_test)
rm(y_train, y_test)
colnames(y) <- "Activity"


X <- rbind(X_train, X_test)
rm(X_train, X_test)
X <- select(X, which(mean_or_std == TRUE))
colnames(X) <- features[mean_or_std == TRUE]
rm(features, mean_or_std)


colnames(X) <- sub("^t", "time", colnames(X))
colnames(X) <- sub("^f", "freq", colnames(X))
colnames(X) <- gsub("-", "", colnames(X))
colnames(X) <- gsub("_", "", colnames(X))


data_set <- cbind(subject, y, X)
rm(subject, y, X)


data_set <- mutate(data_set, Activity = act_names[Activity])
rm(act_names)


data_set <- group_by(data_set, SubjectID, Activity)
data_set <- summarize_all(data_set, mean)


detach(package:dplyr)
detach(package:stringr)