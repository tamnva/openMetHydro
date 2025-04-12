library(shiny)
library(leaflet)
library(sf)
library(dplyr)

setwd("C:/Users/nguyenta/Documents/GitHub/openMetHydro")
basins <- st_read("C:/Users/nguyenta/Documents/GitHub/openMetHydro/old/basins_de.shp", quiet = TRUE)
basins <- st_transform(basins, '+proj=longlat +datum=WGS84')

# Server
server <- function(input, output) {
  
  observeEvent(input$select_station, { 

    output$map <- renderLeaflet({
      leaflet() %>%
        addTiles(group = "OpenStreetMap") %>%
        #
        addProviderTiles(providers$Esri.NatGeoWorldMap, 
                         group = "NatGeoWorldMap") %>%
        #
        addProviderTiles(
          providers$Esri.WorldImagery,
          options = providerTileOptions(opacity = 0.5),
          group = "WorldImagery"
        
        ) %>%
        #
        addLayersControl(
          baseGroups = c(
            "OpenStreetMap", 
            "NatGeoWorldMap",
            "WorldImagery"
          ),
          overlayGroups = c("Basin shape"),
          options = layersControlOptions(collapsed = TRUE)
        )
    })
    
  })
  
}

