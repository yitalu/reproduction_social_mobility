# README ----
# This script calls the optimization algorithm and output data:
# 1) see "./code/social_mobility_optimization.py" and "./code/social_mobility_functions.py"
# 2) continue with "./code/analyze_data.R"
# Python version 3.9.6



# USAGE ----
# Choose desired parameters in the PARAMETERS section and run the script
# Data will be saved in the "data" folder under your project folder



# IMPORT ----
import numpy as np
import social_mobility_optimization as opt



# PARAMETERS ----
num_class = 15 # number of wealth categories
wealth = np.arange(num_class)
mean_earned_wealth = 3
starvation_threshold = 3
max_num_offspring = 3
num_search = 1000



# OPTIMIZATION ----
optimal_allocations, optimal_fertilities, optimal_leslie, optimal_growth_rates = opt.optimize(wealth, mean_earned_wealth, starvation_threshold, max_num_offspring, num_search)



# OUTPUT DATA ----
# save data to csv for R to analyze/visualize
# format: np.savetxt(filename, data, delimiter=',', fmt='%.2f', header = column_name, comments = '')
np.savetxt('./data/optimal_allocations.csv', optimal_allocations, delimiter=',', fmt='%.0f')
np.savetxt('./data/optimal_fertilities.csv', optimal_fertilities, delimiter=',', fmt='%.0f')

for i in range(num_search):
    np.savetxt(f'./data/optimal_leslie_{i}.csv', optimal_leslie[i], delimiter=',', fmt='%.0f')

np.savetxt('./data/optimal_growth_rates.csv', optimal_growth_rates, delimiter=',', fmt='%.3f')



# NOTE ----
# Data analysis continues in R: growth_rate_optimized, leslie_optimized, allocation_optimized