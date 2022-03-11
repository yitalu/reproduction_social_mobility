# This script reads CSV files produced by "./code/social_mobility_model.py" for analysis in "./code/analyze_data.R"

rm(list = ls())




# READ CSV ----
list.files('./data/')

optimal_allocations <- read.csv("./data/optimal_allocations.csv", header = FALSE)
optimal_fertility <- read.csv("./data/optimal_fertilities.csv", header = FALSE)
optimal_growth_rates <- read.csv("./data/optimal_growth_rates.csv", header = FALSE)




# NAME VARIABLES ----
num_search <- nrow(optimal_growth_rates)

variables <- paste("optimal_leslie_", 1:num_search, sep = "")
filenames <- sprintf("./data/optimal_leslie_%d.csv", 0:(num_search - 1))

for (i in 1:num_search) {
  assign(variables[i], read.csv(filenames[i], header = FALSE))
}