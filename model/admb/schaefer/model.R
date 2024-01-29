## Run analysis, write model results

## Before: yft.ctl, yft.dat (data), 0.2014.zip (boot/software)
## After:  pella.tpl, pella (model)

library(TAF)

mkdir("model")

# Unzip ADMB source code into model folder
unzip("boot/software/0.2014.zip",
      files="biomass-0.2014/model/pella/pella.tpl", junkpaths=TRUE,
      exdir="model")

# Compile ADMB model
system("cd model; admb pella; rm pella.cpp pella.htp pella.obj")

# Copy data files
cp("data/yft.ctl", "model")
cp("data/yft.dat", "model")

# Run model
system("cd model; pella -ind yft.dat")
