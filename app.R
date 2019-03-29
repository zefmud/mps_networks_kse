#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(tidyr)
library(networkD3)
library(igraph)
library(stringr)

source("functions.R")
load("mps.Rda")
load("init.Rda")
# Define UI for application that creates networks
ui <- fluidPage(
   
   # Application title
   titlePanel("MPs' networks"),
   
   # Sidebar with a slider and checkboxGroup input
   sidebarLayout(
      sidebarPanel(
         sliderInput("bills_threshold",
                     "Minimal number of shared bills:",
                     min = 1,
                     max = 100,
                     value = 40),
         checkboxGroupInput("factions",
                            label = "Choose factions you want to see:",
                            # 
                            choices = unique(mps$unit_name), 
                            selected = unique(mps$unit_name))
      ),
      
      mainPanel(
          forceNetworkOutput("networkPlot")
      )
   )
)

# Define server logic 
server <- function(input, output) {
   
   output$networkPlot <- renderForceNetwork({
       mps_force_network(filter(init, n >= input$bills_threshold), 
                         filter(mps, mps$unit_name %in% input$factions))
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

