library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(ggplot2)

# Leaflet bindings are a bit slow; for now we'll just sample to compensate
set.seed(100)

function(input, output, session) {

  ## Interactive Map ###########################################

  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(group = "OpenStreetMap") %>%
      addProviderTiles(
        providers$Esri.WorldImagery,
        options = providerTileOptions(opacity = 0.5),
        group = "WorldImagery") %>%
      addProviderTiles(
        providers$OpenTopoMap,
        options = providerTileOptions(opacity = 0.5),
        group = "OpenTopoMap") %>%
      addLayersControl(
        baseGroups = c(
          "OpenStreetMap", 
          "WorldImagery",
          "OpenTopoMap"
        ),
        overlayGroups = c("Basin shape", "Gauging station"),
        options = layersControlOptions(collapsed = TRUE, 
                                       position = "bottomleft")
      )  %>%
      setView(lng = 9, lat = 50, zoom = 4)
  })
  
#  observeEvent(input$countries, {
#    if (input$countries == "Germany"){
#      showModal(modalDialog(
#        tagList(
#          selectInput("deletefilename", label = "Delete a file", choices = list.files(pattern="*.txt"))
#        ), 
#        title="Download weather data and run rainfall-runoff model",
#        footer = tagList(actionButton("confirmDelete", "Delete"),
#                         modalButton("Cancel")
#        )
#      ))
#    } else {
#      showNotification("This is a notification other")
#    }
#    
#  })

  # A reactive expression that returns the set of zips that are
  # in bounds right now
  
