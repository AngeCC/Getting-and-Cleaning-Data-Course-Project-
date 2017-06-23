# run_analysis.R script file for the Getting and Cleaning Data Course Project

# This script run_analysis.R will perform the following steps on the UCI HAR Dataset to 
# meet the requirements of the Getting and Cleaning data course project. The UCI HAR Dataset
# is available at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# 1. Merges the training and test sets to create one data set
# 2. Extract only the measurements on the mean and the standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names
# 5. From the data set in step 4, creates a second, independent tidy data set with the 
#     average of each variable for each activity and each subject
# Please see the README and Codebook files for further details.


#####################
# 1. Merges the training and test sets to create one data set

setwd("~/Desktop/Getting and Cleaning Data")  # set my working directory
# Note for anyone else running this script to set your own working directory appropriately

# Set or create a folder "ProjectData" to hold all the data for the project:
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("ProjectData")){
    dir.create("ProjectData")
}

# download project dataset which is a zip file to this folder
download.file(fileUrl,destfile = "./ProjectData/dataset.zip",method ="curl", mode="wb")
list.files("./ProjectData")# list the files in the folder
# unzip the dataset.zip file and see what files or subfolders are within it
unzip(zipfile="./ProjectData/dataset.zip", exdir = "./ProjectData")
list.files("./ProjectData")  # contains a folder called "UCI HAR Dataset"
list.files("./ProjectData/UCI HAR Dataset")   # see what is in the  "UCI HAR Dataset" folder

# Read in and look at the structure of each of the relevant files.
# Note that there are no headers in the text files.

activity_labels<-read.table("./ProjectData/UCI HAR Dataset/activity_labels.txt")  
str(activity_labels)  # 6 obs. of  2 variables: activity ids and activity names
# This file contains the names of each of the 6 activity types and the activity id 1 to 6

features<-read.table("././ProjectData/UCI HAR Dataset/features.txt")
head(features); tail(features) 
str(features)
dim(features)
# "features" contains 561 obs of 2 variables, feature id and feature name (various measurements)


subjecttrain<-read.table("./ProjectData/UCI HAR Dataset/train/subject_train.txt")  
subjecttest<-read.table("./ProjectData/UCI HAR Dataset/test/subject_test.txt")
# examine subject files
str(subjecttrain) # 7352 obs. of  1 variable:
head(subjecttrain); tail(subjecttrain)
str(subjecttest) #2947 obs. of  1 variable:
head(subjecttest); tail(subjecttest)  

# Read in train and test files. 
xtrain<-read.table("./ProjectData/UCI HAR Dataset/train/X_train.txt")
ytrain<-read.table("./ProjectData/UCI HAR Dataset/train/Y_train.txt")
str(xtrain) # 7352 obs. of  561 variables:
str(ytrain)   # 7352 obs. of  1 variable
xtest<-read.table("./ProjectData/UCI HAR Dataset/test/X_test.txt")
ytest<-read.table("./ProjectData/UCI HAR Dataset/test/Y_test.txt")
str(xtest) # data.frame':	2947 obs. of  561 variables:
str(ytest)   # 2947 obs. of  1 variable:


# Assign column names appropriately to the variables in the imported files

activity_labels
colnames(activity_labels)<-c("ActivityID","Activity")
colnames(features)<-c("FeaturesID","Feature")      

colnames(subjecttest)<-"Subject"  # add column name 
colnames(subjecttrain)<-"Subject"  # add column name 


# rename ytrain and ytest files with the Activity ID
colnames(ytrain)<-"ActivityID"
colnames(ytest)<-"ActivityID"

# Add column names to xtrain and xtest files using the features file
colnames(xtrain)<-features[,2]; 
names(xtrain)
colnames(xtest)<-features[,2]
names(xtest)

# There are 6 files to merge to create one data set: subjecttrain, xtrain, ytrain, subjecttest, xtest, ytest
# First look at the dimensions of the files: 
dim(subjecttrain); dim(xtrain); dim(ytrain)
dim(subjecttest); dim(xtest); dim(ytest)

# First combine the training files into one set called "Train" using cbind. 
Train<-cbind(subjecttrain,ytrain,xtrain)  # put subjecttrain and ytrain as first 2 columns as these contain
# subject and activity ids. 
str(Train) #  merged Train file should have 7352 rows and 563 columns

# Combine the test files in a similar way into one set called "Test"
Test<-cbind(subjecttest,ytest,xtest)
str(Test) # the merged Test file should have 2947 rows and 563 columns

# Next combine the Train and Test files by row binding to make a single dataset "MergedSet"
MergedSet<-rbind(Train,Test)
dim(MergedSet)  # should have 10299 rows and 563 columns

names(MergedSet)
head(MergedSet[,1:4])  # just look at the first few columns as very wide
head(MergedSet[,c(1:3,561:563)]) # look at last few columns

# The training and test sets have now been merged to create one dataset (Requirement 1)
##########################

