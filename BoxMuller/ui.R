library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Método de Box Muller"),
  h5("Generación de números aleatorios a partir de dos distribuciones normales:"),
  br(),
  h4("R²    = -2*log(U1)"),
  h4("theta = 2*pi*U2"),
  h4("x     = R*cos(theta)"),
  h4("y     = R*sin(theta)"),
  

  sidebarLayout(
    sidebarPanel(
      
      br(),
      
      sliderInput("n", 
                  "Numero de puntos a generar:", 
                  value = 500,
                  min = 2, 
                  max = 1000)
    ),
    

    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Histograma", plotOutput("plot")), 
                  tabPanel("Estadísticas generales", verbatimTextOutput("summary")), 
                  tabPanel("Tabla de valores", tableOutput("table"))
      )
    )
  )
))
