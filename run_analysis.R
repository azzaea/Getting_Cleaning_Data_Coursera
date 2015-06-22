################# project

dataURL = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

# You should create one R script called run_analysis.R that does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
#    of each variable for each activity and each subject.
# 
# Good luck!

################################

# to download a zip file:
# a.Create a temp. file name (eg tempfile())
# b.Use download.file() to fetch the file into the temp. file
# c.Use unz() to extract the target file from temp. file
# d.Remove the temp file via unlink()

temp = tempfile()
str(temp)
list.files()
download.file(dataURL,destfile = temp, mode = 'wb')
unzip(temp, exdir='.')
list.files()
unlink(temp)

#################################
features = read.table('./UCI HAR Dataset/features.txt') #these are the names of the variables (could be tidy data headers)
                                                        ### information about the variables used on the feature vector.
features = features[,2]

TrainingData = read.table('./UCI HAR Dataset/train/X_train.txt',col.names = features)
TestingData =  read.table('./UCI HAR Dataset/test/X_test.txt',col.names = features)

############ step 1:
# 1. Merges the training and the test sets to create one data set.
AllData = rbind(TrainingData,TestingData)


############ step 2:
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
meanColumns = stringr::str_match(features,'mean')[,1]
x=logical(length(features))
for (i in (1:length(features)))
    x[i]=ifelse(meanColumns[i]=='NA',F,T)
meanColumns = names(AllData)[which(x)]  #which(x)# gives true indexes!
MeanMeasurements = AllData[,as.character(meanColumns)]

stdColumns = stringr::str_match(features,'std')[,1]
x=logical(length(features))
for (i in (1:length(features)))
    x[i]=ifelse(stdColumns[i]=='NA',F,T)
stdColumns = names(AllData)[which(x)]
stdMeasurements = AllData[,as.character(stdColumns)]

ExtractedMeasurements = cbind(MeanMeasurements,stdMeasurements)

# 3. Uses descriptive activity names to name the activities in the data set
actlabels = read.table('./UCI HAR Dataset/activity_labels.txt')
activityTraing = read.table('./UCI HAR Dataset/train/y_train.txt')
activityTesing = read.table('./UCI HAR Dataset/test/y_test.txt')

ExtractedMeasurements$activity=factor(rbind(activityTraing,activityTesing)$V1)
levels(ExtractedMeasurements$activity)=(actlabels$V2)

# 4. Appropriately labels the data set with descriptive variable names. 

# By this point, the dataset is actually already properly labelled...
# you may test by:
names(ExtractedMeasurements)


# 5. From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.

SubjetTraing = read.table('./UCI HAR Dataset/train/subject_train.txt')
SubjetTesing = read.table('./UCI HAR Dataset/test/subject_test.txt')

subject=factor(rbind(SubjetTraing,SubjetTesing)$V1)
Tidy=cbind(ExtractedMeasurements,subject)

Tidy = arrange(Tidy,subject,activity)

library(plyr)
Tidy = aggregate(Tidy,by=list(Tidy$subject,Tidy$activity),FUN=mean,na.action=na.omit)
??aggregate
Tidy = Tidy[,1:81]
colnames(Tidy)[1:2]=c('Object','Activity')

write.table(x = Tidy,'./UCI HAR Dataset/Tidy.txt',row.names = F)
list.files('./UCI HAR Dataset/')
 
# 
# names=colnames(Tidy)
# temp=ddply(Tidy[,1:79],.(subject,activity),summarize, tBodyAcc.mean...X = mean(tBodyAcc.mean...X),tBodyAcc.mean...Y=mean(tBodyAcc.mean...Y)
#            tBodyAcc.mean...Z=mean(tBodyAcc.mean...Z),tGravityAcc.mean...X=mean(tGravityAcc.mean...X),
#            tGravityAcc.mean...Y=mean(tGravityAcc.mean...Y),tGravityAcc.mean...Z=mean(tGravityAcc.mean...Z)
#            tBodyAccJerk.mean...X=mean(tBodyAccJerk.mean...X),tBodyAccJerk.mean...=mean(tBodyAccJerk.mean...)) 
# 
# tapply()
# 
# 
# names=names(Tidy)[1:79]
# 
# apply(split(Tidy[[1:79]],Tidy$subject),mean,na.rm=T)
# temp=mapply(mean,Tidy[1:79],by)
