#data_dir <- "C:/Users/nguyenta/Documents/GitHub/openMetHydro/data/temp_dir"
#years <- c(1980:2025)
#basin_shp <- basins
#out_dir <- data_dir

# 2 days Index of /weather/nwp/icon-d2/grib/00/

library(shiny)
library(plotly)
library(leaflet)
library(sf)
library(dplyr)
library(rdwd)
library(terra)
library(sf)
library(exactextractr)
library(data.table)

#setwd("C:/Users/nguyenta/Documents/GitHub/openMetHydro")


model <- c("icon-d2", "icon-eu") 
run_time <- list()
run_time[["icon-d2"]]  <- sprintf("%02d", seq(0, 21, 3)) 
run_time[["icon-eu"]]  <- sprintf("%02d", seq(0, 21, 3)) 

time_step <- list()
time_step[["icon-d2"]]  <- sprintf("%02d", seq(0, 48, 1)) 
time_step[["icon-eu"]]  <- sprintf("%02d", seq(0, 120, 1)) 

# Download icon data
base_link <- paste0("https://opendata.dwd.de/weather/nwp/model/grib/run_time/",
                    "tmax_2m/icon-eu_europe_regular-lat-lon_single-level_",
                    "2025041500_000_TMAX_2M.grib2.bz2")

model <- "icon-eu"
current_date <- as.Date("2025-04-01", format("%Y-%m-%d"))



https://opendata.dwd.de/weather/nwp/icon-eu/grib/00/tmax_2m/icon-eu_europe_regular-lat-lon_single-level_2025041500_117_TMAX_2M.grib2.bz2
https://opendata.dwd.de/weather/nwp/icon-d2/grib/00/runoff_s/icon-d2_germany_regular-lat-lon_single-level_2025041500_000_2d_runoff_s.grib2.bz2



base_link_update <- file.path(base_link, base_link_suffix[i])
file_name_update <- paste0(file_name_prefix[i], file_name)
file_name_update <- gsub("year", yr, file_name_update)

download.file(file.path(base_link_update, file_name_update), 
              file.path(save_dir,file_name_update),
              mode="wb")


res <- c("2 days 2 km", "5 days 7 km", "7.5 days 11 km")




