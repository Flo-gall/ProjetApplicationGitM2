library(dplyr)
library(shiny)
library(ggplot2)
library(DT)
library(thematic)
library(bslib)
library(plotly)

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
          plotlyOutput("DiamantsPlot"),
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
        
        observeEvent(input$visugraph, {
          message(showNotification(
            paste0("prix : ", input$prix, " & couleur : ", input$couleur),
            type = "default"
          ))
        })
        
        output$DiamantsPlot <- renderPlotly({
          
          if (is.null(rv$dffiltre)) {
            return()
          }
          
          graph=ggplot(rv$dffiltre, aes(carat, price)) +
            geom_point(color = ifelse(input$rose == "Oui", "pink", "black"))+
            labs(title = paste0("prix : ", input$prix, " & couleur : ", input$couleur), x = "carat", y = "price")
          ggplotly(graph)
        })
        
        output$TabDiamants <- renderDT({
          
          if (is.null(rv$dffiltre)) {
            return()
          }
          rv$dffiltre
        })
            
          
        
}

# Run the application 
shinyApp(ui = ui, server = server)
