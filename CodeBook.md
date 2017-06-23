
# Getting and Cleaning Data Course Project CodeBook

This Codebook describes the variables, the data and any transformations or work performed to clean up the data and produce the data file 'tidyset.txt' for the Getting and Cleaning Data course project. The README.md file included in this repository explains how the script works and how the files are connected.

The purpose of the project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare a tidy data set that can be used for later analysis.
The repository contains all files required for this course project. 

The run_analysis.R script contains code to download the UCI HAR Dataset, to read in the required test and training data files, to merge test and training files together and to extract a smaller subset containing only those variable with mean and standard deviation measurements. Variables are renamed appropriately. A second independent tidy data set is then produced.


## Data Source used for the project

The data that was used in this project is from the Human Activity Recognition (HAR) database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors and can be obtained from  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The UCI HAR Dataset consists of multivariate, time-series data of 10299 Instances and 561 Attributes. 

The data was collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the [THE UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) but a summary is provided here as follows:

Experiments were carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, the researchers captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments were  video-recorded to label the data manually. The obtained dataset was then randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 
For each record in the dataset it is provided   
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.  
- Triaxial Angular velocity from the gyroscope.    
- A 561-feature vector with time and frequency domain variables.    
- Its activity label.   
- An identifier of the subject who carried out the experiment. 

Please refer to the README.txt contained within the UCI HAR Dataset to learn more about this dataset and to the 'features_info.txt' file for more information on the feature selection.

 

## Getting and Cleaning Data Project Step by Step:
The run_analysis.R script transforms the data included in the train and test sets into a smaller tidy sata set with the following steps.



#### Step 1: Read in the required files
The run_analysis.R script contains code to download the UCI HAR Dataset to the working directory and to unzip the file. Please note for anyone intending to run this code to first set their own working directory appropriately.
There are no column names in the raw text files imported so the script adds appropriate variable names.

The Dataset.zip file contains a folder  **UCI HAR Dataset** which contains the following files along with 2 subfolders  **test** and **train**. 

- 'activity_labels.txt': Links the class labels with their activity name   
- 'features.txt': List of all features
- 'features_info.txt': shows information about the variables used on the features vector
- 'README.txt' for the Human Activity Recognition Using Smartphones Dataset 

The **test** folder contain the following text files :   

-'subject_test.txt': Each row identifies the subject who performed the activity for each sample window. Its range is from 1 to 30  
-'X_test.txt': Test set  
='y_test.txt': Test labels  

The **train** folder contains the following text files:   

-'subject_train.txt': Each row identifies the subject who performed the activity for each sample window. Its range is from 1 to 30   
- 'X_train.txt': Training set  
- 'Y_train.txt': Training labels  

There are also subfolders **Inertia Signals** in both the test and train folder but were not used for this particular course project.


#### Step 2: Merge the training and test sets to create one data set (project requirement 1)
The script first combines the 3 training files together to make one train file consisting of 7352 observations and 563 variables.
The script then combines the 3 test files to make one test file of 2947 observations and 563 variables.  
The train and test files are then merged to make a single dataset "Merged Set"
This new data set "MergedSet" will contain 10299 observations and 563 variables. 


#### Step 3: Extract only the measurements on the mean and the standard deviation for each measurement (project requirement 2)

Take a subset of the MergedSet by selecting only those columns with "mean" or "std" in the variable name.
Save this as a new dataset called 'SmallerSet' which has 10299 observations of 68 variables including the Activity ID and Subject 


#### Step 4: Apply descriptive activity names to name the activities in the data set (project requirement 3)


Merge the 'activity_labels' files which contains the 6 activity labels with the 'SmallerSet' file to add descriptive activity labels (Laying, Sitting, Standing, Walking, Walking Downstairs, Walking Upstairs) to the activities.


#### Step 5: Appropriately label the data set with descriptive variable names (project requirement 4)

