# UI
ui <- fluidPage(
  titlePanel("OpenFloodHub"),
  sidebarLayout(
    sidebarPanel(
      selectInput("select_station", "Select stations:",
                  choices = stations$gauge_name
      ),
      #sliderInput("range", "Filter by Area:",
      #            min = min(states$AREA), max = max(states$AREA),
      #            value = c(min(states$AREA), max(states$AREA)))
    ),
    
    mainPanel(
      leafletOutput("map", height = 600)
    )
  )
)