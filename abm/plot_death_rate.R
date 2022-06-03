# this script visualize the relationship between death rate and fertility allocation # nolint

rm(list = ls())

# parameters
max_num_offspring <- 15
fertility_allocation <- seq(0, 14)
survival_birth <- 0.9
death_birth <- 1 - survival_birth

# option 1: death rate as a linear function of fertility allocation
# death_rate <- (1 - survival_birth) + survival_birth * fertility_allocation / max_num_offspring # nolintr

# option 2: death rate as a concave function of fertility allocation
death_rate <- 1 - survival_birth ^ fertility_allocation

# plot the relationship
pdf(file = "./figures/density_dependent_death.pdf")
plot(death_rate ~ fertility_allocation, type = "l", xlab = "Fertility Allocation", ylab = "Death Rate", main = "Density-Dependent Death Rate")
points(death_rate ~ fertility_allocation, pch = 19)
grid(col = "gray", lty = "dotted")
dev.off()

# compare effects of different survival rates
# survival_birth <- seq(0, 1, 0.1)
# for (s in survival_birth) {
#    death_rate <- 1 - s ^ fertility_allocation
#    lines(death_rate ~ fertility_allocation, lty = s * 10)
# }