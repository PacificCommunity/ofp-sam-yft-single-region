library(TAF)

# Read single-region index
cpue <- read.taf("single.region.index.csv")

# Average index within each year
cpue$Year <- floor(cpue$Time)
cpue <- aggregate(Index~Year, cpue, mean)

# Round index
cpue$Index <- round(cpue$Index / 1e6, 1)

# Write table
write.taf(cpue, "cpue_year.csv")