#  zipsInBounds <- reactive({
#    
#    if (is.null(input$map_bounds))
#      return(zipdata[FALSE,])
#    
#    bounds <- input$map_bounds
#    latRng <- range(bounds$north, bounds$south)
#    lngRng <- range(bounds$east, bounds$west)
#
#    subset(zipdata,
#      latitude >= latRng[1] & latitude <= latRng[2] &
#        longitude >= lngRng[1] & longitude <= lngRng[2])
#  })
#
#  # Precalculate the breaks we'll need for the two histograms
#  centileBreaks <- hist(plot = FALSE, allzips$centile, breaks = 20)$breaks
#
#  output$histCentile <- renderPlot({
#    # If no zipcodes are in view, don't plot
#    if (nrow(zipsInBounds()) == 0)
#      return(NULL)
#
#    hist(zipsInBounds()$centile,
#      breaks = centileBreaks,
#      main = "SuperZIP score (visible zips)",
#      xlab = "Percentile",
#      xlim = range(allzips$centile),
#      col = '#00DD00',
#      border = 'white')
#  })
#
#  output$scatterCollegeIncome <- renderPlot({
#    # If no zipcodes are in view, don't plot
#    if (nrow(zipsInBounds()) == 0)
#      return(NULL)
#
#    print(xyplot(income ~ college, data = zipsInBounds(), xlim = range(allzips$college), ylim = range(allzips$income)))
#  })
#
#  # This observer is responsible for maintaining the circles and legend,
#  # according to the variables the user has chosen to map to color and size.
  

  
  
  observe({
#    colorBy <- input$color
#    sizeBy <- input$size
#
#    if (colorBy == "superzip") {
#      # Color and palette are treated specially in the "superzip" case, because
#      # the values are categorical instead of continuous.
#      colorData <- ifelse(zipdata$centile >= (100 - input$threshold), "yes", "no")
#      pal <- colorFactor("viridis", colorData)
#    } else {
#      colorData <- zipdata[[colorBy]]
#      pal <- colorBin("viridis", colorData, 7, pretty = FALSE)
#    }
#
#    if (sizeBy == "superzip") {
#      # Radius is treated specially in the "superzip" case.
#      radius <- ifelse(zipdata$centile >= (100 - input$threshold), 30000, 3000)
#    } else {
#      radius <- zipdata[[sizeBy]] / max(zipdata[[sizeBy]]) * 30000
#    }
    
    leafletProxy("map") %>%
      clearShapes() %>%
      addCircles(data = stations_de,
                 lat = ~latitude,
                 lng = ~longitude,
                 label = ~object_id, 
                 group = "Gauging station",
                 fillColor = "#e2655d",
                 color = "#e2655d",
                 fillOpacity = 0.5,
                 stroke = TRUE,
                 layerId = ~object_id
      )  %>%
      addPolygons(data = basins_de,
                  group = "Basin shape",
                  stroke = TRUE,
                  weight = 1
                  )
    #print(input$map_shape_click)
  })

  # Show a popup at the given location
  showZipcodePopup <- function(zipcode, lat, lng) {
    #selectedZip <- allzips[allzips$zipcode == zipcode,]
    content <- as.character(tagList(
      tags$h5("Gauged name:", zipcode),
      tags$strong(HTML(sprintf("%s, %s %s",999,999,999
      ))), tags$br(),
      sprintf("Current streamflow: %s", 999), tags$br(),
      sprintf("Current precipitation: %s%%", 999), tags$br(),
      sprintf("Current maximum temperature: %s", 999)
    ))
    leafletProxy("map") %>% addPopups(lng, lat, content, layerId = zipcode)
  }

  # When map is clicked, show a popup with city info
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event$id)){
      paste("THis is event:", event)
      return()
    }
      

    isolate({
      showZipcodePopup(event$id, event$lat, event$lng)
      
        output$time_series <- renderPlotly({
          #plot_ly(data=streamflow_forecast %>% filter(object_id == event$id), 
          #        type='scatter', mode='markers', x=~hp, y=~mpg, name=~cyl)
          ggplotly(
            ggplot(data = streamflow_forecast %>% 
                     filter(object_id == event$id) %>%
                     last(60)) +
              geom_line(aes(x = time, y = q_mm_day), color = "#16a085") +
              geom_point(aes(x = time, y = q_mm_day), color = "#16a085", 
                         size = 1, alpha = 0.7) +
              labs(x = " ") +
              theme_bw()
            )
        })
        
        output$histogram <- renderPlotly({
          ggplotly(
            ggplot(data = streamflow_forecast %>% 
                     filter(object_id == event$id) %>%
                     last(60)) +
              geom_boxplot(aes(y = q_mm_day), color = "#16a085") +
              labs(x = " ") +
              theme_bw()
          )
        })
      
    })
  })


  ## Data Explorer ###########################################

#  observe({
#    cities <- if (is.null(input$states)) character(0) else {
#      filter(cleantable, State %in% input$states) %>%
#        `$`('City') %>%
#        unique() %>%
#        sort()
#    }
#    stillSelected <- isolate(input$cities[input$cities %in% cities])
#    updateSelectizeInput(session, "cities", choices = cities,
#      selected = stillSelected, server = TRUE)
#  })
#
#  observe({
#    zipcodes <- if (is.null(input$states)) character(0) else {
#      cleantable %>%
#        filter(State %in% input$states,
#          is.null(input$cities) | City %in% input$cities) %>%
#        `$`('Zipcode') %>%
#        unique() %>%
#        sort()
#    }
#    stillSelected <- isolate(input$zipcodes[input$zipcodes %in% zipcodes])
#    updateSelectizeInput(session, "zipcodes", choices = zipcodes,
#      selected = stillSelected, server = TRUE)
#  })
#
#  observe({
#    if (is.null(input$goto))
#      return()
#    isolate({
#      map <- leafletProxy("map")
#      map %>% clearPopups()
#      dist <- 0.5
#      zip <- input$goto$zip
#      lat <- input$goto$lat
#      lng <- input$goto$lng
#      showZipcodePopup(zip, lat, lng)
#      map %>% fitBounds(lng - dist, lat - dist, lng + dist, lat + dist)
#    })
#  })

  output$ziptable <- DT::renderDataTable({
    stations_de
  })
}
