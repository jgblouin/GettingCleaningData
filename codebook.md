##************CODEBOOK******************

Codebook for the dtTidy data set.

###List of variables and their description

N.B. The identifier Feature indicates these are part of the features mentioned in the features.txt and features_info.txt files in the UCI HAR dataset. Further information about the variables is available in the README.txt file for the UCI HAR dataset. 

Variable name | Description
-----------------|------------
subject | ID for the subject who performed the activity for each window sample. Its range is from 1 to 30.
activity | Activity name: the activities listed in the activity_labels.txt file in the UCI HAR dataset.
domain | Feature: Time domain signal or frequency domain signal (Time or Freq).
instrument | Feature: Measuring instrument (Accelerometer or Gyroscope).
acceleration | Feature: Acceleration signal (Body or Gravity).
variable | Feature: The required variables (Mean or SD).
jerk | Feature: Jerk signal.
magnitude | Feature: Magnitude of the signals calculated using the Euclidean norm.
axis | Feature: 3-axial signals in the X, Y and Z directions (X, Y, or Z).
count | Feature: Count of data points used to compute `average`.
average | Feature: Average of each variable for each activity and each subject.

For more information about the dtTidy dataset, use any of the following.

dtTidy lists a few rows at the beginning and at the end of the dataset.

str(dtTidy) indicates the structure of the dtTidy dataset.

summary(dtidy) gives a summary of the dtTidy dataset.

The data from the dtTidy dataset has been saved in the tidy_HAR.txt file.

