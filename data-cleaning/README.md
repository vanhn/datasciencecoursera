<h3>Import the library</h3>
The important libraries for this code

        library(data.table)
        library(dplyr)
        library(tidyr)
<h3>Create variables to save the paths to data</h3>
- **x_dirs** : the list contains the paths to **X** data

- **y_dirs** : the list contains the paths to **y** data

- **activity_labels_dir** : the path to **activity labels** data

- **features_dir** : the path to **features** data


        x_dirs <- list(xtrain = './UCI HAR Dataset/train/X_train.txt',
                       xtest = './UCI HAR Dataset/test/X_test.txt')
        
        y_dirs <- list(ytrain = './UCI HAR Dataset/train/y_train.txt',
                      ytest = './UCI HAR Dataset/test/y_test.txt')
        activity_labels_dir <- './UCI HAR Dataset/activity_labels.txt'
        features_dir <- './UCI HAR Dataset/features.txt'

<h3>Read data</h3>
1. Read X and y data
- Using **read\.table** to read table data from .txt file

- Using **lapply** to create a list that contains the list of table data

- Using **rbind** to concatenation list of table data to make one table data

        x <- do.call(rbind, lapply(x_dirs, read.table))
        y_id <- do.call(rbind, lapply(y_dirs, read.table))
        
2. Read features and activities

        features <- read.table(features_dir)
        activities <- read.table(activity_labels_dir)
        
3. Rename column names of **X** table follow by **feature names**

        names(x) <- features$V2
        
4. Extracts only the measurements on the mean and standard deviation for each measurement
        
        is.cols <- grepl('mean()', features$V2) | grepl('std()', features$V2)
        x <- x[, is.cols]
        
5. Make full data set by creating a new column named **activity**
        
        x$activity <- merge(y_id, activities)$V2
        
6. Create tidy data set
- First, melt data
- Second, separate data

        x %>%
                gather(cols, value, -activity) %>%
                separate(cols, c('feature', 'measurement', 'axis'))
                
**Note**: In R, we combine all components to a function called **run_analysis**
        
<h3> Save data to file </h3>
We save to 'data.txt' file

        res <- run_analysis()
        write.table(res, './data.txt')
