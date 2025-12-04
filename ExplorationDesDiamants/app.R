library(dplyr)
library(shiny)
library(ggplot2)
library(DT)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Exploration des Diamants"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          radioButtons(inputId = "rose", 
                       label = "Colorier les points en rose ?",
                       choices = c("Oui", "Non")),
          selectInput(inputId = "couleur",
                      label = "Choisir une couleur à filtrer :",
                      choices = c("D", "E", "F", "G", "H", "I", "J")),
          sliderInput(inputId = "prix",
                      label = "Prix maximum :",
                      min = 3000,
                      max = 20000,
                      value = 3000),
          actionButton(inputId = "visugraph",
                       label = "Visualiser le graph"
          )
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- diamonds[, 3]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
