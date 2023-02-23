#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)

shinyServer(function(input, output, session) {

  obs <- reactiveVal(0)
  trials <- reactiveVal(0)
  
  observeEvent(input$n, {
    obs(rbinom(50000, size = input$n, prob =0.5))
  })
  
  observeEvent(input$sim1, {
    trials(trials() + 1)
  })
  
  observeEvent(input$sim100, {
    trials(trials() + 100)
  })
  
  observe({
    req(input$n)
    updateSliderInput(session, inputId = "RR", max = input$n)
  })
    
  observeEvent(input$reset, {
    trials(0)
  })
  
  output$distPlot <- renderPlot({
    
    x <- 0:input$n 
    plot(x, 
         dbinom(x, size = input$n, prob = 0.5), 
         lwd = 2, 
         main = "PMF of Y = # of Heads", 
         xlab = "y", 
         ylab = "p(y)",
         type = "h")

  })
  
  output$data <- renderDataTable({
    if(trials() == 0){
      data.frame(y = vector("numeric"))
    } else {
      data.frame(y = obs()[1:(trials())])
    }
  }, options = list(pageLength = 25))

  output$prop <- renderText({
    sum_reject = sum((obs()[1:(trials())] <= input$RR[1]) | (obs()[1:(trials())] >= input$RR[2]))
    total <- trials()
                     
    paste0("The proportion of observations less than or equal to ", 
           input$RR[1], 
           " and greater than or equal to ", 
           input$RR[2], 
           " is ", 
           sum_reject, 
           "/", 
           total, 
           " = ", 
           round(sum_reject/total, 4))
  })
})
