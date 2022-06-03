rm(list = ls())
# install.packages("hexbin")
library(data.table)
# library(lattice)
# library(ggplot2)
# library(hexbin)
# library(RColorBrewer)




# Read Data ---------------------------------------------------------------
# d <- read.csv("./data/data.csv")
d <- fread("./data/data.csv")
colnames(d)[1] <- "inheritance"




# Growth of Population ----------------------------------------------------
tiff(file="./figures/population_growth.tiff", width = 2000, height = 1600, res = 300)
population_grwoth <- d[, .(.N), by = generation]
pdf(file = "./figures/population_growth_death.pdf")
plot(population_grwoth, type = "l", main = "Population Growth", xlab = "Generation", ylab = "Population Size")
grid(col = "gray", lty = "dotted")
dev.off()

# generation <- 0:tail(d$generation, 1)
# population_size <- rep(0, length(generation))
# 
# for (i in generation) {
#   population_size[i+1] <- nrow(d[generation == i, ])
# }
# 
# plot(generation, population_size, type = "l", main = "Population Growth", xlab = "Generation", ylab = "Population Size")
# 
# table(d$generation)
# plot(table(d$generation))




# Wealth and Strategy Distribution ----------------------------------------
tiff(file="./figures/wealth_distribution_ancestor.tiff", width = 2000, height = 1600, res = 300)
pdf(file = "./figures/wealth_distribution_ancestor_death.pdf")
hist(d[generation == 0, wealth], breaks = 100, main = "Distribution of Wealth (Ancestors)", xlab = "Wealth") # ancestor
grid(col = "gray", lty = "dotted")
dev.off()

tiff(file="./figures/wealth_distribution_last_gen.tiff", width = 2000, height = 1600, res = 300)
pdf(file = "./figures/wealth_distribution_last_gen_death.pdf")
hist(d[generation == tail(d$generation, 1), wealth], breaks = 100, main = "Distribution of Wealth (Last Generation)", xlab = "Wealth") # last generation
grid(col = "gray", lty = "dotted")
dev.off()

tiff(file="./figures/strategy_distribution_ancestor.tiff", width = 2000, height = 1600, res = 300)
pdf(file = "./figures/strategy_distribution_ancestor_death.pdf")
hist(d[generation == 0, strategy], breaks = 100, main = "Distribution of Strategies (Ancestors)", xlab = "Strategy") # ancestor
grid(col = "gray", lty = "dotted")
dev.off()

tiff(file="./figures/strategy_distribution_last_gen.tiff", width = 2000, height = 1600, res = 300)
pdf(file = "./figures/strategy_distribution_last_gen_death.pdf")
hist(d[generation == tail(d$generation, 1), strategy], breaks = 100, main = "Distribution of Strategies (Last Generation)", xlab = "Strategy") # last generation
grid(col = "gray", lty = "dotted")
dev.off()

tiff(file="./figures/fertility_distribution_ancestor.tiff", width = 2000, height = 1600, res = 300)
pdf(file = "./figures/fertility_distribution_ancestor_death.pdf")
hist(d[generation == 0, fertility], breaks = 100, main = "Fertilities of Ancestors", xlab = "Fertility") # ancestor
grid(col = "gray", lty = "dotted")
dev.off()

tiff(file="./figures/fertility_distribution_last_gen.tiff", width = 2000, height = 1600, res = 300)
pdf(file = "./figures/fertility_distribution_last_gen_death.pdf")
hist(d[generation == tail(d$generation, 1), fertility], breaks = 100, main = "Fertilities of the Last Generation", xlab = "Fertility") # last generation
grid(col = "gray", lty = "dotted")
dev.off()




# Average Strategy Over Generation ----------------------------------------
tiff(file="./figures/strategy_over_generation.tiff", width = 2000, height = 1600, res = 300)
pdf(file = "./figures/strategy_over_generation_death.pdf")
plot(d[, mean(strategy), by = generation], type = "l", main = "Average Strategy Over Generation", xlab = "Generation", ylab = "Average Strategy")
grid(col = "gray", lty = "dotted")
dev.off()




# Average Fertility Over Generation ---------------------------------------
tiff(file="./figures/fertility_over_generation.tiff", width = 2000, height = 1600, res = 300)
pdf(file = "./figures/fertility_over_generation_death.pdf")
plot(d[, mean(fertility), by = generation], type = "l", main = "Average Fertility Over Generation", xlab = "Generation", ylab = "Average Fertility")
grid(col = "gray", lty = "dotted")
dev.off()

# fertility_over_generation <- rep(0, max(d$generation) + 1)
# for (i in 0:max(d$generation)) {
#   fertility_over_generation[i+1] <- d[generation == i, mean(fertility)]
# }
# plot(fertility_over_generation, type = "l", main = "Average Fertility over Generation", xlab = "Generation", ylab = "Average Fertility")




