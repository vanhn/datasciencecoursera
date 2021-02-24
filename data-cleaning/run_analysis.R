library(data.table)
library(dplyr)
library(tidyr)

x_dirs <- list(xtrain = './UCI HAR Dataset/train/X_train.txt',
               xtest = './UCI HAR Dataset/test/X_test.txt')

y_dirs <- list(ytrain = './UCI HAR Dataset/train/y_train.txt',
               ytest = './UCI HAR Dataset/test/y_test.txt')
activity_labels_dir <- './UCI HAR Dataset/activity_labels.txt'
features_dir <- './UCI HAR Dataset/features.txt'

features <- read.table(features_dir)
activities <- read.table(activity_labels_dir)

x <- do.call(rbind, lapply(x_dirs, read.table))
y <- do.call(rbind, lapply(y_dirs, read.table))

names(x) <- features$V2

is.cols <- grepl('mean()', features$V2) | grepl('std()', features$V2)
x <- x[, is.cols]

x$activity_id <- y$V1

x <- x %>%
        gather(cols, value,-activity_id) %>%
        separate(cols, c('feature', 'variable', 'axis'))

measurements <- x %>%
        select(activity_id, feature, variable, axis) %>%
        unique()
measurements <- mutate(measurements, measurement_id=seq(1:dim(measurements)[1]))


values <- measurements %>%
        merge(x) %>%
        select(measurement_id, value)

save_dir <- './my_data'
if(!dir.exists(save_dir)){dir.create(save_dir)}
write.table(activities, sprintf('%s\\activities.txt', save_dir), row.names = FALSE, col.names = FALSE)
write.table(measurements, sprintf('%s/measurements.txt', save_dir), row.names = FALSE, col.names = FALSE)
write.table(values, sprintf('%s/values.txt', save_dir), row.names = FALSE, col.names = FALSE)