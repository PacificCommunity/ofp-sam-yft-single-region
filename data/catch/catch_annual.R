library(TAF)

catch <- read.taf(file.path("https://raw.githubusercontent.com",
                            "PacificCommunity/ofp-sam-yft-2023-diagnostic/main",
                            "TAF/output/catch.csv"))

catch.annual <- round(aggregate(t~year, catch, sum))
names(catch.annual) <- c("Year", "Catch")

write.taf(catch.annual)
