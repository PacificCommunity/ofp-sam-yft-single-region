library(TAF)

# Read YFT 2023 assessment data
catch <- read.taf(file.path("https://raw.githubusercontent.com",
                            "PacificCommunity/ofp-sam-yft-2023-diagnostic/main",
                            "TAF/output/catch.csv"))

# Calculate quarterly catches
catch <- round(aggregate(catch~year+season, catch, sum))
catch <- catch[order(catch$year, catch$season),]
names(catch) <- c("Year", "Quarter", "Catch")
catch <- data.frame(Time=seq_len(nrow(catch)), catch)
row.names(catch) <- NULL

# Round catches
catch$Catch <- round(catch$Catch / 1e3, 1)

# Write table
write.taf(catch, "catch_quarter.csv")
