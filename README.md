#*******************README***********************

by: Jean-Guy Blouin

#Description

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

 You should create one R script called run_analysis.R that does the following. 

*1.Merges the training and the test sets to create one data set.

*2.Extracts only the measurements on the mean and standard deviation for each measurement.

*3.Uses descriptive activity names to name the activities in the data set

*4.Appropriately labels the data set with descriptive variable names. 

*5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

#Reproducing the project
*Open the R script run_analysis.R in a script editor.

*The file download has been commented out for convenience, so as not to download the file every time the script is run. 

*To verify downloading, delete the comment "#" tags in lines 22, which performs the download, and 26, which unzips the file.This saves the downloaded file in the folder "Dataset.zip" in the working directory.If using your own version of the downloaded file, line 28 can be modified to indicate the path to your file.

*Run the file run_analysis.R either by pasting the file in the R console or by highlighting the entire file and clicking "Run".

#Output

*Line 148 produces the tidy data set, which can then be examined using any of head(), tail(), summary(), str().

* Lines 152-153 create a text file tidy_HAR.txt containing the data set and can be opend simply by clicking on it.

