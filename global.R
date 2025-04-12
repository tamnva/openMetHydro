library(dplyr)
library(sf)

#setwd("C:/Users/nguyenta/Documents/GitHub/openMetHydro")

stations_de <- readRDS("data/stations_de.rds")
basins_de <- st_read("data/basins_de.shp")