The 'Features_info.txt' file contains the information indicating what the variable names mean.
Based on this information use the R gsub function to replace 't' with 'Time', 'BodyAcc' with 'Body Acceleration', 'GravityAcc' with 'GravityAcceleration', 'mag' with 'Magnitude' and 'f' with 'Freq'
 

#### Step 6: From the smaller dataset created above, create a second, independent tidy dataset with the average of each variable for each activity and each subject (project requirement 5)
Calculate the mean of each of the variable columns by Activity and Subject using the R aggregate function. There are 30 subjects with 6 activities each so the resulting tidy dataset contains 180 observations.
Write the tidy dataset to a new text file and label the columns.

The resulting tidy dataset 'tidydata.txt' follows the requirement for tidy data in the lecture "The components of tidy data" of the "Getting and Cleaning Data course" where each variable measured is in one column.
Each different observation of that variable should be in a different row.
A table can be produced for each kind of variable.
The top row contains the variable names which are human readable.

## Description of the Variables in the 'tidydata' dataset.
The following are the names of the 68 variables in the resulting 'tidydata' dataset which contains 180 observations. 
The first variable "Activity" is a factor variable with 6 levels representing the six different activities: Laying, Sitting, Standing, Walking, Walking Downstairs, Walking Upstairs.
The second variable "Subject" is an integer from 1 to 30 representing the subject performing the activity.
The remaining 64 variables are numerical variables. The value of these variables are the averages of each of the mean and standard deviation measurements in the 'SmallerSet' data set for each activity and each subject. 
Each of these variable names consist of the original variable name in the 'SmallerSet' data set prefixed with "Average" to indicate that that variable represents the average (mean) of the original measurement from which the average is calulcated. For example the third variable below 'AverageTimeBodyAccelerationMeanX' is the mean calculated for the 'TimeBodyAccelerationMeanX' variable in the 'SmallerSet' dataset.  


 [1] "Activity"                                               
 [2] "Subject"                                                
 [3] "AverageTimeBodyAccelerationMeanX"                       
 [4] "AverageTimeBodyAccelerationMeanY"                       
 [5] "AverageTimeBodyAccelerationMeanZ"                       
 [6] "AverageTimeBodyAccelerationStdDevX"                     
 [7] "AverageTimeBodyAccelerationStdDevY"                     
 [8] "AverageTimeBodyAccelerationStdDevZ"                     
 [9] "AverageTimeGravityAccelerationMeanX"                    
