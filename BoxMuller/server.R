library(shiny)

shinyServer(function(input, output) {
  
  data <- reactive({
    u1 <- runif((input$n)/2)
    u2 <- runif((input$n)/2)
    x <- sqrt(-2*log(u1))*cos(2*pi*u2)
    y <- sqrt(-2*log(u1))*sin(2*pi*u2)
    
    c(x,y)
    
  })

  output$plot <- renderPlot({
    hist(data(), 
         main=paste('Box Muller'))
  })
  
  output$summary <- renderPrint({
    summary(data())
  })
  ls
  output$table <- renderTable({
    data.frame(x=data())
  })
  
})