# README ----


# USAGE ----


# IMPORT ----
import numpy as np
import abm_functions as func
import matplotlib.pyplot as plt


# PARAMETERS ----
# basic parameters
num_class = 7
num_agent = num_class * 1
max_num_offspring = num_class
duration = 500
foresight = 10
step_adjustment = 0.1


# environmental variables
starvation_threshold = 2
mean_income = 3


# DATA ARRAYS ----
# [0] inheritance; [1] income; [2] total wealth (class); [3] strategy (fertility ratio); [4] fertility investment; [5] bequests; [6] fertility; [7] fitness
ancestors = np.zeros((num_agent, 8))
data_strategy = np.zeros((num_agent, duration))
data_investment = np.zeros((num_agent, duration))
data_fertility = np.zeros((num_agent, duration))
data_fitness = np.zeros((num_agent, duration))


# offspring = np.zeros(())
# parents = np.zeros((len(offspring), 4))


# INITIALIZATION ----
ancestors = func.initialize_population(ancestors, num_class)

data_strategy[:, 0] = ancestors[:, 3]
data_fertility[:, 0] = ancestors[:, 6]


# TIME ----
for t in range(duration):
    # ancestors adjust strategy
    if t == 0:
        ancestors = func.choose_random_strategy(ancestors)
    elif t == 1:
        random_row = np.random.randint(0, 2, num_agent)
        ancestors[random_row == 0, 3] += step_adjustment
        ancestors[random_row == 1, 3] -= step_adjustment
        ancestors[:, 3] = np.clip(ancestors[:, 3], 0, 1)
    elif t > 1:
        ancestors[:, 3] = func.adjust_strategy(data_fitness, data_strategy, step_adjustment, t)
    
    # ancestors allocate wealth and get fertility based on strategies
    ancestors = func.allocate_wealth(ancestors, max_num_offspring, starvation_threshold)
    print("ancestors fertilities", ancestors[:, 6])

    # ancestors foresee a long-term fitness
    ancestors[:, 7] = func.get_fitness(ancestors, foresight, max_num_offspring, starvation_threshold, mean_income)

    # print("ancestors fitness", ancestors[:, 7])
    
    # record fitness
    data_strategy[:, t] = ancestors[:, 3]
    data_investment[:, t] = ancestors[:, 4]
    data_fertility[:, t] = ancestors[:, 6]
    data_fitness[:, t] = ancestors[:, 7]

# print("data_strategy", data_strategy)
# print("data_fertility", data_fertility)
# print("data_fitness", data_fitness)


# PLOT
for i in range(num_agent):
    plt.plot(data_strategy[i, :], label=i)

plt.legend()
plt.show()


# OUTPUT
# np.savetxt('./data/data_fertility.csv', data_fertility, delimiter=',', fmt='%.0f')
# np.savetxt('./data/data_strategy.csv', data_strategy, delimiter=',', fmt='%.0f')
# np.savetxt('./data/data_fitness.csv', data_fitness, delimiter=',', fmt='%.0f')

np.savetxt('./developing/data_fertility.csv', data_fertility, delimiter=',', fmt='%.0f')
np.savetxt('./developing/data_strategy.csv', data_strategy, delimiter=',', fmt='%.0f')
np.savetxt('./developing/data_fitness.csv', data_fitness, delimiter=',', fmt='%.0f')




# APPENDIX

# agent types: 
# 1. the farsighted and the myopic; 2. the fertility-maximizer vs the fitness maximizer

# questions:
# Now using absolute social classes, but how about relative social classes? (agents do not know their social classes; social classes depend on ranking)