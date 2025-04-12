# UI
ui <- fluidPage(
  titlePanel("OpenFloodHub"),
  sidebarLayout(
    sidebarPanel(
      #sliderInput("range", "Filter by Area:",
      #            min = min(states$AREA), max = max(states$AREA),
      #            value = c(min(states$AREA), max(states$AREA)))
    ),
    
    mainPanel(
      leafletOutput("map", height = "100%")
    )
  )
)