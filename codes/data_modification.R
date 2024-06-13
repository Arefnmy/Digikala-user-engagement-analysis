#####################################################


# Set the file paths to your CSV files
file_path_comments <- "/Users/nimaazar/Desktop/Regression & Data Anaysis/Project No.2/Digikala (comments & products)_@DataPlusScience/digikala-comments.csv"
file_path_products <- "/Users/nimaazar/Desktop/Regression & Data Anaysis/Project No.2/Digikala (comments & products)_@DataPlusScience/digikala-products.csv"
file_path_comments_modified <- "/Users/nimaazar/Desktop/Regression & Data Anaysis/Project No.2/Digikala (comments & products)_@DataPlusScience/modified/new_digikala_comments.csv"

# Read the CSV files into data frames
comments <- read.csv(file_path_comments)
products_data <- read.csv(file_path_products)
comments_modified_data <- read.csv(file_path_comments_modified)

# Delete data frame
rm(piece20)


#####################################################


# Get the column names
headers <- names(products_data)

# Print the column names
print(headers)


#####################################################


# Function to count items in the advantages and disadvantages columns
count_items <- function(x) {
  # Handle NA or "nan" values
  if (is.na(x) || x == "nan") return(0)
  # Remove leading and trailing square brackets and split the string by comma
  items <- strsplit(gsub("\\[|\\]", "", x), ",\\s*")[[1]]
  # Return the count of items
  length(items)
}


# Apply the function to the advantages and disadvantages columns
new_comments<- new_comments %>%
  mutate(
    advantages_count = sapply(advantages, count_items),
    disadvantages_count = sapply(disadvantages, count_items)
  )

# Drop the original advantages and disadvantages columns (if desired)
new_comments <- new_comments %>%
  select(-advantages, -disadvantages)


#####################################################


# Saving data frame as a CSV file
write.csv(sample, "sample.csv", row.names = FALSE)


#####################################################


# Function to count words in a string
count_words <- function(text) {
  # Split the text by spaces and count the number of elements
  str_count <- length(unlist(strsplit(text, "\\s+")))
  return(str_count)
}

# Apply the function to the body column and replace the original text with the word count
new_comments <- new_comments %>%
  mutate(body = sapply(body, count_words))


#####################################################


# Replace the values in the recommendation_status column
new_comments <- new_comments %>%
  mutate(recommendation_status = case_when(
    recommendation_status %in% c("recommended", "not_recommended") ~ 1,
    recommendation_status == "no_idea" ~ 0.5,
    TRUE ~ 0
  ))


#####################################################


# Replace the values in the title column
new_comments <- new_comments %>%
  mutate(title = ifelse(is.na(title) | title == "nan" | title == "", 0, 1))


#####################################################


# Replace "nan" with 0 and other values with 1 in 'true_to_size_rate' column
new_comments <- new_comments %>%
  mutate(true_to_size_rate = ifelse(true_to_size_rate == "nan", 0, 1))


#####################################################

# Select the first 500 rows using the head function
first_500_rows <- head(comments, 500)

# Filter rows where rate is 0 or 3
filtered_comments <- comments %>%
  filter(rate == 0 | rate == 3)

#####################################################


# Number of pieces to divide into
num_pieces <- 20

# Create an index to split the data frame
split_index <- cut(1:nrow(filtered_comments), breaks = num_pieces, labels = FALSE)

# Split the data frame into a list of smaller data frames
split_dataframes <- split(filtered_comments, split_index)

# Access the first smaller data frame
piece1 <- split_dataframes[[1]]

piece2 <- split_dataframes[[2]]

piece3 <- split_dataframes[[3]]

piece4 <- split_dataframes[[4]]

piece5 <- split_dataframes[[5]]

piece6 <- split_dataframes[[6]]

piece7 <- split_dataframes[[7]]

piece8 <- split_dataframes[[8]]

piece9 <- split_dataframes[[9]]

piece10 <- split_dataframes[[10]]

piece11 <- split_dataframes[[11]]

piece12 <- split_dataframes[[12]]

piece13 <- split_dataframes[[13]]

piece14 <- split_dataframes[[14]]

piece15 <- split_dataframes[[15]]

piece16 <- split_dataframes[[16]]

piece17 <- split_dataframes[[17]]

piece18 <- split_dataframes[[18]]

piece19 <- split_dataframes[[19]]

piece20 <- split_dataframes[[20]]


#####################################################


# Set the seed for reproducibility (optional)
set.seed(123)

# Calculate the sample size
sample_size <- ceiling(nrow(filtered_comments) / 20)

# Take a random sample without replacement
sample <- filtered_comments[sample(nrow(filtered_comments), sample_size), ]


#####################################################
