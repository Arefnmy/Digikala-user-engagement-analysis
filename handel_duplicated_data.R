library(data.table)
library(readr)
df = read_csv("digikala-products.csv")
colnames(df)[1] <- "product_id"
nrow(df)

# some rows are totally duplicated
d = unique(df)

# view duplicated product_id's  is data
z = d[duplicated(d$product_id) | duplicated(d$product_id, fromLast = TRUE),]
z = z[order(z$product_id),]
View(z)

write.csv(z, 'duplicated-digikala.csv', fileEncoding = 'UTF-8', row.names = F)

# for each product_id, for each seller, pick one with highest rate_count
x <- d %>% arrange(desc(Rate_cnt)) %>% group_by(product_id, Seller) %>% slice(1) %>% ungroup()

write.csv(x, 'unique-digikala.csv', fileEncoding = 'UTF-8', row.names = F)