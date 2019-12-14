


##Load libraries
library(dplyr)
library(reshape2)

##Read x_train, y_train and subject_train

xtrain<-read.table("input/train/X_train.txt", header=FALSE)
ytrain<-read.table("input/train/y_train.txt", header=FALSE)
subjtrain<-read.table("input/train/subject_train.txt", header=FALSE)

ytrain<-rename(ytrain,activity=V1)
subjtrain<-rename(subjtrain,subject=V1)
subjtrain$dataset<-"train"
train<-cbind.data.frame(ytrain,subjtrain,xtrain)
train<-tbl_df(train)

rm(xtrain,ytrain,subjtrain)

##Do the same for test data

xtest<-read.table("input/test/X_test.txt", header=FALSE)
ytest<-read.table("input/test/y_test.txt", header=FALSE)
subjtest<-read.table("input/test/subject_test.txt", header=FALSE)

ytest<-rename(ytest,activity=V1)
subjtest<-rename(subjtest,subject=V1)
subjtest$dataset<-"test"
test<-cbind.data.frame(ytest,subjtest,xtest)
test<-tbl_df(test)

rm(xtest,ytest,subjtest)


#append together two datasets
tdata<-bind_rows(train,test)
tdata$dataset<-as.factor(tdata$dataset)
rm(test,train)

##read features names
features<-read.table("input/features.txt", header=FALSE)
features<-rbind(data.frame(V1 = 0, V2 = "activity"),data.frame(V1 = 0, V2 = "subject"),data.frame(V1 = 0, V2 = "dataset"), features)

names(tdata)<-as.character(features$V2)

##find columns witg mean or stdev
selectcolumns<-grepl("mean\\(\\)|std\\(\\)",features$V2)
selectcolumns[1]<-TRUE ##keep first 2 columns 
selectcolumns[2]<-TRUE
selectcolumns[3]<-TRUE

tdata<-tdata[,selectcolumns]

rm(selectcolumns, features)

##prepare inputs for melt function - id variables and measuring variables
idvars<-c("activity","subject","dataset")
measvars<-names(tdata)
measvars<-measvars[4:length(measvars)]

#reshape the data so that we get all readings in single column
datamelt<-melt(tdata,id=idvars,measure.vars=measvars)
datamelt<-tbl_df(datamelt)
rm(idvars,measvars,tdata)

#all variables are now in one column named variable
##
##

##extracting factor variable sampletype={time,freq}
datamelt<-mutate(datamelt,sampletype = if_else(grepl("^t",datamelt$variable),"time","freq"))
datamelt$sampletype=as.factor(datamelt$sampletype)


##extracting the param type variable param={mean,std}
datamelt$param <- case_when(
  grepl("mean",datamelt$variable) ~ "mean",
  grepl("std",datamelt$variable) ~ "std")
datamelt$param<-as.factor(datamelt$param)

##extracting the axis factor axis={x,y,z}
datamelt$axis <- as.factor(case_when(
  grepl("X$",datamelt$variable) ~ "x",
  grepl("Y$",datamelt$variable) ~ "y",
  grepl("Z$",datamelt$variable) ~ "z"
))

##extracting acceleration variable acceleration={body,gravity}
datamelt$acceleration <- as.factor(case_when(
  grepl("Body",datamelt$variable) ~ "body",
  grepl("Gravity",datamelt$variable) ~ "gravity"
))

##extracting the source variable source={accmeter,gyroscope}
datamelt$source <- as.factor(case_when(
 grepl("Acc",datamelt$variable) ~ "accmeter",
 grepl("Gyro",datamelt$variable) ~ "gyroscope"
))

##extract the signal var signal={jerkmagnitude,jerk,magnitude}
datamelt$signal <- as.factor(case_when(
  grepl("JerkMag",datamelt$variable) ~ "jerkmagnitude",
  grepl("Jerk-",datamelt$variable) ~ "jerk", 
  grepl("Mag-",datamelt$variable) ~ "magnitude"
))

##map activity to activity names
activitynames<-read.table("input/activity_labels.txt")
activitynames<-rename(activitynames,activity=V1,activityname=V2)
datamelt<-left_join(datamelt,activitynames)

##create final tidy dataset with proper order of columns and delete remains
tidy<-select(datamelt,dataset,subject,activityname,sampletype, signal,source,acceleration,param,axis,value)
rm(datamelt)
write.csv(tidy,"output/tidy_data.csv")



ts<-tidy %>%
     group_by(activityname,subject) %>%
     summarise(mean = mean(value), n = n())

write.csv(ts,"output/summary_data.csv")
rm(tidy,ts)

