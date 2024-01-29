library(TAF)

catch <- read.taf(file.path("https://raw.githubusercontent.com",
                            "PacificCommunity/ofp-sam-yft-2023-diagnostic/main",
                            "TAF/output/catch.csv"))

catch.year <- round(aggregate(t~year, catch, sum))
names(catch.year) <- c("Year", "Catch")

catch.year$Catch <- round(catch.year$Catch / 1e3, 1)

write.taf(catch.year)
