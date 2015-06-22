# Getting_Cleaning_Data_Coursera
This repo is created as part of the activity for the coursera class: Getting and Cleaning Data

For this exercise, the data was first downloaded then unzipped, and various variables were extracted from several files. Here are some steps:

##to download a zip file:
a.Create a temp. file name (eg tempfile())
b.Use download.file() to fetch the file into the temp. file
c.Use unz() to extract the target file from temp. file
d.Remove the temp file via unlink()

##tables read:
'./UCI HAR Dataset/features.txt'
'./UCI HAR Dataset/train/X_train.txt'
'./UCI HAR Dataset/test/X_test.txt'
'./UCI HAR Dataset/activity_labels.txt'
'./UCI HAR Dataset/train/y_train.txt'
'./UCI HAR Dataset/test/y_test.txt'
'./UCI HAR Dataset/train/subject_train.txt'
'./UCI HAR Dataset/test/subject_test.txt'