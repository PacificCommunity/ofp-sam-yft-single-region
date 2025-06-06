sigma2flag <- function(sigma)
{
  penalty <- 1 / (2*sigma^2)
  flag.value <- 10 * penalty
  flag.value
}

flag2sigma <- function(flag.value)
{
  penalty <- flag.value / 10
  sigma <- sqrt(1/(2*penalty))
  sigma
}

# Read YFT model settings
ofp.sam <- "https://raw.githubusercontent.com/PacificCommunity/ofp-sam-"
file <- "yft-2023-diagnostic/refs/heads/main/MFCL/doitall.sh"
url <- paste0(ofp.sam, file)
doitall <- readLines(url)

# Read CPUE settings
skip <- grep("CPUE variation", doitall)
cpue.settings <- read.table(text=doitall, skip=skip, nrows=5)
flag.value <- cpue.settings$V6

# Convert to sigma
sigma <- flag2sigma(flag.value)

# Plot
barplot(sigma, names=1:5, xlab="region", ylab="cv", ylim=c(0,0.3))
abline(h=0.25, lty=2)