# 2. Extract only the measurements on the mean and the standard deviation for each measurement.

# To do this I will take the 561 feature measurement variables and find relevant variables 
# using grepl to return a logical vector of TRUE values for the mean() and std() variables. 
# Finds variable names with "mean" and "std" but not including "MeanFreq"
# Then store results in a vector of required column names together with "Activity ID" and "Subject"

splitNames<-strsplit(colnames(MergedSet),"\\.")
MeanStd<-names(MergedSet[,(grepl("std",splitNames) | grepl("mean",splitNames) & !grepl("meanFreq",splitNames))])
Columns<-c("ActivityID","Subject",MeanStd) 
SmallerSet<-MergedSet[,Columns]  # select a subset with the required columns only
names(SmallerSet)
length(SmallerSet)  # 68 variables including Activity ID and Subject
str(SmallerSet)
head(SmallerSet[,c(1:6,63:68)]) # have a look at some of the data

# Now the measurements on the mean and standard deviation for each measurement have been
# extracted for requirement 2.

########################

# 3. Use descriptive activity names to name the activities in the data set


# Merge the activity_labels files with the SmallerSet file to add descriptive activity names
# for the activities in the data set
activity_labels  # contains the 6 activity labels
SmallerSet<-merge(activity_labels,SmallerSet,,by.x="ActivityID", by.y="ActivityID")
str(SmallerSet)
# 
# Now the activities in the data have descriptive activities names for requirement 3 

#####################

# 4. Appropriately label the data set with descriptive variable names. 

# The 'Features_info.txt' file contains the information indicating what the variable names mean.

# Based on this information I will use gsub to replace 't' with 'Time', 'BodyAcc' with 'Body Acceleration',
# 'GravityAcc' with 'GravityAcceleration', 'BodyAccJerk' with 'BodyLinearAcceleration',
# 'BodyGyroJerk' with 'BodyAngularVelocity', 'mag' with 'Magnitude', #'f' with 'Freq'
 
colnames(SmallerSet)  # look at variable names
names(SmallerSet)<-gsub('^t',"Time", names(SmallerSet))
names(SmallerSet)<-gsub("BodyAcc","BodyAcceleration", names(SmallerSet))
names(SmallerSet)<-gsub("GravityAcc","GravityAcceleration", names(SmallerSet))
names(SmallerSet)<-gsub("Mag","Magnitude", names(SmallerSet))
names(SmallerSet)<-gsub("^f","Frequency", names(SmallerSet))
names(SmallerSet)<-gsub("mean","Mean", names(SmallerSet))
names(SmallerSet)<-gsub("std","StdDev", names(SmallerSet))
names(SmallerSet)<-gsub("-","", names(SmallerSet))
names(SmallerSet)<-gsub("\\()","", names(SmallerSet))
names(SmallerSet)  # check to make sure all changes have been processed

# Now the SmallerSet data set has been labelled with descriptive variable names

####################

# 5. From the data set in step 4, creates a second, independent tidy data set with the 
#     average of each variable for each activity and each subject


# There are 30 subjects with 6 activity types each so should have 180 rows in total
# using the aggregate function, get the mean of each of the variable columns by Activity and Subject

tidydata<-aggregate(SmallerSet[4:length(SmallerSet)], list(SmallerSet$Activity,SmallerSet$Subject),mean)
names(tidydata)
str(tidydata)
head(tidydata)
tail(tidydata)

names(tidydata)  # have a look at the names
names(tidydata)<-paste0("Average",names(tidydata))  # each column holds the average of each variable
# for each activity and each subject so paste "Average" to start of each column name
names(tidydata)
names(tidydata)<-sub("AverageGroup.1","Activity",names(tidydata))  # rename Activity Column
names(tidydata)<-sub("AverageGroup.2","Subject",names(tidydata))  # rename Subject column
names(tidydata)  # check to see all columns are appropriately labeled

# now write the tidy data set to a text file
write.table(tidydata,file="tidydata.txt",row.names = FALSE)
list.files()  # check to see if the tidydataset text file has been created

tidyset<-read.table("tidydataset.txt",header=TRUE)  # read in to check it is ok
head(tidyset)
str(tidyset)

# From the data set in step 4, a second, independent tidy data set with the average of each
# variable for each activity and each subject has been created for requirement 5


# Below I just do a check to see if the tidyset is producing the correct averages 
# by filtering by subject id and activity and then getting the column means of some columns

library(dplyr)
# can view the 'tidyset' and use the Filter  tool to select different rows
View(tidyset)
colMeans(filter(SmallerSet,Subject==7 & Activity == "LAYING") [,4:9])# 
colMeans(filter(SmallerSet,Subject==4 & Activity == "SITTING") [,4:9])# 





## testing only to see if table output meets tidy data requirements
table(tidyset$Activity)
table(tidyset$Subject)
table(tidyset$AverageTimeBodyAccelerationMeanX)
