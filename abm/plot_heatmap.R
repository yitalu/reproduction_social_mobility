rm(list = ls())
# install.packages("hexbin")
library(lattice)
library(ggplot2)
library(hexbin)
library(RColorBrewer)

View(mtcars)
d <- as.matrix(mtcars)

heatmap(d, scale = "column")


x <- runif(100, min = 0, max = 1)
y <- rnorm(100, mean = 5, sd = 2)
y <- runif(20, min = 0, max = 1)

x <- seq(0, 10, length.out = 20)
y <- seq(0, 10, length.out = 20)
data <- expand.grid(X=x, Y=y)
data$Z <- runif(400, 0, 5)
View(data)
levelplot(Z ~ X * Y, data = data)

x <- seq(0, 10, length.out = 10)
y <- runif(100, min = 0, max = 1)
data <- expand.grid(X=x, Y=y)
data$Z <- runif(1000, 0, 5)
# data$Z <- rnorm(2000, mean = 5, sd = 10)

levelplot(Z ~ X * Y, data = data)

heatmap(z ~ x + y)



m <- matrix(rnorm(100), ncol = 10)
colnames(m) <- paste("Col", 1:10)
rownames(m) <- paste("Row", 1:10)
heatmap(m)
heatmap(m, scale = "column")
heatmap(m, col = hcl.colors(50))





x <- rnorm(mean=1.5, 5000)
y <- rnorm(mean=1.6, 5000)

# Make the plot
bin <- hexbin(x, y, xbins=40)
my_colors=colorRampPalette(rev(brewer.pal(11,'Spectral')))
plot(bin, main="" , colramp=my_colors , legend=F ) 


# read data
data_parents <- read.csv("./data/data_parents.csv", header = FALSE)
colnames(data_parents) <- c("wealth", "strategy", "ancestor_class")
data_parents_new <- read.csv("./data/data_parents_new.csv", header = FALSE)
colnames(data_parents_new) <- c("wealth", "strategy", "ancestor_class")
ancestors <- read.csv("./data/ancestors.csv", header = FALSE)
colnames(ancestors) <- c("inheritance", "income", "total_wealth", "strategy", "fertility_investment", "bequests", "fertility", "ancestor_class")

x <- data_parents$wealth
y <- data_parents$strategy

bin <- hexbin(data_parents$wealth, data_parents$strategy, xbins=40)
my_colors=colorRampPalette(rev(brewer.pal(11,'Spectral')))
plot(bin, main="" , colramp=my_colors , legend=F )

ggplot(data_parents, aes(x, y)) +
  stat_density2d(geom="tile", aes(fill = ..density..), contour = FALSE) + 
  geom_point(colour = "white")


# 2d histogram with default option
ggplot(data_parents, aes(x=x, y=y) ) +
  geom_bin2d(bins = 20) +
  theme_bw()

# Bin size control + color palette
ggplot(data_parents, aes(x=x, y=y) ) +
  geom_bin2d(bins = 20) +
  scale_fill_continuous(type = "viridis") +
  theme_bw()




# Hexbin chart with default option
ggplot(data_parents, aes(x=x, y=y) ) +
  geom_hex() +
  theme_bw()


# Bin size control + color palette
tiff(file="./figures/fertility_parents.tiff", width = 2000, height = 1600, res = 300)
ggplot(data_parents, aes(x=wealth, y=strategy) ) +
  geom_hex(bins = 20) +
  # scale_fill_continuous(type = "viridis") + 
  # scale_fill_distiller(palette = 1, direction=-1) + 
  scale_fill_distiller(palette = "Spectral", direction=-1) +
  labs(title = "Fertility of Parents Across Generations", x = "Wealth", y = "Strategy", fill = "Fertility") + 
  scale_x_continuous(breaks = round(seq(min(data_parents$wealth) - 1, max(data_parents$wealth), by = 2),1)) +
  scale_y_continuous(breaks = round(seq(min(data_parents$strategy) - 0.1, max(data_parents$strategy), by = 0.2),1)) + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5))
dev.off()

a <- as.numeric(table(ancestors$total_wealth))
table(data_parents$ancestor_class) / table(ancestors$total_wealth)[2:15]
hist(data_parents$ancestor_class, xlab = "Ancestor Class", ylab = "Number of Descendant")
# should i divide the number of descendant by the number of individuals in each ancestor class?


table(data_parents_new$ancestor_class)
hist(data_parents_new$ancestor_class)
table(ancestors$total_wealth)
hist(ancestors$total_wealth)

table(data_parents_new$ancestor_class) / table(ancestors$total_wealth)[2:15]
vec <- c(0, table(data_parents_new$ancestor_class) / table(ancestors$total_wealth)[2:15])
dt <- data.table(class = c(1:15), count = vec)
plot(dt$count ~ dt$class, type = "l")
