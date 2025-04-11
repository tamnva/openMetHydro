library(shiny)
library(leaflet)
library(sf)
library(dplyr)
library(rdwd)

library(terra)
library(sf)
library(exactextractr)
library(data.table)

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
get_dwd_hyras <- function(years, save_dir){
  
  #save_dir <- "C:/Users/nguyenta/Documents/GitHub/openMetHydro/data/temp_dir"
  #years <- c(1980:2025)
  
  options(timeout=3600)
  
  base_link <- "https://opendata.dwd.de/climate_environment/CDC/grids_germany/daily/hyras_de"
  file_name <- "_hyras_1_year_v6-0_de.nc"
  
  base_link_suffix <- c("precipitation", "air_temperature_min", "air_temperature_max", "humidity")
  file_name_prefix <- c("pr", "tasmin", "tasmax", "hurs")
  
  for (yr in years){
    for (i in c(1:4)){
      
      base_link_update <- file.path(base_link, base_link_suffix[i])
      file_name_update <- paste0(file_name_prefix[i], file_name)
      file_name_update <- gsub("year", yr, file_name_update)
      
      download.file(file.path(base_link_update, file_name_update), 
                    file.path(save_dir,file_name_update),
                    mode="wb")

    }
  }
  
}


basin_extraction_hyras <- function(years, data_dir, basin_shp, out_dir=NA){
  
  if (is.na(out_dir)) out_dir <- data_dir
  
  file_name <- "_hyras_1_year_v6-0_de.nc"
  file_name_prefix <- c("pr", "tasmin", "tasmax", "hurs")
  
  for (yr in years){
    
    for (i in c(1:4)){
      
      message(yr)
      
      file_name_update <- file.path(
        data_dir, gsub("year", yr, paste0(file_name_prefix[i], file_name)))
      
      # Get data
      data <- rast(file_name_update)

      if (yr == years[1]) basin_shp <- st_transform(basin_shp, crs(data))
      
      # Extract data
      data <- exact_extract(data, 
                    basin_shp,   #subset(basin_shp, gauge_id == "DE110000"), 
                    fun = 'mean')
      
      data_extract <- t(data.frame(data))
      colnames(data_extract) <- basin_shp$gauge_id
      
      if (yr == years[1]) {
        write.table(x = data_extract, 
                  file = file.path(out_dir, paste0(file_name_prefix[i], ".csv")), 
                  row.names = FALSE, sep = ",", quote = FALSE)
        
      } else {
        write.table(x = data_extract,
                    file = file.path(out_dir, paste0(file_name_prefix[i], ".csv")), 
                    row.names = FALSE, sep = ",", quote = FALSE, append = TRUE)
      }
    }
  }
  
}


#data_dir <- "C:/Users/nguyenta/Documents/GitHub/openMetHydro/data/temp_dir"
#years <- c(1980:2025)
#basin_shp <- basins
#out_dir <- data_dir


