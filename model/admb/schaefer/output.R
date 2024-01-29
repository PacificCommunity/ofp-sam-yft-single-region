## Extract results of interest, write TAF output tables

## Before: pella.rep (model)
## After:  summary.csv (output)

library(TAF)

mkdir("output")

# Read rep file
repfile <- "model/pella.rep"
txt <- readLines(repfile)

# Extract summary table
skip <- grep("# Model summary", txt)
summary <- read.table(text=txt, skip=skip, header=TRUE)

# Write TAF table
write.taf(summary, dir="output")
