# this script plots fertility as a function of fertility allocation, based on a law of diminishing returns (see Rogers 1990 p.483 and Figure 1)

rm(list = ls())

num_class <- 15
max_offspring <- 3
starvation_threshold <- 3
fertility_allocation <- 0:(num_class - 1)

fertility <- max_offspring * (1 - exp(-(fertility_allocation - starvation_threshold)))

fertility <- pmax(fertility, 0) # clip at 0

plot(fertility_allocation, fertility, type = "l", lty = 3, ylim = c(0, max_offspring + 2), main = "Fertility vs Allocation", xlab = "Invested Wealth", ylab = "Fertility")
points(fertility_allocation, fertility, pch = 19)
grid(col = "gray", lty = "dotted")