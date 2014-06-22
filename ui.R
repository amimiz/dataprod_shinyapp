library(shiny)

shinyUI(pageWithSidebar(
    headerPanel("Upload, pre-process and visualize"),
    
    sidebarPanel(
        fileInput('file1', 'Upload CSV file with names in the first row and then type (N, F) in the second row',
                  accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
        
        radioButtons("task", "How do you want to handle missing values and plots:",
                     list("Fill Missing values"="missing",
                          "View plots"="plot")),
        
        conditionalPanel(condition="input.task=='missing'",
                         selectInput("imputemethod", "Method",
                                     list("central", "knn"))),
        
        conditionalPanel(condition="input.imputemethod=='knn'",
                         
                         selectInput("metric", "Metric to use",
                                     list("weighAvg", "median"))
                         
        ),
        
        conditionalPanel(condition="input.task=='plot'",
                         selectInput("attributes", "Attributes",
                                     list("-select-"))),
        
        br(),
        br(),
        p("View source on",
          a("github", 
            href = "https://github.com/ss6012/dataprod_shinyapp")),
        p("Visit", 
          a("this page", href = "https://github.com/ss6012/Slidify-Doc-Shiny-App"), "for documentation")
        
    ),
    
    ### output
    
    mainPanel(
        
        tabsetPanel(
            tabPanel("Summary", 
                     h4("Summary"),                     
                     verbatimTextOutput("summaryRaw"), 
                     h4("Structure"),
                     verbatimTextOutput("strRaw")
            ), 
            tabPanel("Missing Values", 
                     h4("Distribution of missing values"),
                     plotOutput("aggr"),
                     h4("Summary with missing values"),
                     verbatimTextOutput("originalsummary"), 
                     h4("Summary after imputation"),
                     verbatimTextOutput("summaryImp")
            ), 
            tabPanel("Plot", 
                     plotOutput("plots"))
        )
    )
    
    
))