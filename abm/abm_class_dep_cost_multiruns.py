# README ----


# IMPORT ----
from matplotlib import axis
import numpy as np
import functions_class_dep_cost as func
import matplotlib.pyplot as plt
import time as tm

start_time = tm.time()
current_time = tm.strftime("%Y/%m/%d %H:%M:%S", tm.localtime())
print('started at:', current_time)

# PARAMETERS ----
# basic parameters
num_run = 10
num_class = 15
num_ancestor = 100
# num_ancestor = num_class * 11
num_generation = 12
max_offspring = num_class
mutation_rate = 0.005
num_column = 11
# [0] inheritance; [1] income; [2] total wealth (class); [3] strategy (fertility ratio); [4] fertility investment; [5] bequests; [6] fertility; [7] ancestor's class; [8] parent's class; [9] generation; [10] run

# environmental parameters
starvation_threshold = 0
# survival_birth = 0.7
mean_income = 3



# MULTIPLE RUNS ----
for r in range(num_run):
    print("run", r)

    # DATA ARRAYS ----
    ancestors = np.zeros((num_ancestor, num_column))
    # [0] inheritance; [1] income; [2] total wealth (class); [3] strategy (fertility ratio); [4] fertility investment; [5] bequests; [6] fertility; [7] ancestor's class; [8] parent's class; [9] generation; [10] run



    # INITIALIZATION ----
    ancestors = func.initialize_population(ancestors, num_class)
    ancestors = func.choose_random_strategy(ancestors)
    ancestors = func.allocate_wealth(ancestors, max_offspring, starvation_threshold)
    ancestors[:, 7] = ancestors[:, 2] # ancestor tag



    # TIME LOOP ----
    parents = ancestors
    data = parents


    for t in range(num_generation):
        print("generation", t)

        # offspring becomes parents
        if t > 0:
            parents = offspring
            parents = func.allocate_wealth(parents, max_offspring, starvation_threshold)
            
            # record parent data
            data_new = parents
            # print("data", data)
            data = np.concatenate((data, data_new), axis=0)
            # print("data updated", data)
        
        # break the loop if no fertility
        fertility_total = sum(parents[:, 6])
        if fertility_total == 0 or t == num_generation - 1:
            print("fertility in population equals to", fertility_total)
            print("broke the loop at generation", t)
            break

        # create offspring array
        offspring = np.zeros((int(fertility_total), num_column))

        # offspring inherits strategies with mutation
        offspring[:, 3] = np.repeat(parents[:, 3], parents[:, 6].astype(int), axis=0)
        draw = np.random.uniform(0, 1, len(offspring))
        mutants = np.where(draw < mutation_rate)
        offspring[mutants, 3] = np.random.uniform(0, 1, len(mutants[0]))

        # offspring inherits bequests evenly
        bequest_even = parents[parents[:, 6] != 0, 5] // parents[parents[:, 6] != 0, 6]

        offspring[:, 0] = np.repeat(bequest_even, parents[parents[:, 6] != 0, 6].astype(int), axis=0)

        # some offspring gets the remainder
        bequest_remainder = parents[parents[:, 6] != 0, 5] % parents[parents[:, 6] != 0, 6]

        remainder = []
        for i in range(len(bequest_remainder)):

            remainder_by_family = [1] * int(bequest_remainder[i]) + [0] * int(parents[parents[:, 6] != 0, 6][i] - bequest_remainder[i])

            remainder = np.concatenate((remainder, remainder_by_family), axis=None)
        
        offspring[:, 0] = offspring[:, 0] + remainder

        # offspring earns their income
        offspring = func.earn_income(offspring, mean_income)
        offspring[:, 2] = offspring[:, 0] + offspring[:, 1]
        offspring[:, 2] = np.clip(offspring[:, 2], 0, num_class - 1)

        # record ancestor class
        offspring[:, 7] = np.repeat(parents[:, 7], parents[:, 6].astype(int), axis=0)
        
        # record parent class
        offspring[:, 8] = np.repeat(parents[:, 2], parents[:, 6].astype(int), axis=0)

        # record generation
        offspring[:, 9] = t + 1
    
    # record number of run
    data[:, 10] = r
    
    # record data for the run
    if r == 0:
        data_multi_run = data
    elif r > 0:
        data_multi_run = np.concatenate((data_multi_run, data), axis=0)




column_name = 'inheritance, income, wealth, strategy, fertility investment, bequests, fertility, ancestor class, parent class, generation, run'
np.savetxt('./data/data_cultural.csv', data_multi_run, delimiter=',', fmt='%.2f', header=column_name)

print("number of ancestors", num_ancestor)
print("number of last generation", len(offspring))

end_time = tm.time()
current_time = tm.strftime("%Y/%m/%d %H:%M:%S", tm.localtime())
print('run time in seconds:', "{0:.2f}".format(end_time - start_time))
print("time score", (end_time - start_time)*10000/len(offspring))
print('finished at:', current_time)