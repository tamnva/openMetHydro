#library(shiny)
#library(leaflet)
#library(sf)
#library(dplyr)

# Server
server <- function(input, output) {
  
  observeEvent(input$select_station, { 
    
    filtered_basin <- basins %>% filter(gauge_name == input$select_station)

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
        addPolygons(
          data = filtered_basin, #filtered_data(),
          label = ~gauge_name,
          group = "Basin shape",
          fillColor = "#5d95e2",
          color = "#000000",
          weight = 1,
          fillOpacity = 0.3
        ) %>%
        #
        addCircles(data = stations, 
                   label = ~gauge_name, 
                   group = "Gauging station",
                   fillColor = "#e2655d",
                   color = "#e2655d",
                   fillOpacity = 1
        ) %>% 
        #
        addLayersControl(
          baseGroups = c(
            "OpenStreetMap", 
            "NatGeoWorldMap",
            "WorldImagery"
          ),
          overlayGroups = c("Basin shape", "Gauging station"),
          options = layersControlOptions(collapsed = TRUE)
        )
    })
    
  })
  
}

