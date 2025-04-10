library(shiny)
library(leaflet)
library(sf)
library(dplyr)

# Load spatial data - using US basins shapefile from 'sf' package
setwd("C:/Users/nguyenta/Documents/GitHub/openMetHydro")
basins <- st_read(file.path("data", "catchments.shp"), quiet = TRUE)
basins <- basins[c(1:100),]
basins$AREA <- as.numeric(st_area(basins)/10^6)
basins$NAME <- basins$gauge_id
basins <- st_transform(basins, '+proj=longlat +datum=WGS84')

stations <- st_read(file.path("data", "stations.shp"), quiet = TRUE)
stations <- st_transform(stations, '+proj=longlat +datum=WGS84')
#stations <- stations[c(1:100),]
