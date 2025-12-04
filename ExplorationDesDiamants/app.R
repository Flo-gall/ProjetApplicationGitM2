library(dplyr)
library(shiny)
library(ggplot2)
library(DT)
library(thematic)
library(bslib)

thematic_shiny(font = "auto")

ui <- fluidPage(
  theme = bs_theme(
    version = 5,
    bootswatch = "minty"
  ),
  
    titlePanel("Exploration des Diamants"),

    sidebarLayout(
        sidebarPanel(
          radioButtons(inputId = "rose", 
                       label = "Colorier les points en rose ?",
                       choices = c("Oui", "Non")),
          selectInput(inputId = "couleur",
                      label = "Choisir une couleur à filtrer :",
                      choices = c("D", "E", "F", "G", "H", "I", "J"),
                      selected = "D"),
          sliderInput(inputId = "prix",
                      label = "Prix maximum :",
                      min = 3000,
                      max = 20000,
                      value = 5000),
          actionButton(inputId = "visugraph",
                       label = "Visualiser le graph"
          )
        ),

        mainPanel(
          plotOutput("DiamantsPlot"),
          DT::DTOutput(outputId = "TabDiamants")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  
  rv=reactiveValues(df=NULL)
  
        output$DiamantsPlot = renderPlot({
          diamonds|>
            ggplot(aes(diamonds$carat,diamonds$price))+
            geom_point()
        })
}

# Run the application 
shinyApp(ui = ui, server = server)
