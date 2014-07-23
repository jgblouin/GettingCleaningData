
# Setting up

##Load the required packages.

packages <- c("data.table", "reshape2")
sapply(packages, require, character.only = TRUE, quietly = TRUE)

##Get the path. Data will be saved here.
projectPath <- getwd()

##Download the data.
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## Where the download will be saved in the path.
location <- "Dataset.zip"

if (!file.exists(projectPath)) {
        dir.create(projectPath)
}
##Commenting out download so  not to download by error, as file already downloaded.
##download.file(fileUrl, file.path(projectPath, location))

##Unzip the file using unzip.
##This is also commented out for convenience.
##unzip(location)
##This has extracted the files in the folder ""UCI HAR Dataset". Set this as the path.
HARPath<-file.path(projectPath, "UCI HAR Dataset")

##List the files in HARPath.
list.files(HARPath, recursive = TRUE)

##Detailed information about the dataset is available in the README.txt file in the folder"UCI HAR Dataset" 
##Inertial files are not needed.
##Read in the train and test files.
##Read the subject files in data tables: subject_train.txt and subject_test.tx.
dtSubjectTrain <- fread(file.path(HARPath, "train", "subject_train.txt"))
dtSubjectTest <- fread(file.path(HARPath, "test", "subject_test.txt"))

##Read the activity files for train and text.
dtActivityTrain <- fread(file.path(HARPath, "train", "Y_train.txt"))
dtActivityTest <- fread(file.path(HARPath, "test", "Y_test.txt"))

##Use a function to read the activity tables and convert the data frames created into data tables in order to get the data files. 
fileToDataTable <- function(f) {
        df <- read.table(f)
        dt <- data.table(df)
}

##Read in the activity tables using the above function.
##There must be a prettier way of doing this more directly, without the help of the above function.
dtTrain <- fileToDataTable(file.path(HARPath, "train", "X_train.txt"))
dtTest <- fileToDataTable(file.path(HARPath, "test", "X_test.txt"))

##1. Merge the training and the test sets to create one data set.
##Merge both Train and test tables into one for each case.
dtSubject <- rbind(dtSubjectTrain, dtSubjectTest)
setnames(dtSubject, "V1", "subject")

dtActivity <- rbind(dtActivityTrain, dtActivityTest)
setnames(dtActivity, "V1", "activitynumber")

dt <- rbind(dtTrain, dtTest)

##Merge the columns.
dtSubject <- cbind(dtSubject, dtActivity)
dt <- cbind(dtSubject, dt)

##Define subject and activitynumber as a keys for dt.
setkey(dt, subject, activitynumber)

#2. Extract only the measurements on the mean and standard deviation for each measurement. 
## The features.txt file lists all the features in dt. 
##All measurements on the mean and standard deviation are indicated. 
dtFeatures <- fread(file.path(HARPath, "features.txt"))

##Set relevant names in dtFeatures.
setnames(dtFeatures, names(dtFeatures), c("featurenumber", "featurename"))

##Only the mean and standard deviation elements are needed.
dtFeatures <- dtFeatures[grepl("mean\\(\\)|std\\(\\)", featurename)]

##Add the column numbers from the dt data table to dtFeatures.
dtFeatures$featureoriginal<- dtFeatures[, paste0("V", featurenumber)]

##Subset the variables featureoriginal by variable names, i.e. keeping only the variables involving mean and standard deviation.
subsetVars <- c(key(dt), dtFeatures$featureoriginal)
dt <- dt[, subsetVars, with = FALSE]

##3. Use descriptive activity names to name the activities in the data set

##The activity names can be found in the activity_labels.t5xt file in the ""UCI HAR Dataset" folder.
dtActivityNames <- fread(file.path(HARPath, "activity_labels.txt"))
setnames(dtActivityNames, names(dtActivityNames), c("activitynumber", "activityname"))

## Merge the activity names with dt.
dt <- merge(dtActivityNames,dt, by = "activitynumber", all.x = TRUE)

setkey(dt, subject, activitynumber, activityname)

##Melt the data table, making one long table with columns subject, activitynumber,featureoriginal and value.
dt <- data.table(melt(dt, key(dt), variable.name = "featureoriginal"))

##Merge activity name.
dt <- merge(dt, dtFeatures[, list(featurenumber, featureoriginal, featurename)], by = "featureoriginal", all.x = TRUE)

##Create new factor classes activity and feature from activity_name and feature_name. 
dt$activity <- factor(dt$activityname)
dt$feature <- factor(dt$featurename)

##Separate feature from featurename with the following function.
grepthis <- function(regex) {
        grepl(regex, dt$feature)
}

## Features with 2 categories
n <- 2
y <- matrix(seq(1, n), nrow = n)
x <- matrix(c(grepthis("^t"), grepthis("^f")), ncol = nrow(y))
dt$domain <- factor(x %*% y, labels = c("Time", "Freq"))
x <- matrix(c(grepthis("Acc"), grepthis("Gyro")), ncol = nrow(y))
dt$instrument <- factor(x %*% y, labels = c("Accelerometer", "Gyroscope"))
x <- matrix(c(grepthis("BodyAcc"), grepthis("GravityAcc")), ncol = nrow(y))
dt$acceleration <- factor(x %*% y, labels = c(NA, "Body", "Gravity"))
x <- matrix(c(grepthis("mean()"), grepthis("std()")), ncol = nrow(y))
dt$variable <- factor(x %*% y, labels = c("Mean", "SD"))

## Features with 1 category
dt$jerk <- factor(grepthis("Jerk"), labels = c(NA, "Jerk"))
dt$magnitude <- factor(grepthis("Mag"), labels = c(NA, "Magnitude"))

## Features with 3 categories
n <- 3
y <- matrix(seq(1, n), nrow = n)
x <- matrix(c(grepthis("-X"), grepthis("-Y"), grepthis("-Z")), ncol = nrow(y))
dt$axis <- factor(x %*% y, labels = c(NA, "X", "Y", "Z"))

##Verify that all cases have been accounted.
r1 <- nrow(dt[, .N, by = c("feature")])
r2 <- nrow(dt[, .N, by = c("domain", "acceleration", "instrument", 
                           "jerk", "magnitude", "variable", "axis")])
r1 == r2
##REsult is TRUE, thus all cases have been accounted.

##Create the tidy data set with the average of each variable for activities and subjects in the dataset. 
setkey(dt, subject, activity, domain, acceleration, instrument, 
       jerk, magnitude, variable, axis)
dtTidy <- dt[, list(count = .N, average = mean(value)), by = key(dt)]

##SAve the tidy dataset in a .txt file called tidy_HAR.txt file.
##First, create the file tidy_HAR.txt file using a script editor.
f <- file.path(projectPath, "tidy_HAR.txt")
write.table(dtTidy, f, quote=FALSE, sep="\t", row.names=FALSE)

##The text file contaisns all the elements of the dtTidy dataset.

