downloader <- function() {

    if(!file.exists("UCI HAR Dataset")){

        print("Unzipped directory not available. Look for zipped file.")

        if(!file.exists("DataPackage.zip")){

            print("Zipped file unavailable, downloading...")
            download.file(
                "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip ", 
                destfile="DataPackage.zip", method="auto", mode="wb")

        }
        else{
            print("Zipped file found")
        }
        print("Unzipping data")
        unzip("DataPackage.zip")

    }

    print("Data directory exists.")
}

# Get data
downloader()

# Read data
activity_labels <-  read.table("./UCI HAR Dataset/activity_labels.txt")
features <-  read.table("./UCI HAR Dataset/features.txt")    
subject_train <-  read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <-  read.table("./UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
X_test <-  read.table("./UCI HAR Dataset/test/X_test.txt")
y_train <-  read.table("./UCI HAR Dataset/train/y_train.txt")
y_test <-  read.table("./UCI HAR Dataset/test/y_test.txt")

# Unify datasets
subject <- rbind(subject_test, subject_train)
xall <- rbind(X_test, X_train)
yall <- rbind(y_test, y_train)
names(xall) <- features$V2
names(subject) <- c("subject")
names(yall) <- c("activity")
data_all <- cbind(subject, yall, xall)
data_all$activity <- factor(data_all$activity,activity_labels[[1]],activity_labels[[2]])

# Extract only the measurements on the mean and standard deviation for each measurement
mean_or_sd <- grepl("subject|activity|mean|std", names(data_all))
extracted_data <- data_all[mean_or_sd]
write.table(extracted_data, file="mean_std_data_set.txt")

# Tidy data summary
tidy_data <- aggregate(data_all, by=list(data_all$subject, data_all$activity), FUN=mean)
sprintf("%d rows aggregated into %d rows \n", nrow(data_all), nrow(tidy_data))
write.table(tidy_data, file="tidy_data_set.txt", row.names=FALSE)    

