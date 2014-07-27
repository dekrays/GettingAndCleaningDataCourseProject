trainSetFilePath <- "./data/UCI HAR Dataset/train/X_train.txt"
testSetFilePath <- "./data/UCI HAR Dataset/test/X_test.txt"

trainSetLabelsFilePath <- "./data/UCI HAR Dataset/train/y_train.txt"
testSetLabelsFilePath <- "./data/UCI HAR Dataset/test/y_test.txt"

trainSetSubjectsFilePath <- "./data/UCI HAR Dataset/train/subject_train.txt"
testSetSubjectsFilePath <- "./data/UCI HAR Dataset/test/subject_test.txt"

featuresFilePath <- "./data/UCI HAR Dataset/features.txt"

activityLabelsFilePath <- "./data/UCI HAR Dataset/activity_labels.txt"

if (!file.exists(trainSetFilePath)
    || !file.exists(testSetFilePath)) {
    source("download_data.R")
}

#trainSet <- read.csv("./data/UCI HAR Dataset/train/X_train.txt", sep = " ", fill = FALSE, header = FALSE)
#testSet <- read.csv("./data/UCI HAR Dataset/test/X_test.txt", sep = " ")

# Reading train set
con <- file(trainSetFilePath)
lines <- readLines(con)
close(con)

trainSet <- data.frame()
cnt <- 1
for (line in lines) {
    print(paste("Reading line ", cnt))
    cnt <- cnt + 1
    tokens <- strsplit(line, split = " ")
    tokens <- unlist(tokens)
    tokens <- tokens[tokens != ""]
    tokens <- as.numeric(tokens)
    trainSet <- rbind(trainSet, tokens)
}

# Reading test set
con <- file(testSetFilePath)
lines <- readLines(con)
close(con)

testSet <- data.frame()

cnt <- 1
for (line in lines) {
    print(paste("Reading line ", cnt))
    cnt <- cnt + 1
    tokens <- strsplit(line, split = " ")
    tokens <- unlist(tokens)
    tokens <- tokens[tokens != ""]
    tokens <- as.numeric(tokens)
    testSet <- rbind(testSet, tokens)
}

# Reading train set labels
trainSetLables <- read.csv(trainSetLabelsFilePath, colClasses = c("factor"), header = FALSE)

# Reading test set labels
testSetLabels <- read.csv(testSetLabelsFilePath, colClasses = c("factor"), header = FALSE)

# Reading train subjects
trainSetSubjects <- read.csv(trainSetSubjectsFilePath, colClasses = c("factor"), header = FALSE)

# Reading test subjects
testSetSubjects <- read.csv(testSetSubjectsFilePath, colClasses = c("factor"), header = FALSE)

# Reading features
features <- read.csv(featuresFilePath, colClasses = c("character"), header = FALSE, sep = " ")
features <- features[ , 2]

# Assigning column names
names(trainSet) <- features
names(testSet) <- features

# Assigning labels / activities
trainSet$Activities <- trainSetLables[ , 1]
testSet$Activities <- testSetLabels[ , 1]

# Adding subjects
trainSet$Subject <- trainSetSubjects[ , 1]
testSet$Subject <- testSetSubjects[ , 1]

# Merging data sets
mergedSet <- rbind(trainSet, testSet)

# Reading activity labels
activityLables <- read.csv(activityLabelsFilePath, colClasses = c("character"), header = FALSE, sep = " ")
activityLables <- activityLables[ , 2]

# Add levels to Activities column
levels(mergedSet$Activities) <- activityLables

# Identify columns with "mean" or "std"
cols <- grepl("mean\\(\\)|std", names(mergedSet))
cols[length(cols) - 1] <- TRUE # Include activity column
cols[length(cols)] <- TRUE # Include subjects column

# Build a dataset with column containing "mean" or "std"
targetSet <- mergedSet[ , cols]

# Build the tidy dataset
tidySet <- aggregate(.~Activities+Subject, data = targetSet, mean)

write.csv(tidySet, "./tidy.csv", row.names = FALSE)