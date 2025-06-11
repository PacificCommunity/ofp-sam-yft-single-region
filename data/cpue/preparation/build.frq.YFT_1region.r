## Thom Teears
## February 14, 2024
## converting everything to one region, areas-as-fleets and one index

rm(list=ls())

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(dplyr)
library(FLR4MFCL)
library(frqit)
library(magrittr)
#library(diags4MFCL)
library(data.table)

## define proj.dir
FrqDir = "../BaseFiles/"

num.regions <- 1
tag.grps <- 0

## bring in frq from mufdagr
frq = frqit::readfrq("Z:/yft/2023/model_runs/diagnostic/yft.frq")

## change the movement matrix
move_matrix(frq) = matrix(NA)

## - adjust number of fisheries
frq@n_fisheries <- 33

## - adjust dflags
frq@data_flags <- frq@data_flags[,1:frq@n_fisheries]

## update number of tag groups
frq@n_tag_groups <- tag.grps

## set all region sizes to 1 as per John Hampton
frq@n_regions <- num.regions
frq@region_size <- frq@region_size[,,,,1:num.regions,]

## adjust region fisheries
region_fish(frq) <- frq@region_fish[,,1:frq@n_fisheries,,,]
frq@region_fish[,,1:frq@n_fisheries,,,] <- rep(1, frq@n_fisheries)

## adjust season-region flags
frq@season_flags <- matrix(rep(1, 4))

## create weight comp data table and remove comps for index fisheries
wt.dt = data.table::as.data.table(wtfrq(frq)) %>% filter(fishery < 33)

## replace weight comps with Tom Peatman's re-weighted comps
load(file = "C:/StockAssessment/Yellowfin/2024/TomPeatmanFiles/f_2023_data_1_region/weight_a_2020_data_YFT_weak_filter/_reweighted_comps.RData")

size.comps %<>%
  mutate(wt = wt + 1, month = qtr * 3 - 1, week = 1, fishery = 33) %>%
  rename(year = yy) %>%
  tidyr::pivot_wider(names_from = "wt", values_from = "freq", values_fill = 0) %>%
  select(-c(qtr, sp.code))

## combine new size comps with wt comp table
wt.dt %<>% rbind(size.comps)

## get variability from original indices and sum
cpue.se.dt <- data.table::as.data.table(cateffpen(frq)) %>%
  filter(fishery > 32) %>% mutate(CV = 1 / sqrt(2 * penalty),
                                  index = catch / effort) %>%
  mutate(SD = CV * index) %>%
  group_by(year, month) %>%
  summarise(SD = sum(SD), index = sum(index)) %>% ungroup() %>%
  mutate(CV = SD / index) %>%
  mutate(penalty = (((1 / CV) ^ 2) / 2)) %>% select(year, month, penalty)

## create catch data table and remove cpue values
catch.dt = data.table::as.data.table(cateffpen(frq)) %>% filter(fishery < 33)

## insert new cpue
cpue <- read.csv(file = "../Data/YFT.2023.index.5x5.csv")

## assign regions
load(file = "../Data/yft_5regions_shp_2023.RData")

num.regions.2023 <- 5 ## number of regions in 2023 diagnostic model
cpue$Region = NA
for(i in 1:num.regions.2023){
  coords = regions.shp@polygons[[i]]@Polygons[[1]]@coords
  cpue$Region = ifelse(sp::point.in.polygon(cpue$lat_5,
                                                     cpue$lon_5, coords[,2],
                                                     coords[,1]) %in%
                                  c(1,2),i,cpue$Region)
}
## collapse regions and summarise
cpue %<>% filter(!is.na((Region))) %>% rename(year = Year) %>%
  mutate(month = Qtr * 3 - 1, week = 1, fishery = 33) %>%
  group_by(year, month, week, fishery) %>%
  summarise(rel_abund = sum(rel_abund)) %>% ungroup() %>%
  mutate(rel_abund =  rel_abund / mean(rel_abund)) %>%
  mutate(catch = 1, effort = 1 /rel_abund) %>%
  select(year, month, week, fishery, catch, effort) %>%
  left_join(cpue.se.dt)

## add cpue to catch table
catch.dt %<>% rbind(cpue)

## remove zero catches
catch.dt %<>% filter(catch > 0)

## remove NAs and sort catch
catch.dt %<>% filter(!is.na(fishery))  %>% .[order(fishery,year,month,week)] %>%
  mutate(id = paste0(year, "-", month, "-", fishery))

## sort weight comps
wt.dt %<>% .[order(fishery,year,month,week)]
## check to make sure all weight comps have observations
sum(rowSums(wt.dt[,6:ncol(wt.dt)]) == 0)

## remove weight comps without associated catches
wt.dt %<>% mutate(id = paste0(year, "-", month, "-", fishery))
wt.dt <- wt.dt[id %in% catch.dt$id]

## insert length and weight comps and catch back into frq file
## make sure the columns are in the right order
catch.dt %<>% relocate(fishery, .after = week)
cateffpen(frq) = as.data.frame(catch.dt) %>%
  select(year, month, week, fishery, catch, effort, penalty)
wt.dt %<>% relocate(fishery, .after = week)
wtfrq(frq) = as.data.frame(wt.dt) %>% select(-id)

## adjust number of datasets
frq@lf_range[1] <- nrow(catch.dt)
frq@lf_range[1]

# write-out
writefrq(frq, paste0(FrqDir,"yft_2024_1region.frq"))
