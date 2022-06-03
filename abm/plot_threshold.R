# this script visualize the relationship between starvation threshold and wealth/class # nolint

rm(list = ls())

# parameters
wealth <- seq(0, 14)
threshold_base <- 0

# a logarithmic function
threshold <- threshold_base + log(wealth + 1)

pdf(file = "./figures/class_dependent_living_cost.pdf")
plot(threshold ~ wealth, type = "l", ylim = c(0, 4), ylab = "Living Cost", xlab = "Wealth", main = "Class-Dependent Cost of Living")
points(threshold ~ wealth, pch = 19)
grid(col = "gray", lty = "dashed")
dev.off()
