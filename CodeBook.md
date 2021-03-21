This is the code book for the Course Project for the "Getting and Cleaning Data" course of Johns Hopkins University (hosted on Coursera)


A brief description of the original data is given below.


The data set used in this project is the "UCI HAR Dataset", which is originally from Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

The original data set consists of two sets of observations, one being the training data and the other being the test data. The folders "test" and "train" contain these data.
In these folders are contained the files "subject", "y" and "X", which respectively contain the individual persons' IDs, the activity IDs and the measured features for each observation.

The list of features can be found in the "features.txt" file within the "UCI HAR Dataset" folder and the description of these features can be found in the "features_info.txt" file within the same folder.

The "test" and "train" folders also contain the "Inertial Signals" folder, which contain the raw measurements of the variables. Since these variables do not represent means or standard deviations, we don't need to include these variables separately in our analysis as our script gets rid of all features that do not have the words "mean" or "std" in them.
The activity names can be found in the "activity_labels.txt" file.


A brief description of the Coursera Assignment is given below.


Create an R script called "run_analysis.R" which performs the following.


Merges the training and the test sets to create one data set.

Extracts only the measurements on the mean and standard deviation for each measurement.

Uses descriptive activity names to name the activities in the data set.

Appropriately labels the data set with descriptive variable names.

Creates a second, independent tidy data set from the data set in step (d) which contains the average of each variable for each activity and each subject.


Create a GitHub repo with the script "run_analysis.R", the new data set "new_data_set.txt", a readme file "README.md" which explains the analysis files and a code book file "CodeBook.md" which describes the data sets, variables and all transformations performed to obtain the new data set.


Some important metrics related to the original data set are given below.


The "subject_train" data set contains the subject IDs of 7352 observations.

The "y_train" data set contains the activity IDs of 7352 observations.

The "X_train" data set contains the measurements of 561 features measured in 7352 observations.

The "subject_test" data set contains the subject IDs of 2947 observations.

The "y_test" data set contains the activity IDs of 2947 observations.

The "X_test" data set contains the measurements of 561 features measured in 2947 observations.

The total number of observations is 10229.


A stage-wise description of "run_analysis.R" is given below.


Stage 1 - The training and test data for all the 10229 observations are read from the respective files and stored in the data frames "subject_train", "y_train", "X_train", "subject_test", "y_test" and "X_test". Here, the "train" data frames contain 7352 rows while the "test" data frames contain 2947 rows.

Stage 2 - The activity names are read and stored in the vector "act_names" and the feature names are read and stored in the vector "features".

Stage 3 - The feature names containing either "mean" or "std" in their names are extracted and their indices are stored in the logical vector "mean_or_std". Note that this step is case-agnostic. Also, note that the number of "TRUE"s in this vector is 86.

Stage 4 - The training and test data frames for subject IDs, activity IDs and features are merged by row into 3 data frames of 10229 rows each. Note that the test data are appended below the training data in the respective data frames. Here, the variable names for subject IDs and activity IDs are appropriately named. While performing the row-wise merge for the features data frame, the "mean_or_std" vector is used to extract only those variables that contain "mean" or "std" in them.

Stage 5 - The variable names in the features data frame are appropriately cleaned. Note that parentheses, hyphens, underscores, white-spaces etc have all been removed. Also note that the string "t" is replaced with the string "time" and the string "f" is replaced with the string "freq".

Stage 6 - The "subject", "y" and "X" data frames are merged by column into a single data frame. Note that this data frame has 10229 rows and 88 columns.

Stage 7 - The activity IDs in the "Activity" column of this data frame are renamed appropriately using the "act_names" vector.

Stage 8 - The data frame is grouped by "SubjectID" and "Activity" and is summarized by the mean of each variable. Note that the data frame now has 180 rows and 88 columns. This is because for all 30 subjects IDs and all 6 activity IDs, we get 180 unique subject-activity combinations.

Stage 9 - The new data frame is stored in the file "new_data_set.txt"


A brief description of the new data set in the file "new_data_set.txt" is given below.


The data set consists of 180 rows and 88 columns.

Each row corresponds to a unique subject-activity combination. Since the original data set contains 30 subject IDs and 6 activity IDs, we get 180 unique subject-activity combinations.

The first column contains the subject IDs.

The second column contains the activity IDs.

All subsequent columns contain the various features that were measured using the device. Note that the values in these columns are means of the measurements for each subject-activity combination.


The reader may read the new data set by appropriately modifying the following command.
new_data = read.table("new_data_set.txt")


The following characteristics of "new_data_set.txt" make it tidy.


Each row contains a single observation of a unique subject-activity combination.

Each column contains a single variable.

The data frame is grouped by the unique subject-activity pairs and each column contains the means of each feature of each unique subject-activity pair.