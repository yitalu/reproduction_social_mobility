# This script tests Leslie transformation in two different ways: 1) by doing matrix multiplication manually, and 2) by calculating eigenvalues and eigenvectors. Results from the two should converge after a certain period.

rm(list = ls())
library(ggplot2)


# Import Functions ----
source("./code/leslie_matrix_functions.R")




# Parameters ----
num_class <- 3
generation <- 10

# enter a leslie to be tested; fulfill the format
leslie <- matrix(c(0, 0, 0, 3, 2, 1, 0, 3, 2), nrow = 3)
# leslie <- matrix(c(0.9, 0.1, 0, 2, 0.9, 0.1, 0, 1, 1), nrow = 3)
# leslie <- matrix(sample(0:3, size = num_class * num_class, replace = TRUE), nrow = num_class)

# start with even distribution
population_initial <- rep(x = 1, num_class)




# Data Array ----
population_data <- matrix(rep(0, generation * (num_class + 1)), ncol = num_class + 1)
population_data[1, 1:num_class] <- population_initial




# Matrix Multiplication ----
# Generate population over time by matrix multiplication
for (i in 2:generation) {
   population_data[i, 1:num_class] <- transform_population(leslie, population_data[i - 1, 1:num_class])
}
population_data[, num_class + 1] <- rowSums(population_data[, 1:num_class])
population_total <- population_data[, num_class + 1]




# Plot Population Over Time ----
# Uncomment any of these lines if you want to save the figures:
# png(file="./figures/population_over_time.png", width = 1200, height = 800, res = 180)
# pdf(file="./figures/population_over_time.pdf", width = 6, height = 4.3)
# tiff(file="./figures/population_over_time.tiff", width = 2400, height = 1600, res = 300)

plot(population_data[, num_class + 1], type = "l", lty = "solid", lwd = 1, xlab = "Time", ylab = "Population", main = "Population over time")

for (i in 1:num_class) {
   lines(population_data[, i], type = "l", lty = i + 1)
}

# adjust the legend position according your x y ranges
legend(1, 4.5e5, legend = c("Total", "Lower Class", "Middle Class", "Upper Class"), lty = 1:4, lwd = c(1, 1, 1, 1), cex = 0.8)

# dev.off()




# Growth Rate ----
# The growth rates for each class and the total population will converge to the eigenvalue of the Leslie matrix after a certain period of time

growth_rate_eigenvalue <- max(Re(eigen(leslie)$values[Im(eigen(leslie)$values) == 0])) # Since sometimes eigenvalues can be complex, we only look for "real" eigenvalues and take the maximum
growth_rate_instant <- matrix(rep(0, (generation - 1) * (num_class + 1)), ncol = num_class + 1)

# calculate the "instant" growth rate between two adjacent time points 
for (t in 1:(generation - 1)) {
  growth_rate_instant[t, ] <- population_data[t + 1, ] / population_data[t, ]
}

# plot growth rate over time
# png(file="./figures/growth_rate_over_time.png", width = 1200, height = 800, res = 180)
# pdf(file="./figures/growth_rate_over_time.pdf", width = 6, height = 4.3)
# tiff(file="./figures/growth_rate_over_time.tiff", width = 2400, height = 1600, res = 300)
# plot(growth_rate_instant[, num_class + 1], type = "l", lty="solid", lwd=1, xlab = "Time", ylab = "Growth Rate", main = "Growth Rate over Time", ylim = c(3, 5.5))
plot(growth_rate_instant[, num_class + 1], type = "l", lty="solid", lwd=1, xlab = "Time", ylab = "Growth Rate", main = "Growth Rate over Time", ylim = c(2, 6))

# lines(growth_rate_instant[, 1], type="l", lty="dashed")
# lines(growth_rate_instant[, 2], type="l", lty="dotted")
# lines(growth_rate_instant[, 3], type="l", lty="dotdash")
for (i in 1:num_class) {
  lines(growth_rate_instant[, i], type = "l", lty = i)
}

abline(h = growth_rate_eigenvalue, lty = 2, col="red")
legend(6.5, 6, legend = c("Total", "Lower Class", "Middle Class", "Upper Class", "Eigenvalue"), lty = c(1:4, 2), lwd = c(1, 1, 1, 1, 1), col = c(rep("black", 4), "red"), cex = 0.8)
# dev.off()




