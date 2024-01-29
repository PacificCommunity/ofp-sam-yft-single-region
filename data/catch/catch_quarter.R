library(TAF)

catch <- read.taf(file.path("https://raw.githubusercontent.com",
                            "PacificCommunity/ofp-sam-yft-2023-diagnostic/main",
                            "TAF/output/catch.csv"))

catch.quarter <- round(aggregate(t~year+season, catch, sum))
catch.quarter <- catch.quarter[order(catch.quarter$year, catch.quarter$season),]
names(catch.quarter) <- c("Year", "Quarter", "Catch")
catch.quarter$Year <- seq_len(nrow(catch.quarter))
catch.quarter$Quarter <- NULL

catch.quarter$Catch <- round(catch.quarter$Catch / 1e3, 1)

write.taf(catch.quarter)
