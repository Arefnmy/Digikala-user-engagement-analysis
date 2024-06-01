# Function to count items in the advantages and disadvantages columns
count_items <- function(x) {
  # Remove leading and trailing square brackets and split the string by comma
  items <- strsplit(gsub("\\[|\\]", "", x), ",\\s*")[[1]]
  # Return the count of items
  length(items)
}

# Apply the function to the advantages and disadvantages columns
comments_modified_data <- comments_modified_data %>%
  mutate(
    advantages_count = sapply(advantages, count_items),
    disadvantages_count = sapply(disadvantages, count_items)
  )

# Drop the original advantages and disadvantages columns (if desired)
comments_modified_data <- comments_modified_data %>%
  select(-advantages, -disadvantages)


#####################################################