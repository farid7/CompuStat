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
    aux <- vector()
    
    while (cnt < input$num){
      cnt <- cnt+1
      result <- result*integral(input$n, input$from, input$to)
      aux <- append(aux, result)
    }
    ###
    aux
  })
 #########################################
  output$summary <- renderPrint({
    paste(tail(data(), n=1), input$num, length(data()))
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
   mont <- function(x, from, to) {
     #to2 <- max(f(seq(from, to)))
     to2 <- 1/(to-from)
     
     u1 <- runif(x, min(from, to), max(from, to))
     u2 <- runif(x, min(from, to2), max(from, to2))
     
     res <- sum(f(u1) > u2)/x * ((to-from)*(to2))
     
     result <- 1
     cnt <- 0
     aux <- vector()
     
     while (cnt < input$num){
       cnt <- cnt+1
       result <- result*res
       aux <- append(aux, result)
     }
     
     return (aux)
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
     
     res <- 1
     cnt <- 0
     aux <- vector()
     while (cnt < input$num){
       cnt <- cnt+1
       res <- res*area
       aux <- append(aux, res)
     }
     return (aux)
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
     
     result <- 1
     cnt <- 0
     aux <- vector()
     while (cnt < input$num){
       cnt <- cnt+1
       result <- result * area
       aux <- append(aux, result)
     }
     return (aux)
   }
   ######
   N <- seq(1, input$num)
   eReal <- (f(2)- f(-2))^2
   
   par(mfrow = c(2,1))
   plot(N, rep(eReal, input$num), type = "l", main = paste("Estimador"))
   lines(N, mont(input$n, input$from, input$to), col = "blue")
   lines(N, trap(input$n, input$from, input$to), col = "red")
   lines(N, riem(input$n, input$from, input$to), col = "green")
   ###
   plot(N, mont(input$n, input$from, input$to)-eReal, col = "blue", type = "l", ylim = c(0,1), main = "Error")
   lines(N, trap(input$n, input$from, input$to)-eReal, col = "red")
   lines(N, riem(input$n, input$from, input$to)-eReal, col = "green")
    })
})
