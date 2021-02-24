library(data.table)
library(dplyr)
library(tidyr)

x_dirs <- list(xtrain = './UCI HAR Dataset/train/X_train.txt',
               xtest = './UCI HAR Dataset/test/X_test.txt')

y_dirs <- list(ytrain = './UCI HAR Dataset/train/y_train.txt',
              ytest = './UCI HAR Dataset/test/y_test.txt')
activity_labels_dir <- './UCI HAR Dataset/activity_labels.txt'
features_dir <- './UCI HAR Dataset/features.txt'

run_analysis <- function() {
        x <- do.call(rbind, lapply(x_dirs, read.table))
        y_id <- do.call(rbind, lapply(y_dirs, read.table))
        
        features <- read.table(features_dir)
        names(x) <- features$V2
        
        is.cols <- grepl('mean()', features$V2) | grepl('std()', features$V2)
        x <- x[, is.cols]
        
        activities <- read.table(activity_labels_dir)
        x$activity <- merge(y_id, activities)$V2
        
        x %>%
                gather(cols, value, -activity) %>%
                separate(cols, c('feature', 'measurement', 'axis'))
}

res <- run_analysis()
write.table(res, './data.txt')