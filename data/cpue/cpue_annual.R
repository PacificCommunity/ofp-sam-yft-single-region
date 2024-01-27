library(TAF)

cpue <- read.taf("single.region.index.csv")

cpue.annual <- aggregate(Index~floor(Time), cpue, mean)
names(cpue.annual) <- c("Year", "CPUE")

cpue.annual$CPUE <- round(cpue.annual$CPUE / 1e6, 1)

write.taf(cpue.annual)
