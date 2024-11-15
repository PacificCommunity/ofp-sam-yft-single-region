library(TAF)

cpue <- read.taf("single.region.index.csv")

# Time structure
cpue$Year <- floor(cpue$Time)
cpue$Quarter <- 1 + 4 * (cpue$Time - cpue$Year)
cpue <- cpue[c("Year", "Quarter", "Index")]

# Scale
cpue$Index <- cpue$Index / 1e6

write.taf(cpue, "cpue_quarter.csv")
