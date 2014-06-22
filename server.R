library(VIM)
library(ggplot2)
library(DMwR)

shinyServer(function(input, output,clientData, session) {
    
    ## reading data and converting categorical into factors
    dataset<-reactive({
        inFile <- input$file1
        if(!is.null(inFile$datapath))
        {
            dataset=read.csv(inFile$datapath, header=T, sep=',')
            
            v <- as.vector(t(dataset[1,]))
            dataset=dataset[-1,]
            
            for (i in 1:length(v)){
                if (v[i] == "N") {dataset[,i] <- as.numeric(dataset[,i])}
                else {dataset[,i] <- as.factor(dataset[,i])}
            }
            dataset
        }
    })
    
    ##################### summary output ####################################################
    output$strRaw <- renderPrint({
        str(dataset())
    })
    
    output$summaryRaw <- renderPrint({
        summary(dataset())
    })
    
    ######################################################################
    
    ##################### imputation output #################################################
    impDataset<-reactive({
        
        if(input$imputemethod=="central")
        {
            datasetImp <- centralImputation(dataset())
        }else
        {
            datasetImp <- knnImputation(dataset(), 
                                        k=10, 
                                        meth="input$metric")
        }
        
        
    })
    
    output$aggr <- renderPlot({
        
{
    aggr(dataset())
}

    })
output$originalsummary <- renderPrint({
    summary(dataset())
})
output$summaryImp <- renderPrint({
    summary(impDataset())
})




#####################################################################################  

######################## plots output ################################################


observe({
    if(input$task=="plot"& !is.null(dataset()))
    {
        updateSelectInput(session=session,
                          inputId="attributes",
                          choices=names(dataset()))
    }
    
})

output$plots <- renderPlot({
    
    df=data.frame(dataset())
    
    if (class(df[,input$attributes])=="factor")
    {
        
        
        p<-ggplot(df,aes_string(x=input$attributes))+
            geom_bar(aes(fill=loan),position="dodge")+theme_bw()            
        print(p)
        
    }else
    {
        p<-ggplot(df,aes_string(x=input$attributes))+
            geom_histogram(aes(fill=..count..))+theme_bw()    
        
        print(p)
    }
    
})


})