library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Tabsets"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons("method", "Method:",
                   c("MonteCarlo" = "mont",
                     "Riemann" = "riem",
                     "Trapecio" = "trap")),
      br(),
      
      sliderInput("n", 
                  "Points:", 
                  value = 2,
                  min = 0, 
                  max = 1000),
      sliderInput("from", 
                  "From:", 
                  value = -2,
                  min = -2, 
                  max = 10),
      sliderInput("to", 
                  "To:", 
                  value = 2,
                  min = 1, 
                  max = 100),
      numericInput("num", label = h3("Dimensiones"), 
                   value = 1)
    ),

    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Integration", verbatimTextOutput("summary")), 
                  tabPanel("Plot", plotOutput("plot")), 
                  tabPanel("Table", tableOutput("table")),
                  tabPanel("Error", plotOutput("error"))
      )
    )
  )
))