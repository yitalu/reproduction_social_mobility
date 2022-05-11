# This script optimizes growth rate with respect to fertility allocation
# Calls functions in "./code/social_mobility_functions.py"

import numpy as np
import social_mobility_functions as func


def optimize(wealth, mean_earned_wealth, starvation_threshold, max_num_offspring, num_search):

    # DATA ARRAY
    # to record allocations, fertilities, leslie, and growth rates
    optimal_allocations = np.zeros((num_search, len(wealth))).astype(int)
    optimal_fertilities = np.zeros((num_search, len(wealth))).astype(int)
    optimal_leslie = dict()
    optimal_growth_rates = np.zeros((num_search, 1))


    for i in range(num_search):
        
        # initial allocation, fertility, leslie, and growth rate
        allocation_initial = func.generate_allocation(wealth)
        fertility_initial =func.investment_fertility(allocation_initial, max_num_offspring, starvation_threshold)
        leslie_initial = func.generate_leslie(allocation_initial, fertility_initial, wealth, mean_earned_wealth)
        growth_rate_initial = func.calculate_growth_rate(leslie_initial)[0]
        
        # record initial data
        optimal_allocations[i, 0:len(wealth)] = allocation_initial
        optimal_fertilities[i, 0:len(wealth)] = fertility_initial
        optimal_leslie[i] = leslie_initial
        optimal_growth_rates[i, 0] = growth_rate_initial
        
        # generate (possible but unique) perturbations
        perturbation_unique = func.perturb_strategy(allocation_initial, wealth)


        # start the searching algorithm
        j = 0
        while j in range(len(perturbation_unique)):

            # test a set of perturbations
            allocation_perturbed = perturbation_unique[j, :]
            fertility_perturbed = func.investment_fertility(allocation_perturbed, max_num_offspring, starvation_threshold)
            leslie_perturbed = func.generate_leslie(allocation_perturbed, fertility_perturbed, wealth, mean_earned_wealth)
            growth_rate_perturbed = func.calculate_growth_rate(leslie_perturbed)[0]


            # replace the recorded with the perturbed if growth rate is improved
            while growth_rate_perturbed > growth_rate_initial:
                allocation_initial, fertility_initial, leslie_initial, growth_rate_initial = allocation_perturbed, fertility_perturbed, leslie_perturbed, growth_rate_perturbed

                optimal_allocations[i, 0:len(wealth)] = allocation_initial
                optimal_fertilities[i, 0:len(wealth)] = fertility_initial
                optimal_leslie[i] = leslie_initial
                optimal_growth_rates[i, 0] = growth_rate_initial

                # generate (possible but unique) perturbations
                perturbation_unique = func.perturb_strategy(allocation_initial, wealth)

                # restart count of perturbations
                j = 0

            # try the next set of perturbation if growth rate is not improved
            else:
                j = j + 1

    return optimal_allocations, optimal_fertilities, optimal_leslie, optimal_growth_rates