# Section 0 - Let's load some useful packages

# The 'dplyr' package is useful in manipulating data frames
# The 'stringr' package is useful in manipulating textual data
library(dplyr, stringr)


# Section 1 - Let's read the training data and the test data

# Let's read the training data for 'subject' (persons)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

# Let's read the training data for 'X' (features)
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)

# Let's read the training data for 'y' (activities)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)

# Let's read the test data for 'subject' (persons)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

# Let's read the test data for 'X' (features)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)

# Let's read the test data for 'y' (activities)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)


# Section 2 - Let's read some important metadata

# Let's read the activity names and store it as a character vector
act_names <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
act_names <- as.vector(act_names$V2)

# Let's read the features and store them as a character vector
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
features <- as.vector(features$V2)

# Let's see which features have the word 'mean' or 'std' in them (case agnostic)
# and store the logical vector obtained
mean_or_std <- str_detect(features, "[mM][eE][aA][nN]") | str_detect(features, "[sS][tT][dD]")


# Section 3 - Let's merge the training data and the test data

# Let's merge the 'subject' data
subject <- rbind(subject_train, subject_test)

# Let's remove unused data frames
rm(subject_train, subject_test)

# Let's assign the column name
colnames(subject) <- "Subject ID"

# Let's merge the 'y' data
y <- rbind(y_train, y_test)

# Let's remove unused data frames
rm(y_train, y_test)

# Let's assign the column name
colnames(y) <- "Activity"

# Let's merge the 'X' data
X <- rbind(X_train, X_test)

# Let's remove unused data frames
rm(X_train, X_test)

# Let's extract only the means and standard deviations from X
X <- select(X, which(mean_or_std == TRUE))

# Let's assign the column names
colnames(X) <- features[mean_or_std == TRUE]

# Let's merge our data into a single data frame
data_set <- cbind(subject, y, X)

# Section 4 - Let's rename the IDs in the 'y' column with the associated activity names
data_set <- mutate(data_set, Activity = act_names[Activity])

# Let's detach the packages that were loaded at the beginning of the script
detach(package:dplyr, package:stringr)