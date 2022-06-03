# README ----


# IMPORT ----
from matplotlib import axis
import numpy as np
import abm_functions as func
import matplotlib.pyplot as plt
import time as tm

start_time = tm.time()
current_time = tm.strftime("%Y/%m/%d %H:%M:%S", tm.localtime())
print('started at:', current_time)

# PARAMETERS ----
# basic
num_class = 15
num_ancestor = 100
# num_ancestor = num_class * 11
num_generation = 18
max_offspring = num_class
mutation_rate = 0.005
num_column = 8
# [0] inheritance; [1] income; [2] total wealth (class); [3] strategy (fertility ratio); [4] fertility investment; [5] bequests; [6] fertility; [7] ancestor's class


# environmental
# starvation_threshold = 3
survival_birth = 0.7
mean_income = 2


# DATA ARRAYS ----
ancestors = np.zeros((num_ancestor, num_column))
# data_parents = np.zeros((1, 2)) # [0] wealth; [1] srategy


# INITIALIZATION ----
ancestors = func.initialize_population(ancestors, num_class)
# ancestors[:, 2] = np.repeat(np.arange(0, num_class, 1), 11)
ancestors = func.choose_random_strategy(ancestors)
# ancestors[:, 3] = np.repeat([np.linspace(0, 1, 11)], num_class, axis=0).flatten()
ancestors = func.allocate_wealth(ancestors, max_offspring, survival_birth)
ancestors[:, 7] = ancestors[:, 2]
# print("ancestor", ancestors)
np.savetxt('./data/ancestors.csv', ancestors, delimiter=',', fmt='%.2f')


# TIME LOOP ----
# parents = ancestors
parents = ancestors[ancestors[:, 6] != 0, :]


one_per_row = np.repeat(parents, parents[:, 6].astype(int), axis=0)
data_parents = np.zeros((len(one_per_row), 3)) # [0] wealth; [1] srategy; [2] ancestor class
data_parents[:, 0:2] = one_per_row[:, 2:4]
data_parents[:, 2] = one_per_row[:, 7]
# print("data_parents", data_parents)


