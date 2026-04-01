library(TAF)

# Read single-region index
cpue <- read.taf("single.region.index.csv")

# Time structure
cpue$Year <- floor(cpue$Time)
cpue$Quarter <- 1 + 4 * (cpue$Time - cpue$Year)
cpue <- cpue[c("Year", "Quarter", "Index")]
cpue <- data.frame(Time=seq_len(nrow(cpue)), cpue)

# Round index
cpue$Index <- round(cpue$Index / 1e6, 1)

# Write table
write.taf(cpue, "cpue_quarter.csv")
