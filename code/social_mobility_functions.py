# This script provides functions needed in "./code/social_mobility_optimization.py"
from cv2 import eigen
import numpy as np
from numpy.random import beta


def generate_allocation(wealth):
    """generate a random strategy fulfilling the wealth constraint"""
    
    # fertility allocations made in a random manner but do not exceed wealth:
    fertility_allocation = np.random.randint(0, wealth[:] + 1, len(wealth))
    
    # test half-spending instead:
    # fertility_allocation = np.round(wealth * 0.5).astype(int)
    
    # print("fertility_allocation", fertility_allocation)
    return fertility_allocation




def investment_fertility(fertility_allocation, max_num_offspring, starvation_threshold):
    """transform fertility allocations to real fertilities, according to a law of diminishing return and starvation threshold"""

    # fertility as a diminishing return function of allocation
    max_fertility = max_num_offspring * (1 - np.exp(-(fertility_allocation - starvation_threshold)))

    # interger fertility
    max_fertility = np.round(max_fertility).astype(int)
    
    # fertilities do not exceed the upper bound
    max_fertility = np.clip(max_fertility, 0, max_num_offspring)

    # transform allocation to real fertilities
    fertility_realized = np.clip(fertility_allocation, 0, max_fertility)
    
    # print("fertility_realized", fertility_realized)
    return fertility_realized




def inherit_wealth(fertility_allocation, fertility_realized, wealth):
    """inherit wealth to offsprings as evenly as possible"""

    bequest = wealth - fertility_allocation
    wealth_inherited = [0] * len(wealth)

    # for parents from each wealth class
    for i in range(len(wealth)):

        wealth_inherited[i] = [0] * fertility_realized[i]

        # no offspring
        if fertility_realized[i] == 0:
            pass

        # with offspring(s)
        elif fertility_realized[i] > 0:

            # if bequests >= number of kids
            if bequest[i] >= fertility_realized[i]:
                
                # first inherit evenly
                wealth_inherited[i] = [bequest[i] // fertility_realized[i]] * fertility_realized[i]
                bequest[i] -= (bequest[i] // fertility_realized[i]) * fertility_realized[i]

                # then give away the remainder
                if bequest[i] > 0:
                    wealth_inherited[i][0:(bequest[i])] = [x+1 for x in wealth_inherited[i][0:(bequest[i])]]
                    bequest[i] -= bequest[i]
            
            # If bequests smaller than number of kids
            elif bequest[i] < fertility_realized[i]:
                
                # inherit to the first few kids
                wealth_inherited[i][0:(bequest[i])] = [x+1 for x in wealth_inherited[i][0:(bequest[i])]]
                bequest[i] -= bequest[i]

    # print("wealth_inherited", wealth_inherited)
    return wealth_inherited




def earn_wealth(wealth_inherited, mean_poisson, wealth):
    """(offsprings) add earned wealth to the inherited wealth, and then truncate so that the total wealth cannot exceed K-1 units of wealth"""

    wealth_total = wealth_inherited
    # print("wealth_inherited", wealth_inherited)
    
    # for offsprings from each wealth class
    for i in range(len(wealth_total)):
        
        # no offspring in the class
        if wealth_total[i] == []:
            pass
        
        # # with offspring(s) in the class
        elif wealth_total[i] != []:

            # Poisson earning process
            wealth_total[i] += np.random.poisson(lam=mean_poisson, size=len(wealth_total[i]))
            
            # earning proportional to wealth class; change the ratio as desired
            # ratio = 4
            # wealth_total[i] = [wealth_total[i][j] * ratio for j in range(len(wealth_total[i]))]
            
            # truncate total wealth
            wealth_total[i] = np.clip(wealth_total[i], 0, len(wealth) - 1)

    # print("wealth_total", wealth_total)
    return wealth_total




def generate_leslie(fertility_allocation, fertility_realized, wealth, mean_poisson):
    """generate Leslie matrix from the sum of the inherited and earned wealth"""
    
    leslie = np.zeros((len(wealth), len(wealth)))

    wealth_inherited = inherit_wealth(fertility_allocation, fertility_realized, wealth)
    wealth_total = earn_wealth(wealth_inherited, mean_poisson, wealth)

    # for parents' classes
    for j in range(len(wealth)):

        # no offspring
        if wealth_total[j] == []:
            pass
        
        # with offspring(s)
        else:
            
            # for offsprings' classes
            for i in range(len(wealth)):

                # number of offspring in each future class
                leslie[i, j] = np.sum(wealth_total[j] == i)
    
    # print("leslie", leslie)
    return leslie




def calculate_growth_rate(leslie):
    """calculate the growth rate of a leslie matrix and its corresponding class proportion (right eigenvector) and long-term fitness (left eigenvector)"""

    # find the eigenvalues and right eigenvectors
    # eigenvalues = np.linalg.eigvals(leslie)
    eigenvalues, eigenvectors_right = np.linalg.eig(leslie)
    # print("eigenvalues", eigenvalues)
    # print("eigenvectors", eigenvectors_right)

    # get the growth rate (eigenvalue with maximum magnitude)
    growth_rate = np.abs(eigenvalues).max()
    
    # get the class proportion corresponding to the growth rate
    index_max = np.abs(eigenvalues).argmax()
    class_proportion = eigenvectors_right[index_max]

    # get the dominant left eigenvector as long-term fitnesses
    leslie_transposed = leslie.transpose()
    # eigenvalues_left = np.linalg.eigvals(leslie_transposed) # order is different from previously defined eigenvalues
    eigenvalues_left, eigenvectors_left = np.linalg.eig(leslie_transposed)
    index_max = np.abs(eigenvalues_left).argmax()
    long_term_fitnesses = eigenvectors_left[index_max]

    # print("growth_rate", growth_rate)
    return growth_rate, class_proportion, long_term_fitnesses




def perturb_strategy(strategy_initial, wealth):
    """generate all possible perturbations of a fertility allocation/strategy"""

    num_wealth_categories = len(wealth)
    
    # prepare to record all possible "one-step" perturbations
    possible_perturbation = np.zeros((2 * num_wealth_categories, num_wealth_categories))
    possible_perturbation[:, 0:num_wealth_categories] = strategy_initial

    # for each element of the fertility strategy
    for i in range(num_wealth_categories):

        # two possible "one-step" perturbations
        possible_perturbation[i*2, i] -= 1
        possible_perturbation[i*2+1, i] += 1

        # limit the strategy to the meaningful ranges
        possible_perturbation[i*2, :] = np.clip(possible_perturbation[i*2, :], 0, wealth)

        possible_perturbation[i*2+1, :] = np.clip(possible_perturbation[i*2+1, :], 0, wealth)

        # convert all elements to integers
        possible_perturbation = possible_perturbation.astype(int)

    # keep only the unique perturbations
    possible_perturbation = np.unique(possible_perturbation, axis=0)

    # randomize the order
    np.random.shuffle(possible_perturbation)
    
    # print("possible perturbation", possible_perturbation)
    return possible_perturbation




# def mode_rows(a):
#     """find the most frequent row from an array"""
#     a = np.ascontiguousarray(a)
#     void_dt = np.dtype((np.void, a.dtype.itemsize * np.prod(a.shape[1:])))
#     _,ids, count = np.unique(a.view(void_dt).ravel(), \
#                                 return_index=1,return_counts=1)
#     largest_count_id = ids[count.argmax()]
#     most_frequent_row = a[largest_count_id]
#     return most_frequent_row