for t in range(num_generation):
    # print("this is generation", t)

    # offspring becomes parents, allocates wealth, and gives birth
    if t > 0:
        parents = offspring
        parents = func.allocate_wealth(parents, max_offspring, survival_birth)
    
    fertility_total = sum(parents[:, 6])
    
    if fertility_total == 0:
        print("fertility_total", fertility_total)
        print("loop broke at generation", t)
        break
    
    # offspring data array
    offspring = np.zeros((int(fertility_total), num_column))

    # division and remainder
    # division = np.zeros((sum(parents[:, 6] != 0), 4)) # [0] strategies of fertile parents [1] non-zero fertilities; [2] quotient; [3] remainder
    # division[:, 0] = parents[parents[:, 6] != 0, 3]
    # division[:, 1] = parents[parents[:, 6] != 0, 6]
    # division[:, 2] = parents[parents[:, 6] != 0, 5] // parents[parents[:, 6] != 0, 6] # bequest / kid numbers
    # division[:, 3] = parents[parents[:, 6] != 0, 5] % parents[parents[:, 6] != 0, 6]
    # # print("division", division)

    strategies = []
    inheritance = []
    ancestor_class = []
    # for i in range(len(division)):
    #     strategies = np.concatenate((strategies, np.repeat(division[i, 0], division[i, 1])), axis=None)

    #     equal_divide = np.repeat(division[i, 2], division[i, 1])
    #     remainder = [1] * int(division[i, 3]) + [0] * int(division[i, 1] - division[i, 3])
    #     # inheritance = equal_divide + remainder

    #     inheritance = np.concatenate((inheritance, equal_divide + remainder), axis=None)

    # print("len(strategies)", len(strategies))
    # print("len(inheritance)", len(inheritance))
    # print("strategies", strategies)
    # print("inheritance", inheritance)
    
    for i in range(len(parents)):

        if parents[i, 6] != 0:
            strategies += [parents[i, 3]] * int(parents[i, 6])
            # print("[parents[i, 3]] * parents[i, 6]", [parents[i, 3]] * int(parents[i, 6]), i)

            wealth_inherited = [parents[i, 5] // parents[i, 6]] * int(parents[i, 6])
            # print("wealth_inherited", wealth_inherited)

            remainder = int(parents[i, 5] % parents[i, 6])
            # print("remainder", remainder)

            if remainder != 0:
                for i in range(remainder):
                    wealth_inherited[i] += 1
            # print("wealth_inherited", wealth_inherited)

            inheritance += wealth_inherited

            ancestor_class = np.repeat(parents[:, 7], parents[:, 6].astype(int), axis=0)

    # print("strategies", strategies)
    # print("inheritance", inheritance)

    # mutation
    draw = np.random.uniform(0, 1, len(strategies))
    # print("draw", draw)
    mutants = np.where(draw < mutation_rate)
    # print("mutants", mutants[0])
    # print("len(mutants)", len(mutants[0]))
    
    offspring[:, 3] = strategies
    # print("offspring[:, 3]", offspring[:, 3])
    offspring[mutants, 3] = np.random.uniform(0, 1, len(mutants[0]))
    # print("offspring[:, 3]", offspring[:, 3])
    offspring[:, 0] = inheritance
    offspring = func.earn_income(offspring, mean_income)
    offspring[:, 2] = offspring[:, 0] + offspring[:, 1]
    offspring[:, 2] = np.clip(offspring[:, 2], 0, num_class - 1)
    offspring[:, 7] = ancestor_class


    # record parent data (who are giving birth)
    if t > 0:
        one_per_row = np.repeat(parents, parents[:, 6].astype(int), axis=0)
        data_parents_new = np.zeros((len(one_per_row), 3))
        data_parents_new[:, 0:2] = one_per_row[:, 2:4]
        data_parents_new[:, 2] = one_per_row[:, 7]
        data_parents = np.concatenate((data_parents, data_parents_new), axis=0)
        # print("data_parents", data_parents)

np.savetxt('./data/data_parents_new.csv', data_parents_new, delimiter=',', fmt='%.2f')
np.savetxt('./data/data_parents.csv', data_parents, delimiter=',', fmt='%.2f')


print("number of ancestors", num_ancestor)
print("number of last generation", len(offspring))

end_time = tm.time()
current_time = tm.strftime("%Y/%m/%d %H:%M:%S", tm.localtime())
print('run time in seconds:', "{0:.2f}".format(end_time - start_time))
print("time score", (end_time - start_time)*10000/len(offspring))
print('finished at:', current_time)


# VISUALIZATION ----

x = ancestors[:, 3]

# the histogram of the data
n, bins, patches = plt.hist(x, 100, density=True, facecolor='g', alpha=1)


counts = np.histogram(x)
print("counts", counts[0])
print(np.argmax(counts[0]))

plt.xlabel('Strategy')
plt.ylabel('Frequency')
plt.title('Histogram of Fertility Strategy')
plt.text(0.2, .025, r'$\mu=100,\ \sigma=15$')
plt.xlim(-0.1, 1.1)
plt.ylim(0, 10)
# plt.ylim(0, np.argmax(counts[0]) + 1)
plt.grid(True)
plt.show()



x = ancestors[:, 2]

# the histogram of the data
n, bins, patches = plt.hist(x, 100, density=True, facecolor='g', alpha=1)


# counts = np.histogram(x)
# print("counts", counts)
# print(np.argmax(counts))

plt.xlabel('Wealth')
plt.ylabel('Frequency')
plt.title('Histogram of Wealth')
plt.text(0.2, .025, r'$\mu=100,\ \sigma=15$')
plt.xlim(-0.1, num_class + 0.1)
plt.ylim(0, 5)
# plt.ylim(0, np.argmax(counts) + 1)
plt.grid(True)
plt.show()




x = offspring[:, 3]

# the histogram of the data
n, bins, patches = plt.hist(x, 100, density=True, facecolor='r', alpha=1)


# counts = np.histogram(x)
# print("counts", counts)
# print(np.argmax(counts))

plt.xlabel('Strategy')
plt.ylabel('Frequency')
plt.title('Histogram of Fertility Strategy')
plt.text(0.2, .025, r'$\mu=100,\ \sigma=15$')
plt.xlim(-0.1, 1.1)
plt.ylim(0, 80)
# plt.ylim(0, np.argmax(counts) + 1)
plt.grid(True)
plt.show()




x = offspring[:, 2]

# the histogram of the data
n, bins, patches = plt.hist(x, 100, density=True, facecolor='g', alpha=1)


# counts = np.histogram(x)
# print("counts", counts)
# print(np.argmax(counts))

plt.xlabel('Wealth')
plt.ylabel('Frequency')
plt.title('Histogram of Wealth')
plt.text(0.2, .025, r'$\mu=100,\ \sigma=15$')
plt.xlim(-0.1, num_class + 0.1)
plt.ylim(0, 5)
# plt.ylim(0, np.argmax(counts) + 1)
plt.grid(True)
plt.show()