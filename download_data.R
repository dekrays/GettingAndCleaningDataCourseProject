# Creata data directory if not existing
if (!file.exists("data")) {
    dir.create("data");
}

# Dowload the dataset if it's not containing within the data directory
if (!file.exists("./data/Dataset.zip")) {
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url = fileURL, destfile = "./data/Dataset.zip", method = "curl")
}

# Unzip the dataset
unzip("./data/Dataset.zip", exdir = "./data/")