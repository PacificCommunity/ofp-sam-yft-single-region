library(TAF)

# Read YFT 2023 assessment data
catch <- read.taf(file.path("https://raw.githubusercontent.com",
                            "PacificCommunity/ofp-sam-yft-2023-diagnostic/main",
                            "TAF/output/catch.csv"))

# Calculate annual catches
catch <- round(aggregate(catch~year, catch, sum))
names(catch) <- c("Year", "Catch")

# Round catches
catch$Catch <- round(catch$Catch / 1e3, 1)

# Write table
write.taf(catch, "catch_year.csv")
