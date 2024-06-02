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

# Function to count words in a string
count_words <- function(text) {
  # Split the text by spaces and count the number of elements
  str_count <- length(unlist(strsplit(text, "\\s+")))
  return(str_count)
}

# Apply the function to the body column and
# replace the original text with the word count
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