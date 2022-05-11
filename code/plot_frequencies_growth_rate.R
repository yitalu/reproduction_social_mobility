table(optimal_growth_rates$V1)
max(table(optimal_growth_rates$V1))

tiff(file="./figures/frequencies_growth_rate.tiff", width = 2400, height = 1600, res = 300)

hist(optimal_growth_rates$V1, breaks=30, col="#69b3a2", xlab = "Optimal Growth Rate", main="Frequncies of Optimal Growth Rate", xlim = c(0, ceiling(max(optimal_growth_rates$V1))+0.2), ylim = c(0, max(table(optimal_growth_rates$V1)) + 100))

dev.off()