# README ----


# USAGE ----


# IMPORT ----
import numpy as np
import abm_functions as func


# PARAMETERS ----
# basic parameters
num_class = 3
num_agent = num_class * 10
duration = 1
max_num_offspring = 15

# environmental variables
starvation_threshold = 3


# DATA ARRAYS ----
# 0: wealth; 1: class; 2: foresight; 
# [0] type; [1] foresight (how far agents look into future); [2] class; [3] wealth; [4] fertility allocation; [5] bequests; [6] fertility
population = np.zeros((num_agent, 7))
data_fertility = np.zeros((num_agent, duration + 1))


# INITIALIZATION ----

population = func.initialize_population(population, num_class)

population[:, 4] = population[:, 3] * np.random.uniform(0, 1, len(population))
population[:, 4] = np.random.randint(0, population[:, 3] + 1, len(population))
population[:, 5] = population[:, 3] - population[:, 4]
population[:, 6] = func.realize_fertility(population[:, 4], max_num_offspring, starvation_threshold)
print("population", population)

data_fertility[:, 0] = population[:, 6]


# TIME LOOP ----
for t in range(duration):

    # adjustment:



    # record fertility
    data_fertility[:, t + 1] = population[:, 6]
    

print("population", population)







# APPENDIX

# agent types: 
# 1. the farsighted and the myopic; 2. the fertility-maximizer vs the fitness maximizer

# questions:
# Now using absolute social classes, but how about relative social classes? (agents do not know their social classes; social classes depend on ranking)