install.packages("data.table")
library(data.table)

flights <- fread("https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv")
colnames(flights)

# check dimension
dim(flights)

colnames(flights)

flights[flights$origin == "JFK" & flights$month == 6L,]$year

ans <- flights[origin == "JFK" & month == 6L, list(arr_delay)]
head(ans)
