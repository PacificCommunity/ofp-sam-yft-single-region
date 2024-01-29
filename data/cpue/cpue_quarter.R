library(TAF)

cpue <- read.taf("single.region.index.csv")

cpue.quarter <- cpue
names(cpue.quarter) <- c("Year", "CPUE")
cpue.quarter$Year <- seq_len(nrow(cpue.quarter))

cpue.quarter$CPUE <- round(cpue.quarter$CPUE / 1e7, 1)

write.taf(cpue.quarter)
