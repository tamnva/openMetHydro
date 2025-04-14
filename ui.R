library(leaflet)

# Choices for drop-downs
vars <- c(
  "Is SuperZIP?" = "superzip",
  "Centile score" = "centile",
  "College education" = "college",
  "Median income" = "income",
  "Population" = "adultpop"
)


navbarPage(
  "Open weather & flood hub", 
  id="nav",
  

  
  tabPanel(
    "Interactive map",
    
    div(
      class="outer",
      
      tags$head(
        # Include our custom CSS
        includeCSS("styles.css"),
        includeScript("gomap.js")
      ),
      
      # If not using custom CSS, set height of leafletOutput to a number instead of percent
      leafletOutput("map", 
                    width="100%", 
                    height="100%"),
      
      # Shiny versions prior to 0.11 should use class = "modal" instead.
      absolutePanel(

        id = "controls", 
        class = "panel panel-default", 
        fixed = TRUE,
        draggable = TRUE, 
        top = 150, 
        left = 10, 
        right = "auto", 
        bottom = "auto",
        width = 400, 
        height = "auto",
        cursor = "auto",
        
        h4("Weather & Streamflow Explorer"),
        
        selectInput("countries", 
                    "Select country", 
                    list("Germany", "US", "Switzerland")),
        
        plotlyOutput(outputId = "time_series", height = 200),
        plotlyOutput("histogram", height = 250, width = "50%"),
      )
    )
  ),
  
  tabPanel(
    "Interactive plots",
    
    fluidRow(
      column(3,
             selectInput("select_countries", 
                         "Countries", 
                         choices = list("Germany", "Switzerland"), 
                         selected = "Germany",
                         multiple=TRUE)
      )
    ),
    
    h4("thisi is plotly"),
    #plotlyOutput(outputId = "histCentile1", height = 200),
    
    hr(),
    
    DT::dataTableOutput("ziptable")
  ),
  
  #conditionalPanel("false", icon("crosshair"))
)