[10] "AverageTimeGravityAccelerationMeanY"                    
[11] "AverageTimeGravityAccelerationMeanZ"                    
[12] "AverageTimeGravityAccelerationStdDevX"                  
[13] "AverageTimeGravityAccelerationStdDevY"                  
[14] "AverageTimeGravityAccelerationStdDevZ"                  
[15] "AverageTimeBodyAccelerationJerkMeanX"                   
[16] "AverageTimeBodyAccelerationJerkMeanY"                   
[17] "AverageTimeBodyAccelerationJerkMeanZ"                   
[18] "AverageTimeBodyAccelerationJerkStdDevX"                 
[19] "AverageTimeBodyAccelerationJerkStdDevY"                 
[20] "AverageTimeBodyAccelerationJerkStdDevZ"                 
[21] "AverageTimeBodyGyroMeanX"                               
[22] "AverageTimeBodyGyroMeanY"                               
[23] "AverageTimeBodyGyroMeanZ"                               
[24] "AverageTimeBodyGyroStdDevX"                             
[25] "AverageTimeBodyGyroStdDevY"                             
[26] "AverageTimeBodyGyroStdDevZ"                             
[27] "AverageTimeBodyGyroJerkMeanX"                           
[28] "AverageTimeBodyGyroJerkMeanY"                           
[29] "AverageTimeBodyGyroJerkMeanZ"                           
[30] "AverageTimeBodyGyroJerkStdDevX"                         
[31] "AverageTimeBodyGyroJerkStdDevY"                         
[32] "AverageTimeBodyGyroJerkStdDevZ"                         
[33] "AverageTimeBodyAccelerationMagnitudeMean"               
[34] "AverageTimeBodyAccelerationMagnitudeStdDev"             
[35] "AverageTimeGravityAccelerationMagnitudeMean"            
[36] "AverageTimeGravityAccelerationMagnitudeStdDev"          
[37] "AverageTimeBodyAccelerationJerkMagnitudeMean"           
[38] "AverageTimeBodyAccelerationJerkMagnitudeStdDev"         
[39] "AverageTimeBodyGyroMagnitudeMean"                       
[40] "AverageTimeBodyGyroMagnitudeStdDev"                     
[41] "AverageTimeBodyGyroJerkMagnitudeMean"                   
[42] "AverageTimeBodyGyroJerkMagnitudeStdDev"                 
[43] "AverageFrequencyBodyAccelerationMeanX"                  
[44] "AverageFrequencyBodyAccelerationMeanY"                  
[45] "AverageFrequencyBodyAccelerationMeanZ"                  
[46] "AverageFrequencyBodyAccelerationStdDevX"                
[47] "AverageFrequencyBodyAccelerationStdDevY"                
[48] "AverageFrequencyBodyAccelerationStdDevZ"                
[49] "AverageFrequencyBodyAccelerationJerkMeanX"              
[50] "AverageFrequencyBodyAccelerationJerkMeanY"              
[51] "AverageFrequencyBodyAccelerationJerkMeanZ"              
[52] "AverageFrequencyBodyAccelerationJerkStdDevX"            
[53] "AverageFrequencyBodyAccelerationJerkStdDevY"            
[54] "AverageFrequencyBodyAccelerationJerkStdDevZ"            
[55] "AverageFrequencyBodyGyroMeanX"                          
[56] "AverageFrequencyBodyGyroMeanY"                          
[57] "AverageFrequencyBodyGyroMeanZ"                          
[58] "AverageFrequencyBodyGyroStdDevX"                        
[59] "AverageFrequencyBodyGyroStdDevY"                        
[60] "AverageFrequencyBodyGyroStdDevZ"                        
[61] "AverageFrequencyBodyAccelerationMagnitudeMean"          
[62] "AverageFrequencyBodyAccelerationMagnitudeStdDev"        
[63] "AverageFrequencyBodyBodyAccelerationJerkMagnitudeMean"  
[64] "AverageFrequencyBodyBodyAccelerationJerkMagnitudeStdDev"
[65] "AverageFrequencyBodyBodyGyroMagnitudeMean"              
[66] "AverageFrequencyBodyBodyGyroMagnitudeStdDev"            
[67] "AverageFrequencyBodyBodyGyroJerkMagnitudeMean"          
[68] "AverageFrequencyBodyBodyGyroJerkMagnitudeStdDev"  

Please see 'features_info.txt' file contained within the UCI HAR Dataset for further information on the original variables or features from which the 'TidyData' variables are derived. The complete list of variables of each feature vector is available in 'features.txt' file. 
The following is an extract from the 'features_info.txt' file:

*The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals  were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz* 

*Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals. Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm.*

*Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). *

*These signals were used to estimate variables of the feature vector for each pattern:* 
*'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions*   
 
 

tBodyAcc-XYZ  
tGravityAcc-XYZ  
tBodyAccJerk-XYZ  
tBodyGyro-XYZ  
tBodyGyroJerk-XYZ  
tBodyAccMag  
tGravityAccMag  
tBodyAccJerkMag  
tBodyGyroMag  
tBodyGyroJerkMag  
fBodyAcc-XYZ  
fBodyAccJerk-XYZ  
fBodyGyro-XYZ  
fBodyAccMag  
fBodyAccJerkMag  
fBodyGyroMag  
fBodyGyroJerkMag  


Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:   

gravityMean  
tBodyAccMean  
tBodyAccJerkMean  
tBodyGyroMean  
tBodyGyroJerkMean  

