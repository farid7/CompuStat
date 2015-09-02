library(shiny)

shinyServer(function(input, output) {
  data <- reactive({
    n <- input$n
    from <- input$from
    to <- input$to
        
    f <- function (x) {4/(1+x^2)}
    g <- function (x) {sqrt(4-x^2)}
    h <- function (x) {6/(sqrt(4-x^2))}
    
    func <- switch(input$func,
                   f = f,
                   g = g,
                   h = h)
    
    to2 <- max(func(seq(from, to)))
    
    u1 <- runif(n, from, to)
    u2 <- runif(n, from, to2)
    
    sum(func(u1) > u2)/n * ((to-from)*(to2-from))
  })
  
  
  output$plot <- renderPlot({
    #plot(runif(input$n, input$from, input$to), runif(input$n, input$from, input$to), xlab = "Uniform1", ylab = "Uniform2")
    #plot(runif(input$n), main="MonteCarlo Integration")
    curve(x^2, input$from, input$to, ylim = c(input$from, input$to))
    points(runif(input$n, input$from, input$to), runif(input$n, input$from, input$to))
  })
  
  output$method <- renderPrint({
    data()
  })
  
  output$table <- renderTable({
    data.frame(x=data())
  })
  
})