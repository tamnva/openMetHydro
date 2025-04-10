#library(shiny)
#library(leaflet)
#library(sf)
#library(dplyr)

# Server
server <- function(input, output) {
  filtered_data <- reactive({
    basins %>% filter(AREA >= input$range[1], AREA <= input$range[2])
  })
  
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
        data = basins, #filtered_data(),
        label = ~gauge_name,
        group = "Basin shape",
        fillColor = ~colorQuantile("YlOrRd", AREA)(AREA),
        weight = 1,
        color = "white",
        fillOpacity = 0.3
      ) %>%
      #
      addCircles(data = stations, 
                 label = ~gauge_name, 
                 group = "Gauging station",
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
}

