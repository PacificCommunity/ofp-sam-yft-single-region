## Prepare plots and tables for report

## Before: summary.csv (output)
## After:  biomass.png, index.png (report)

library(TAF)

mkdir("report")

# Read summary table
summary <- read.taf("output/summary.csv")

# Plot biomass
taf.png("biomass")
z <- barplot(Catch~Year, summary, ylim=lim(summary$Biomass),
             ylab="Biomass and catch")
lines(z, summary$Biomass)
box()
dev.off()

# Plot index
taf.png("index")
plot(Index~Year, summary, ylim=lim(c(summary$Index, summary$IndexFit)))
lines(IndexFit~Year, summary)
dev.off()
