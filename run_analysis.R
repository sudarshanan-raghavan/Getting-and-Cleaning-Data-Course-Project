# This is the .R script for the Course Project of the "Getting and Cleaning Data"
# course on Coursera

# Note - the 'rm' function is used to remove data that is not required anymore

# Let's load the 'stringr' and 'dplyr' packages
# The 'stringr' package helps in manipulating strings
# The 'dplyr' package helps in manipulating data frames
library(stringr)
library(dplyr)

# The data set used in this Course Project comes from
# Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz.
# Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly
# Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012).
# Vitoria-Gasteiz, Spain. Dec 2012

# Let's load the training data and the test data
# 'subject' refers to the individual person wearing the device
# 'y' refers to the activities of the person such as walking, sitting etc
# 'X' refers to the measured data from the device
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)


# Let's read and store the activity names
act_names <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
act_names <- as.vector(act_names$V2)


# Let's read and store the feature names
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
features <- as.vector(features$V2)

# Since we want to extract only mean and std data, let's create a logical
# vector that checks whether the feature names include the words 'mean' or 'std'
# while being case-agnostic
mean_or_std <- str_detect(features, "[mM][eE][aA][nN]") | str_detect(features, "[sS][tT][dD]")


# Let's merge the training and test data for 'subject' and rename the column
subject <- rbind(subject_train, subject_test)
rm(subject_train, subject_test)
colnames(subject) <- "SubjectID"


# Let's merge the training and test data for 'y' and rename the column
y <- rbind(y_train, y_test)
rm(y_train, y_test)
colnames(y) <- "Activity"


# Let's merge the training and test data for 'X' and only keep those variables
# which contain the words 'mean' or 'std' by using our logical vector 'mean_or_std'
# and rename the columns accordingly
X <- rbind(X_train, X_test)
rm(X_train, X_test)
X <- select(X, which(mean_or_std == TRUE))
colnames(X) <- features[mean_or_std == TRUE]
rm(features, mean_or_std)


# Let's clean the column names in 'X'
colnames(X) <- sub("^t", "time", colnames(X))
colnames(X) <- sub("^f", "freq", colnames(X))
colnames(X) <- gsub("-", "", colnames(X))
colnames(X) <- gsub("_", "", colnames(X))
colnames(X) <- gsub(",", "", colnames(X))
colnames(X) <- gsub("\\ ", "", colnames(X))
colnames(X) <- gsub("\\(", "", colnames(X))
colnames(X) <- gsub("\\)", "", colnames(X))
colnames(X) <- gsub("\\.", "", colnames(X))


# Let's combine the 'subject', 'y' and 'X' data frames into a single data frame
data_set <- cbind(subject, y, X)
rm(subject, y, X)


# Let's replace the activity IDs with the actual activity names in our final data frame
data_set <- mutate(data_set, Activity = act_names[Activity])
rm(act_names)


# Let's group our final data frame by 'SubjectID' and 'Activity' and evaluate only the
# means for each group combination
data_set <- group_by(data_set, SubjectID, Activity)
data_set <- summarize_all(data_set, mean)


# Let's store the new data set in a new file
write.table(data_set, "new_data_set.txt", row.names = FALSE)
rm(data_set)


# Let's unload the packages that were loaded initially
detach(package:dplyr)
detach(package:stringr)