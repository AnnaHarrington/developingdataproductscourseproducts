library(shiny)
library(shinythemes)
library(dplyr)
library(data.table)
library(readxl)


ui <- fluidPage(
    fluidPage(theme = shinytheme("slate"),
              titlePanel("Converter for OIHP files to make Uploadable to SmartData"),
              sidebarLayout(
                  sidebarPanel(
                      
                      fileInput('oipinput', 'Upload OIHP File',
                                multiple = FALSE,
                                accept=c('text/csv', 
                                         'text/comma-separated-values,text/plain', 
                                         '.csv', '.oip')),
                      tags$hr(),
                      downloadButton('downloadoipdata', 'Download reformatted OIHP file')
                  ),
                  
                  mainPanel(
                      textOutput('contents')
                  )
              )
    )
)

server <- function(input, output) {
    getoip <- reactive({
        oip <- read.delim(input$oipinput$datapath, header=TRUE)
        names(oip) <- c("Depth (ft)", "EC (mS/m)", "ROP (ft/min)", "Depth (m)", "ROP (m/min)", "Detector 3 Max (uV)", "Frames Per Second ()", "Optical Power (mA)")
        return(oip)
       
        })
            output$contents <- renderText({paste("You have uploaded ", input$oipinput)})
    
    output$downloadoipdata <- downloadHandler(
        filename = function() {
            paste("SDoiptomipformat.mhp")
        },
        content = function(file) {
            write.table(getoip(), file, sep = '\t', quote = FALSE, row.names=FALSE)
              }
    )
}

shinyApp(ui = ui, server = server)