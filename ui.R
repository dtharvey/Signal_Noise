# user interface template

library(shiny)
library(shinythemes)

ui = navbarPage("AC 3.0: Signals and Noise",
                theme = shinytheme("journal"),
                header = tags$head(
                  tags$link(rel = "stylesheet", 
                            type = "text/css", 
                            href = "style.css")
                ),
                # user interface for introduction tab
                tabPanel("Introduction",
                  fluidRow(
                   column(width = 6,
                    wellPanel(
                      includeHTML("text/introduction.html")
                             )
                           ),
                      column(
                        width = 6,
                        align = "center",
                        plotOutput("introplot1", height = "700px")        
                           ) # close column
                         ) # close fluidPanel         
                ), # close tabPanel

                tabPanel("Signal-to-Noise Ratio",
                  fluidRow(
                   column(width = 6,
                     wellPanel(
                       includeHTML("text/activity1.html")
                     )    
                         ),
                   column(width = 6, align = "center",
                        sliderInput("spectrum", "spectrum number", 
                                     min = 1, max = 64, step = 1, 
                                     value = 1, width = "250px",
                                     ticks = FALSE),
                      plotOutput("activity1plot", height = "600px")
                          )
                  )       
                  ),
                
                tabPanel("Evaluating the Signal-to-Noise Ratio",
                  fluidRow(
                    column(width = 6,
                      wellPanel(
                       includeHTML("text/activity2.html") 
                        )     
                  ),
                   column(width = 6,
                          align = "center",
                        splitLayout(cellWidths = c("300px", "300px"),
                        sliderInput("sigmult", "signal multiplier",
                                    min = 0.2, max = 2, value = 1,
                                    step = 0.1, width = "250px",
                                    ticks = FALSE),
                        sliderInput("noisemult", "noise multipler",
                                    min = 0.2, max = 5, value = 1,
                                    step = 0.05, width = "250px",
                                    ticks = FALSE)
                        ),
                        
                      plotOutput("activity2plot", height = "600px")
                  )
                  )       
                  ),
                  tabPanel("Signal Averaging",
                    fluidRow(
                      column(width = 6,
                        wellPanel(
                          includeHTML("text/activity3.html")
                  )     
                  ),
                      column(width = 6,
                             align = "center",
                          sliderInput("sigavg", 
                                      "number (n) of spectra to average",
                                      min = 2, max = 36, value = 2, 
                                      width = "50%", ticks = FALSE),
                  plotOutput("activity3plot", height = "650px")
                  )
                  )       
                  ),
                tabPanel("Digital Smoothing",
                  fluidRow(
                    column(width = 6,
                      wellPanel(
                        includeHTML("text/activity4.html")
                  )     
                  ),
                     column(width = 6,
                            align = "center",
                       splitLayout(width = c("125px", "250px", "250px"),
                        radioButtons("filtertype", "type of filter",
                                     choices = c("moving average", 
                                     "savitzky-golay"), width = "100px"),
                        sliderInput("filterspec","spectrum number", min = 1,
                                    max = 64, step = 1, value = 1,
                                    width = "200px", ticks = FALSE),
                        sliderInput("filtersize", "length of filter",
                                    min = 5, max = 25, step = 2, 
                                    value = 5, width = "200px",
                                    ticks = FALSE)
                  ),
                        plotOutput("activity4plot", height = "650px")
                  )
                  )       
                  ),
                tabPanel("Wrapping Up",
                    column(width = 6,
                      wellPanel(id = "wrapuppanel",
                                style = "overflow-y:scroll; max-height: 750px",
                        includeHTML("text/wrapup.html")
                  )     
                  ),
                     column(width = 6,
                            align = "center",
                       downloadButton("spectra", "download spectra"),
                       plotOutput("wrapupplot1", height = "300px"), 
                       plotOutput("wrapupplot2", height = "400px")
                  )
                  
                  )
                
) # close navbarpanel
