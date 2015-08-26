library(shiny)

shinyServer(function(input, output) {
  
  data <- reactive({
    (1/input$lambda)*log(1/(1-runif(input$n)))
  })

  output$plot <- renderPlot({
    dist <- input$dist
    n <- input$n
    
    hist(data(), 
         main=paste('r', dist, '(', n, ')', sep=''))
  })
  
  output$summary <- renderPrint({
    summary(data())
  })
  
  output$table <- renderTable({
    data.frame(x=data())
  })
  
})