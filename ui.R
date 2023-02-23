#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Simulation to Show Error Control"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       actionButton("sim1",
                   "Generate Y = # of heads from 10 flips"),
       br(), br(),
       actionButton("sim100",
                    "Generate 100 Y values"),
       br(),br(),
       h4("For this simulation, we'll consider the null hypothesis that a coin is unbiased (P(Head) = 0.5). You can choose your rejection region below and simulate data under the unbiased coin (null) assumption using the input boxes. "),
       br(),
       h4("You'll see the proportion of time that we falsely reject below (this is the type I error rate, the error probability we generally try to set to a low value). As we do more simulations we will get closer to the probabilities from the associated binomial distribution!"),
       br(),
       numericInput("n", "Choose your sample size", value = 10, min = 3, max = 10000),
       sliderInput("RR", "Select your rejection region (range outside of the slider values but including endpoints):", min = 0, max = 10, value = c(0, 10))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       fluidRow(column(6,plotOutput("distPlot"),        
                       h4("From the simulated values:"),
                       h4(textOutput("prop")),
                       br(),
                       actionButton('reset', "Reset and start over")), 
                column(1), 
                column(5, dataTableOutput("data")))
    )
  )
))
