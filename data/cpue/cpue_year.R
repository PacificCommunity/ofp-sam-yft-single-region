library(TAF)

cpue <- read.taf("single.region.index.csv")

cpue.year <- aggregate(Index~floor(Time), cpue, mean)
names(cpue.year) <- c("Year", "CPUE")

cpue.year$CPUE <- round(cpue.year$CPUE / 1e7, 1)

write.taf(cpue.year)