# Age Class Proportions and Eigenvector -----------------------------------
# The proportions of age classes in the population should converge to the dominant (regular/right) eigenvector
proportion_eigenvector <- Re(eigen(leslie)$vectors[, Re(eigen(leslie)$values) == growth_rate_eigenvalue]) # again, take the real part of the numbers
proportion_eigenvector <- normalize_distribution(proportion_eigenvector)


proportion_instant <- matrix(rep(0, generation * num_class), ncol = num_class)
proportion_instant <- t(apply(X = population_data[, 1:num_class], MARGIN = 1, FUN = normalize_distribution))


# stacked area chart
time <- rep(c(1:generation), each = num_class)
value <- as.vector(t(proportion_instant))
group <- rep(c("Lower Class", "Middle Class", "Upper Class"), times = generation)
group <- rep(as.character(c(1:num_class)), times = generation)
data <- data.frame(time, value, group)

# png(file="./figures/proportion_over_time.png", width = 1200, height = 800, res = 180)
# pdf(file="./figures/proportion_over_time.pdf", width = 6, height = 4.3)
# tiff(file="./figures/proportion_over_time.tiff", width = 2400, height = 1600, res = 300)
ggplot(data, aes(x = time, y = value, fill = group)) + 
  geom_area(alpha = 0.6) + 
  geom_hline(yintercept = c(proportion_eigenvector[3], (1-proportion_eigenvector[1])), col = c("black", "black"), lty = c(2, 2), lwd = c(0.3, 0.3)) + 
  ggtitle("Proportion over Time") + 
  labs(title = "Age Class Proportions over Time", x = "Time", y = "Proportion") + 
  theme(plot.title = element_text(hjust = 0.5))

# dev.off()




# Long-Term Fitness and Left Eigenvalue -----------------------------------
# The proportion of long-term fitness for each class in the population should converge to the dominant left eigenvector
leslie_transposed <- t(leslie)
eigen(leslie_transposed)
fitness_eigenvector <- eigen(leslie_transposed)$vectors[, which.max(eigen(leslie_transposed)$values)]
fitness_eigenvector_normalized <- normalize_distribution(fitness_eigenvector)

fitness <- matrix(rep(0, generation * ncol(leslie)), ncol = ncol(leslie))

for (i_class in 1:ncol(leslie)) {
  descendant <- matrix(rep(0, generation * ncol(leslie)), ncol = ncol(leslie))
  descendant[1, i_class] <- 1
  for (g in 2:generation) {
    for (j_class in 1:ncol(leslie)) {
      descendant[g, j_class] <- sum(descendant[g-1, 1:num_class] * leslie[j_class, ])
    }
  }
  # print(descendant)
  fitness[, i_class] <- rowSums(descendant)
}


fitness_proportion <- t(apply(fitness, MARGIN = 1, FUN = normalize_distribution))



# stacked area chart
time <- rep(c(1:generation), each = num_class)
value <- as.vector(t(fitness_proportion))
group <- rep(c("Lower Class", "Middle Class", "Upper Class"), times = generation)
group <- rep(as.character(c(1:num_class)), times = generation)
data <- data.frame(time, value, group)

# png(file="./figures/fitness_over_time.png", width = 1200, height = 800, res = 180)
# pdf(file="./figures/fitness_over_time.pdf", width = 6, height = 4.3)
# tiff(file="./figures/fitness_over_time.tiff", width = 2400, height = 1600, res = 300)
ggplot(data, aes(x = time, y = value, fill = group)) + 
  geom_area(alpha = 0.6) + 
  geom_hline(yintercept = c(fitness_eigenvector_normalized[3], (1 - fitness_eigenvector_normalized[1])), col = c("black", "black"), lty = c(2, 2), lwd = c(0.3, 0.3)) + 
  labs(title = "Fitnesses over Time", x = "Time", y = "Fitness in Proportion") + 
  theme(plot.title = element_text(hjust = 0.5))
# dev.off()


# growth rates of fitness
growth_rate_fitness <- matrix(rep(0, (generation - 1) * num_class), ncol = num_class)

for (t in 1:(generation-1)){
  growth_rate_fitness[t, ] <- fitness[t+1, ] / fitness[t, ]
}