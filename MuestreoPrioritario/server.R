library(shiny)
require(plyr)

inversa <- function(n, lambda=2){
  return((-1/lambda)*log(1-runif(n, 0, 1)*(1-exp(-2*lambda))))
}

phi <- function(x, m=1) {
  return (m*exp(-2*m*x))
  #return(100*(1-x)^(99))
}

monteCarloCrudo <- function(n, phi=phi, m=1, from=0, to=2, alpha=0.05){
  U <- runif(n, from, 1)
  estimador <- (to-from)*mean(phi(U, m))
  S2 <- var(2*phi(U))
  quantil <- qnorm(alpha/2, lower.tail = FALSE)
  LI <- estimador - quantil*sqrt(S2/n)
  LU <- estimador + quantil*sqrt(S2/n)
  return(data.frame(N=n, LimInf=LI, MonteCarloCrudo=estimador, LimSup=LU))
}

monteCarloPrioritario <- function(n, phi=phi, lambda=0.5, fun=inversa, alpha=0.05){
  X <- inversa(n, lambda)
  estimador <- mean(phi(X)/(dexp(X)/(1-exp(-2*lambda))))
  S2 <- var(phi(X))
  quantil <- qnorm(alpha/2, lower.tail = FALSE)
  LI <- estimador - quantil*sqrt(S2/n)
  LU <- estimador + quantil*sqrt(S2/n)
  return(data.frame(N=n, LimInf=LI, MonteCarlo=estimador, LimSup=LU))
}
#########################################
shinyServer(function(input, output) {
  
  crudo <- reactive({
    ldply(seq(2, input$n), monteCarloCrudo, input$n, m=1, to=2)
  })
  
  prioritario <- reactive({
    ldply(seq(2, input$n), monteCarloPrioritario, input$n, lambda=input$lambda)
  })

  output$plot <- renderPlot({
   par(mfrow=c(2,1))
    ####################
    plot(crudo()$N, crudo()$MonteCarlo, main= paste("Monte Carlo Crudo: "), ylab = "Aproximación por Monte Carlo", xlab="Número de simulaciones",
         ylim = c(-1,1.5), col = "darkgreen")
    abline(h=(1-exp(-2)), untf=FALSE, col = "red")
    lines(crudo()$N, crudo()$LimInf, col="darkgray")
    lines(crudo()$N, crudo()$LimSup, col="darkgray")
    ####################
    plot(prioritario()$N, prioritario()$MonteCarlo, main= paste("Monte Carlo Prioritario: "), ylab = "Aproximación por Monte Carlo", xlab="Número de simulaciones",
         ylim = c(0,1.5), col = "darkgreen")
    abline(h=(1-exp(-2)), untf=FALSE, col = "red")
    lines(prioritario()$N, prioritario()$LimInf, col="darkgray")
    lines(prioritario()$N, prioritario()$LimSup, col="darkgray")
  })
  
  output$summary <- renderPrint({
    summary(crudo())
  })
  output$summary2<- renderPrint({
    summary(prioritario())
  })
  
  output$table <- renderTable({
    data.frame(crudo())
  })
  output$table2 <- renderTable({
    data.frame(prioritario())
  })
  
})

