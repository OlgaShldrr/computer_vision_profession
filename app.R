library(shiny)
library(reticulate)
library(lubridate)
# Define UI for data upload app ----
ui <- function(req) {
  fluidPage(
  
  # App title ----
  titlePanel("Uploading Files"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Select a file ----
      fileInput("file1", "Upload an image",
                multiple = FALSE),
      
      # Horizontal line ----
      tags$hr(),
      
      # Input: Checkbox if file has header ----
      checkboxInput("header", "Header", TRUE),
      
      # Input: Select separator ----
      radioButtons("sep", "Separator",
                   choices = c(Comma = ",",
                               Semicolon = ";",
                               Tab = "\t"),
                   selected = ","),
      
      # Input: Select quotes ----
      radioButtons("quote", "Quote",
                   choices = c(None = "",
                               "Double Quote" = '"',
                               "Single Quote" = "'"),
                   selected = '"'),
      
      # Horizontal line ----
      tags$hr(),
      
      # Input: Select number of rows to display ----
      radioButtons("disp", "Display",
                   choices = c(Head = "head",
                               All = "all"),
                   selected = "head")
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Data file ----
      imageOutput("image"),
      textOutput("contents")
      
    )
    
  )
)
}

# Define server logic to read selected file ----
server <- function(input, output){
  
  # 1. Trick file date creation update
  onStop(function() {
    
    # 1. File name
    p <- paste0(getwd(), "/app.R")
    
    # 2. Update file 'date creation'
    Sys.setFileTime(p, now())
    
  }) # onStop
#  base64 <- reactive({
#    inFile <- input[["file1"]]
#    if(!is.null(inFile)){
#      dataURI(file = inFile$datapath, mime = "image/png")
#    }
#  })
#  
#  output[["image"]] <- renderUI({
#    if(!is.null(base64())){
#      tags$div(
#        tags$img(src= base64(), width="100%"),
#        style = "width: 400px;"
#      )
#    }
#  })

    # When input$n is 1, filename is ./images/image1.jpeg
    
      
    
  output$image <- renderImage({
    # A temp file to save the output.
    # This file will be removed later by renderImage
    req(input$file1)
    
    # Generate the PNG
    
    
    # Return a list containing the filename
    list(src = input$file1$datapath,
         contentType = 'image/png',
         width = 400,
         height = 300,
         alt = "This is alternate text")
  }, deleteFile = FALSE)

  png(width=400, height=300)
  dev.off()

  output$contents <- renderText({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$file1)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    
  source_python("predicting.py")
  print(var)
 
    
  })

}


# Create Shiny app ----
shinyApp(ui, server)

