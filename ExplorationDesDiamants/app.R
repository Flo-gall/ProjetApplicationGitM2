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

server <- function(input, output) {

  
        rv=reactiveValues(df=NULL)
        
        observeEvent(input$visugraph, {
          rv$dffiltre=diamonds|> 
            filter(price < input$prix & color == input$couleur)
        })
        
        output$DiamantsPlot <- renderPlot({
          
          if (is.null(rv$dffiltre)) {
            return()
          }
          
          ggplot(rv$dffiltre, aes(carat, price)) +
            geom_point(color = ifelse(input$rose == "Oui", "pink", "black"))+
            labs(title = paste0("prix : ", input$prix, "& couleur : ", input$couleur))
        })
            
          
        
}

# Run the application 
shinyApp(ui = ui, server = server)
