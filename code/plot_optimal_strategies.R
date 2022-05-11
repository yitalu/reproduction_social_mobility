library(paletteer)
# tiff(file="./figures/proportion_over_time.tiff", width = 2400, height = 1600, res = 300)
# dev.off()


num_class <- 15
max_investment <- 0:(num_class - 1)
max_fertility <- c(0, 0, 0, 0, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3)

tiff(file="./figures/optimal_strategies.tiff", width = 2400, height = 1600, res = 300)
plot(max_investment, c(0:14), type = "l", main = "Fertility Investment of Parents in Different Wealth Classes", ylab = "Fertility Investment", xlab = "Wealth Class")
rect(par("usr")[1], par("usr")[3],
     par("usr")[2], par("usr")[4],
     col = "#f7f7f7")
grid(nx = NULL, ny = NULL,
     lty = 2,      # Grid line type
     col = "gray", # Grid line color
     lwd = 1)

  
paletteer_d("basetheme::brutal")
cols <- paletteer_d("ggthemes::Classic_20")
# cols <- paletteer_d("basetheme::brutal")
for (i in 1:round(nrow(optimized_allocations)/2)) {
  # lines(jitter(as.numeric(optimized_fertilities[i,]), 0) ~ jitter(fertility_allocation, 0), lwd = 2, col=cols[i])
  points(jitter(as.numeric(optimized_allocations[i,]), 0.8) ~ jitter(max_investment, 0.8), pch = 20, cex=1.2, col=cols[i])
}
lines(max_investment ~ c(0:14), lty = 1)
lines(max_fertility ~ max_investment, lty = 1)
dev.off()

# legend("topright", legend=c("Ixos","Primadur"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), pt.cex=2, pch=15 )