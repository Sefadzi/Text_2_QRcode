# Load packages
packages <- 
  c("shiny",
    "shinythemes",
    "shinyWidgets",
    "shinyalert",
    "qrcode")

if (length(setdiff(packages,rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}

invisible(lapply(packages, library, character.only = TRUE))


ui <- navbarPage(
  title = 'QR CODE GENERATOR',
  windowTitle = 'QR CODE GENERATOR', 
  position = 'fixed-top',
  collapsible = TRUE, 
  theme = shinytheme('cosmo'), 
  #tabPanel(title = 'About'),
  tabPanel(title = 'QR CODE',
           fluidPage(
             sidebarLayout(
               sidebarPanel(
                 style = 'background-color: teal; color: #ffffff;margin-top: 80px;border: 2px solid #D3D3D3; border-radius: 5px;',
                 textAreaInput("txt","Enter text to generate QR code", value = "Data Brew"),
                 selectInput(
                   inputId = 'bg_col',
                   label = 'Choose QR Code Background Color:',
                   choices = c("White","black","blue","red"),
                   selected = 'white'),
                 selectInput(
                   inputId = 'fg_col',
                   label = 'Choose QR Code Foreground Color::',
                   choices = c("White","black","red","blue"),
                   selected = 'black'),
                 br(),
                 br(),
                 h4("Click to generate code:"),
                 #plotOutput("plot")
                 actionBttn(inputId = "get_qr", label = "GENERATE CODE")
               ),
               mainPanel(
                 
                 wellPanel(
                   style = 'background-color: #F8F8F8; color:#505050;border-radius: 5px;margin-top: 80px;',
                   h4('QR CODE'),
                   plotOutput("qr")
                 )
                 
                 #DTOutput("transactions")
               )
             )
           ))
  
)

server <- function(input, output, session){
  
  
  observeEvent(input$get_qr, {
    output$qr = renderPlot({
      out = isolate(qrcode_gen(input$txt, dataOutput = TRUE))
      bgc = isolate(input$bg_col)
      fgc = isolate(input$fg_col)
      
      
      heatmap(out[nrow(out):1, ], Rowv = NA,Colv = NA, scale = "none", 
              col = c(bgc, fgc),
              labRow = "", labCol = "")
     
    })
  })
  
}



shinyApp(ui, server)