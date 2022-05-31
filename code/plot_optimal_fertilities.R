# install.packages("plotly")
# install.packages("ggpubr")
# install.packages("paletteer")
# library(plotly) # includes ggplot2
library(ggpubr)
library(paletteer)

set.seed(1)
# x <- sample(1:10, 200, TRUE)
# y <- 3 * x + rnorm(200, 0, 5)

# plot(y ~ x, pch = 15)
# plot(y ~ jitter(x, 1.5), pch = 15)

num_class <- 15
max_offspring <- 3
# starvation_threshold <- 3
fertility_allocation <- 0:(num_class - 1)

# max_fertility <- max_offspring * (1 - exp(-(fertility_allocation - starvation_threshold)))
# max_fertility <- pmax(max_fertility, 0) # clip at 0
max_fertility <- c(0, 0, 0, 0, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3)
fertility_intermediate <- c(0, 0, 0, 2, 3, 3, 3, 2, 2, 2, 2, 2, 2, 3)


tiff(file="./figures/optimal_fertilities.tiff", width = 2400, height = 1600, res = 300)

plot(fertility_allocation, max_fertility, type = "l", lty = 3, ylim = c(-0.5, max_offspring + 1), main = "Optimal Fertilities for Parents with Different Wealth", xlab = "Wealth/Class", ylab = "Fertility")
rect(par("usr")[1], par("usr")[3],
     par("usr")[2], par("usr")[4],
     col = "#f7f7f7")
     # col = "#ebebeb")

grid(nx = NULL, ny = NULL,
     lty = 2,      # Grid line type
     col = "gray", # Grid line color
     lwd = 1)

lines(fertility_intermediate ~ 0:14, lty = 1, lwd = 2)
# points(fertility_allocation, max_fertility, cex = 1)

# points(as.numeric(optimized_fertilities[1,]) ~ jitter(fertility_allocation, 1), pch = 20, cex=0.5)

# jittered dots
# see https://r-charts.com/color-palettes/#discrete for color palettes
# or https://emilhvitfeldt.github.io/r-color-palettes/discrete.html
cols <- paletteer_d("ggthemes::Classic_20")
# cols <- paletteer_d("ggthemes::Tableau_20")
for (i in 1:round(nrow(optimized_fertilities)/2)) {
  # lines(jitter(as.numeric(optimized_fertilities[i,]), 0) ~ jitter(fertility_allocation, 0), lwd = 2, col=cols[i])
  points(jitter(as.numeric(optimized_fertilities[i,]), 0.5) ~ jitter(fertility_allocation, 0.5), pch = 20, cex=1, col=cols[i])
}
dev.off()
