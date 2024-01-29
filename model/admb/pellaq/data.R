## Preprocess data, write TAF data tables

## Before: catch_quarter.csv, cpue_quarter.csv (boot/data)
## After:  catch_quarter.csv, cpue_quarter.csv, yft.ctl, yft.dat (data)

library(TAF)

mkdir("data")

comment.ctl <- function(x, append=TRUE) write(x, file=ctlfile, append=append)
comment.dat <- function(x, append=TRUE) write(x, file=datfile, append=append)
write.n <- function(x) write(nrow(x), file=datfile, append=TRUE)
write.plui <- function(x) write(x, file=ctlfile, sep="\t", append=TRUE)
write.tab <- function(x)
{
  write.table(x, file=datfile, row.names=FALSE, col.names=FALSE, sep="  ",
              append=TRUE)
}
ctlfile <- "data/yft.ctl"
datfile <- "data/yft.dat"

# Read data
catch <- read.taf("boot/data/catch_quarter.csv")
cpue <- read.taf("boot/data/cpue_quarter.csv")

# Write ctl file
comment.ctl("# logr", append=FALSE)
write.plui(c(1,     -5,  0, -1))
comment.ctl("# logk")
write.plui(c(1,      7, 11,  9))
comment.ctl("# loga")
write.plui(c(-1,   -10,  2,  0))
comment.ctl("# p")
write.plui(c(1, -0.99,  9,  1))
comment.ctl("# logq")
write.plui(c(1,    -11, -3, -7))
comment.ctl("# logsigma")
write.plui(c(1,     -5,  0, -1))

# Write dat file
comment.dat("# Number of quarters in catch data", append=FALSE)
write.n(catch)
comment.dat("# Catch (1000 t), missing quarters not allowed")
write.tab(catch)
comment.dat("# Number of quarters in CPUE data")
write.n(cpue)
comment.dat("# CPUE index, missing quarters allowed")
write.tab(cpue)

# Copy TAF tables
cp("boot/data/catch_quarter.csv", "data")
cp("boot/data/cpue_quarter.csv", "data")
