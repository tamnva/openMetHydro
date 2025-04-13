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
        top = 65, 
        left = "auto", 
        right = 10, 
        bottom = "auto",
        width = 300, 
        height = "auto",
        
        h4("Weather & Streamflow Explorer"),
        
        selectInput("countries", 
                    "Select country", 
                    list("Germany", "US", "Switzerland")),
        plotlyOutput(outputId = "histCentile", height = 200),
        plotOutput("scatterCollegeIncome", height = 250)
      )
    )
  ),
  
  tabPanel(
    "Data explorer",
    
    fluidRow(
      column(3,
             selectInput("select_countries", 
                         "Countries", 
                         choices = list("Germany", "Switzerland"), 
                         selected = "Germany",
                         multiple=TRUE)
      )
    ),
    hr(),
    DT::dataTableOutput("ziptable")
  ),
  
  #conditionalPanel("false", icon("crosshair"))
)
