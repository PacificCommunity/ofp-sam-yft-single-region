library(TAF)

cpue <- read.taf("single.region.index.csv")

# Average index within each year
cpue$Year <- floor(cpue$Time)
cpue <- aggregate(Index~Year, cpue, mean)

# Scale
cpue$Index <- cpue$Index / 1e6

write.taf(cpue, "cpue_year.csv")
