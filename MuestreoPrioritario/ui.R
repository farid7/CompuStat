library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Método de función inversa"),
  h5("Creación de distribución exponencial:"),

  sidebarLayout(
    sidebarPanel(
      radioButtons("dist", "Tipo de distribución:",
                   c( #"Uniform" = "unif",
                     "Exponential" = "exp")),
      br(),
      
      sliderInput("n", 
                  "Numero de puntos a generar:", 
                  value = 5,
                  min = 1, 
                  max = 1000),
      
      sliderInput("lambda", 
                  "Valor lambda para la distribución exponencial:", 
                  value = 5,
                  min = 0.01, 
                  max = 10)
    ),
    

    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Plot", plotOutput("plot")), 
                  tabPanel("Summary", verbatimTextOutput("summary"), verbatimTextOutput("summary2")), 
                  tabPanel("Table", tableOutput("table"), tableOutput("table2"))
      )
    )
  )
))
