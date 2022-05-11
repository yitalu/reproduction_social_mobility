# This script analyze data produced by "./code/social_mobility_model.py"

rm(list = ls())
source("./code/read_data.R")




# Some Checks --------

# frequencies of optimal grwoth rate
table(optimal_growth_rates$V1)

# pdf(file = "./figures/frequency_growth_rate_no_fertility_bound.pdf", width = 6, height = 4.3)
hist(optimal_growth_rates$V1, breaks=50, xlab = "Optimal Growth Rate", main="Frequncy of Optimal Growth Rate", xlim = c(0, ceiling(max(optimal_growth_rates$V1))))
# dev.off()


# find the maximum optimal growth rate and its index
max(optimal_growth_rates)
which(optimal_growth_rates == max(optimal_growth_rates))


# find the allocation strategies with the maximum optimal growth rate
optimized_allocations <- optimal_allocations[which(optimal_growth_rates == max(optimal_growth_rates)),]


# find the fertilities with the maximum optimal growth rate
optimized_fertilities <- optimal_fertility[which(optimal_growth_rates == max(optimal_growth_rates)),]


# see if the maximum optimal growth rate gives unique vectors of allocation/fertility
nrow(unique(optimal_allocations))
nrow(unique(optimal_fertility))


# check optimal allocation/fertility with other values of optimal growth rate
# optimal_allocations[optimal_growth_rates == 0, ]
# optimal_fertility[optimal_growth_rates == 1, ]




# Some Plots --------

# parameters in plots
num_class <- ncol(optimal_allocations)
max_offspring <- 3
starvation_threshold <- 3
fertility_allocation <- 0:(num_class - 1)

fertility <- max_offspring * (1 - exp(-(fertility_allocation - starvation_threshold)))

fertility <- pmax(fertility, 0) # clip at 0


# plot optimized allocation
# pdf(file="./figures/optimized_allocation.pdf", width = 6, height = 4.3)
plot(fertility_allocation, fertility, type = "l", lty = 1, ylim = c(0, num_class + 2), main = "Fertility allocations in different wealth classes", xlab = "wealth class", ylab = "fertility allocation")

# points(fertility_allocation, fertility)

for (i in 1:nrow(optimized_fertilities)) {
  points(jitter(fertility_allocation, 1), optimized_allocations[i, ], pch=4, cex=0.5)
}
# dev.off()

# plot optimized fertility
# pdf(file="./figures/optimized_fertility.pdf", width = 6, height = 4.3)
plot(fertility_allocation, fertility, type="l", lty=1, ylim=c(0, max_offspring + 2), main="Fertility for different wealth class", xlab="wealth class", ylab="fertility")

# points(fertility_allocation, fertility)

for (i in 1:nrow(optimized_fertilities)) {
  points(jitter(fertility_allocation, 1), optimized_fertilities[i, ], pch=4, cex=0.5)
}
# dev.off()
