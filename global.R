library(dplyr)

#setwd("C:/Users/nguyenta/Documents/GitHub/openMetHydro")

stations <- readRDS("data/stations.rds")

clean_stations <- stations %>%
  select(
    Object_ID = object_id,
    Gauged_Name = gauged_name,
    Latitude = latitude,
    Longitude = longitude
  )
