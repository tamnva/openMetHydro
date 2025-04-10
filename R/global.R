library(shiny)
library(leaflet)
library(sf)
library(dplyr)
library(rdwd)

# Load spatial data - using US basins shapefile from 'sf' package
setwd("C:/Users/nguyenta/Documents/GitHub/openMetHydro")
basins <- st_read(file.path("data", "catchments.shp"), quiet = TRUE)
basins$AREA <- as.numeric(st_area(basins)/10^6)
basins$NAME <- basins$gauge_id
basins <- st_transform(basins, '+proj=longlat +datum=WGS84')

stations <- st_read(file.path("data", "stations.shp"), quiet = TRUE)
stations <- st_transform(stations, '+proj=longlat +datum=WGS84')
#stations <- stations[c(1:10),]

# Download germany data
get_dwd_data <- function(years, folder, catchments){
  
  dir.create(file.path("data", "temp_dir"), showWarnings = FALSE)
  base_link <- "https://opendata.dwd.de/climate_environment/CDC/grids_germany/daily/hyras_de/xxxx_hyras_1_yyyy_v6-0_de.nc"
  
  for (year in years){
    for (data in c("precipitation/pr", 
                   "air_temperature_min/tasmin", 
                   "air_temperature_min/tasmin")){
      link <- gsub("xxxx", data, base_link)
      link <- gsub("yyyy", year, link)
      download.file(url = link, file.path("data", "temp_dir", basename(link)))
    }
  }
  
  #nwpbase <- "ftp://opendata.dwd.de/weather/nwp/icon-d2/grib/00/t_2m"
  #links <- indexFTP("", base=nwpbase, dir=tempdir())
  #file <- dataDWD(links[6], base=nwpbase, joinbf=TRUE, dir=tempdir(), read=FALSE)
  #forecast <- readDWD(file)
}