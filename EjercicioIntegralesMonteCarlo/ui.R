library(shiny)

shinyUI(fluidPage(  
  titlePanel("Tabsets"),
    sidebarLayout(
    sidebarPanel(
      radioButtons("func", "Function to integrate: ",
                   c ("4/(1+x^2" = "f",
                      "(4-x^2)^(1/2)" = "g",
                      "6/(4-x^2)^(1/2)" = "h")),
      br(),
      
      sliderInput("n", 
                  "Number of random points:", 
                  value = 100,
                  min = 2, 
                  max = 1000),
      
      sliderInput("from", 
                  "initial value of integral:", 
                  value = 0,
                  min = 0, 
                  max = 2),
      
      sliderInput("to", 
                  "final value of integral:", 
                  value = 1,
                  min = 1, 
                  max = 4)
    ),
    
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("MonteCarlo", verbatimTextOutput("method")), 
                  tabPanel("Plot", plotOutput("plot")), 
                  tabPanel("Table", tableOutput("table"))
      )
    )
  )
))
