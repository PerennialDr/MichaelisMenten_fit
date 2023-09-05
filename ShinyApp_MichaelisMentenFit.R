# install.packages("shiny")
# install.packages("ggplot2")
# install.packages("dplyr")

library(shiny)
library(ggplot2)
library(dplyr)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Michaelis-Menten Fit"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel( 
            textInput('Temperature', 'Assay Temperature (C)', "25"),
            textInput('Rep', 'Replicate', "1"),
            textInput('S', 'Substrate conecentrations (Copied as column)', "0 0.01 0.02 0.05 0.1 0.3 0.5 1 2"),
            textInput('v', 'Reaction rates (Copied as column)', "0 10.97 21.29 44.09 71.83 95.27 96.13 98.92 109.25"),
            textInput('Vmax_Start', 'Starting value for Vmax', "90"),
            textInput('Km_Start', 'Starting value for Km', "0.25"),
            actionButton("Fit", "Fit")
            
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("fitPlot"),
           tableOutput("fitTable"),
           uiOutput("copyFit")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    mmI.df <- reactive(
        data.frame(S = input$S %>% as.character %>% strsplit(split = " ") %>% unlist %>% as.numeric(),
                   v = input$v %>% as.character %>% strsplit(split = " ") %>% unlist %>% as.numeric())
        )
   
    Vmax_start <- reactive(input$Vmax_Start %>% as.numeric())
    Km_start <- reactive(input$Km_Start %>% as.numeric())
    
    output$fitPlot <- renderPlot({
        ggplot(mmI.df(), aes(x = S, y = v)) + 
        geom_point(size = 3) +
        theme_bw()
        
        })
    
    observeEvent(input$Fit, {
        output$fitPlot <- renderPlot({
            ggplot(mmI.df(), aes(x = S, y = v)) + 
                geom_point(size = 3) +
                
                geom_smooth(aes(x = S, y = v), method = "nls",
                            formula = y  ~ Vmax*x/(Km + x),
                            method.args = list(start = list(Vmax = Vmax_start(),
                                                            Km = Km_start())),
                            se = F, lwd = 1,  fullrange=TRUE,
                            show.legend = F) +
                
                theme_bw()
            
        })
    })
    
    
        observeEvent(input$Fit, {
            output$fitTable <- renderTable({
        mmI.nls <- nls(v  ~ Vmax*S/(Km + S), data = mmI.df(),
                       start = list(Vmax = Vmax_start(), Km = Km_start()))
        
        mmI.fit <<- mmI.nls %>% summary %>% .$coeff %>% as.data.frame() %>% 
            mutate(
                Parameter = row.names(.),
                Temperature = input$Temperature, 
                Rep = input$Rep, 
                SE = `Std. Error`,
                p.value = `Pr(>|t|)`,
                LowerLimit_95CI = Estimate  - qnorm(1 - (0.05 / 2)) * SE,
                UpperLimit_95CI = Estimate  + qnorm(1 - (0.05 / 2)) * SE
            ) %>%
            select(Temperature, Rep, Parameter, Estimate, SE, LowerLimit_95CI, UpperLimit_95CI, p.value)
        
       mmI.fit
       
       }) })
        
        
        observeEvent(input$Fit, {
            output$copyFit <- renderUI({
                actionButton("copyFit", label = "Copy Fit") })
        })
        
    observeEvent(input$copyFit, {write.table(mmI.fit, "clipboard", sep = "\t", row.names = F)  })
    
}


# Run the application 
shinyApp(ui = ui, server = server)