# Average Wealth Over Generation ------------------------------------------
tiff(file="./figures/wealth_over_generation.tiff", width = 2000, height = 1600, res = 300)
pdf(file = "./figures/wealth_over_generation_death.pdf")
plot(d[, mean(wealth), by = generation], type = "l", main = "Average Wealth Over Generation", xlab = "Generation", ylab = "Average Wealth")
grid(col = "gray", lty = "dotted")
dev.off()





# Average Fertility for Different Wealth ----------------------------------
tiff(file="./figures/fertility_by_wealth.tiff", width = 2000, height = 1600, res = 300)
pdf(file = "./figures/fertility_by_wealth_death.pdf")
plot(d[, mean(fertility), by = wealth], pch = 19, main = "Average Fertility by Wealth", xlab = "Wealth", ylab = "Average Fertility")
grid(col = "gray", lty = "dotted")
dev.off()

# fertility_by_wealth <- rep(0, max(d$wealth) + 1)
# for (i in 0:max(d$wealth)) {
#   fertility_by_wealth[i+1] <- d[wealth == i, mean(fertility)]
# }
# plot(fertility_by_wealth, pch = 19, main = "Average Fertility by Wealth", xlab = "Wealth", ylab = "Average Fertility")




# Average Strategy for Different Wealth ----------------------------------
tiff(file="./figures/strategy_by_wealth.tiff", width = 2000, height = 1600, res = 300)
pdf(file = "./figures/strategy_by_wealth_death.pdf")
plot(d[, mean(strategy), by = wealth], pch = 20, main = "Average Strategy for Different Wealth", xlab = "Wealth", ylab = "Average Strategy")
grid(col = "gray", lty = "dotted")
dev.off()




# Average Fertility for Different Strategies ------------------------------
tiff(file="./figures/fertility_by_strategy.tiff", width = 2000, height = 1600, res = 300)
pdf(file = "./figures/fertility_by_strategy_death.pdf")
plot(d[, mean(fertility), strategy], pch=20, main = "Average Fertility for Different Strategies", xlab = "Strategy", ylab = "Average Fertility")
grid(col = "gray", lty = "dotted")
dev.off()




# What Strategies Survive? ------------------------------------------------
# at first
hist(d[generation == min(d$generation), strategy], breaks = 50, main = "Strategies Among Ancestors", xlab = "Strategy")
grid(col = "gray", lty = "dotted")

# last generation
hist(d[generation == max(d$generation), strategy], breaks = 50, main = "Strategies in Last Generation", xlab = "Strategy")
grid(col = "gray", lty = "dotted")




# Which ancestors have the most descendants? -------------------------
hist(d[generation == tail(d$generation, 1), `ancestor class`], ylab = "Number of Decendants", xlab = "Ancestor Class", main = "Number of Decendants in the Last Generation")
grid(col = "gray", lty = "dotted")

pdf(file = "./figures/descendant_number_by_ancestor_death.pdf")
plot(d[generation == tail(d$generation, 1), .N, `ancestor class`], pch = 19, main = "Number of Decendants in the Last Generation", xlab = "Ancestor Class", ylab = "Number of Decendants")
grid(col = "gray", lty = "dotted")
dev.off()

# 2D Density Plots --------------------------------------------------------

x <- d$wealth
y <- d$strategy

# 2d histogram with default option
bin <- hexbin(d$wealth, d$strategy, xbins=40)
my_colors=colorRampPalette(rev(brewer.pal(11,'Spectral')))
plot(bin, main="" , colramp=my_colors , legend=F )

ggplot(d, aes(x=x, y=y) ) +
  geom_bin2d(bins = 20) +
  theme_bw()

ggplot(d, aes(x=x, y=y) ) +
  geom_bin2d(bins = 20) +
  scale_fill_continuous(type = "viridis") +
  theme_bw()

# Hexbin chart with default option
ggplot(d, aes(x=x, y=y) ) +
  geom_hex() +
  theme_bw()

# Bin size control + color palette
# tiff(file="./figures/fertility_parents.tiff", width = 2000, height = 1600, res = 300)
ggplot(d, aes(x=wealth, y=strategy) ) +
  geom_hex(bins = 20) +
  # scale_fill_continuous(type = "viridis") + 
  # scale_fill_distiller(palette = 1, direction=-1) + 
  scale_fill_distiller(palette = "Spectral", direction=-1) +
  labs(title = "Fertility of Parents Across Generations", x = "Wealth", y = "Strategy", fill = "Fertility") + 
  scale_x_continuous(breaks = round(seq(min(d$wealth) - 1, max(d$wealth), by = 2),1)) +
  scale_y_continuous(breaks = round(seq(min(d$strategy) - 0.1, max(d$strategy), by = 0.2),1)) + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5))
# dev.off()