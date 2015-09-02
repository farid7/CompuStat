library(shiny)

shinyServer(function(input, output) {
  f <- function(x) {
    return (sqrt(1/(2*pi))*exp(-0.5*x^2))
    # return (x*x)
  }
  
  data <- reactive({
    mont <- function(x, from, to) {
      #to2 <- max(f(seq(from, to)))
      to2 <- 1/(to-from)
      
      u1 <- runif(x, min(from, to), max(from, to))
      u2 <- runif(x, min(from, to2), max(from, to2))
      
      res <- sum(f(u1) > u2)/x * ((to-from)*(to2))
      return (res)
    } 
    ###
    riem <- function(n, from, to){
      dis <- (to-from)/n
      area <- 0
      i <- from
      while (i <= to){
        i <- i+dis
         area <- area + (dis*f(i))
        }
      
      return (area)
    }
    ###
    trap <- function(x, from, to) {
      h <- (to-from)/x
      area <- 0
      B <- 0
      b <- from
      while(b <= to){
        B <- h+b
        area <- area + 0.5*h*(f(B)+f(b))
        b <- b + h
      }
      return (area)
    }
    ###
    integral <- switch(input$method,
                   mont = mont,
                   riem = riem,
                   trap = trap
                   )
    ####
    result <- 1
    cnt <- 0
    ####
    while (cnt <= input$num){
      cnt <- cnt+1
      result <- result*integral(input$n, input$from, input$to) 
    }
    result
  })
 #########################################
  output$summary <- renderPrint({
    paste(data(), input$num)
  })
 ######################################### 
  output$plot <- renderPlot({
    curve(f(x), input$from, input$to, main = "Distribucion normal")
    points(runif(input$n, -2,2), runif(input$n, -2, 2))
  })
 ###########################################
  output$table <- renderTable({
    data.frame(x=data())
  })
 ##########################################
 output$error <- renderPlot({
   #curve(f(x))
   par(mfrow = c(2,1))
   plot(runif(input$num), type = "l", main = "Error")
   lines(rnorm(input$num), col = "blue")
   plot(rnorm(input$num), type = "l", main = "Estimador")
    })
  
})