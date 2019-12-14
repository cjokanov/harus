---
title: "Tidy Example CodeBook"
author: "CJ"
date: "12/14/2019"
output: html_document
---

## About this file
This file includes list of variables variables, description of data, and methodology used to transform data from initial dataset into *tidy_data.csv*, located in output directory


## Variables

 dataset     : Factor with 2 levels "test","train"  - reference to original dataset
 subject     : int; designating the subject id  
 activityname: Factor with 6 levels LAYING SITTING STANDING WALKING WALKING_DOWNSTAIRS WALKING_UPSTAIRS  
 sampletype  : Factor with 2 levels "freq","time"  
 signal      : Factor with 3 levels "jerk","jerkmagnitude", "magnitude"  
 source      : Factor with 2 levels "accmeter","gyroscope"  
 acceleration: Factor with 2 levels "body","gravity"  
 param       : Factor with 2 levels "mean","std"  
 axis        : Factor with 3 levels "x","y","z"  
 value       : num 
 
 
 
## Description of data

Original data:  
==================================================================  
Human Activity Recognition Using Smartphones Dataset  
Version 1.0  
==================================================================  
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.  
Smartlab - Non Linear Complex Systems Laboratory  
DITEN - Universit? degli Studi di Genova.  
Via Opera Pia 11A, I-16145, Genoa, Italy.  
activityrecognition@smartlab.ws  
www.smartlab.ws  
==================================================================  

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012  




## Methodology applied to original data set

Original dataset is located in input directory


1. train and test data sets were merged, preserving the indicator for eaxh record in column dataset showing which dataset data comes from  

2. Only columns containig mean or std have been kept, other columns have been removed fro the dataset

3. dataset was transformed to contain values and variable description in single column each

4. based on variable description factor variables have been generated to separate each variable determinant into separate column

5. dataset names were converted into readable form and dataset was tidied




