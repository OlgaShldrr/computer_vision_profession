library(shiny)
library(reticulate)
library(waiter)
#py_install("imageai")
#py_install("tensorflow")
# Define UI for data upload app ----
ui <-   function(req){
  fluidPage(
    use_waitress(),
    # App title ----
  titlePanel("Predict Profession"),
  
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
      h1("First level title"),
      h2("Second level title"),
     
      
      
      # Horizontal line ----
      tags$hr(),
      
      # Input: Select number of rows to display ----
      h3("Third level title")
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      img(src='myImage.png', align = "center"), 
      # Output: Data file ----
      textOutput("contents"),
      imageOutput("image")
     
      
    )
    
  )
)
}


# Define server logic to read selected file ----
server <- function(input, output){
  
 # onStop
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
 # observeEvent(!is.null(input$file1),{
 #   # call the waitress
 #   waitress <- Waitress$
 #     new(theme = "overlay-percent")$
 #     start() # start
 #   
 #   for(i in 1:30){
 #     waitress$inc(1) # increase by 10%
 #     Sys.sleep(.3)
 #   }
 #   
 #   # hide when it's done
 #   waitress$close() 
 #   
 #  	})
   
  waitress <- Waitress$new("#contents", hide_on_render = TRUE) 	
  
  output$contents <- renderText({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$file1)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    #image_path = input$file1$datapath
    waitress$start()
    for(i in 1:10){
      waitress$inc(0.5) # increase by 10%
      Sys.sleep(.3)
    }
    
    assign(x = "image_path", value = input$file1$datapath, envir = .GlobalEnv)
    source_python("predicting.py")
    print(var)
    
    
    
  })    
   
  output$image <- renderImage({
    # A temp file to save the output.
    # This file will be removed later by renderImage
    req(input$file1)
    
    # Generate the PNG
    
    
    # Return a list containing the filename
    list(src = input$file1$datapath,
         contentType = 'image/png',
         alt = "This is alternate text")
  }, deleteFile = FALSE)

  png()
  dev.off()



}


# Create Shiny app ----
shinyApp(ui, server)

