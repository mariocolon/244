##############################
#National Parks Visitation App 
##############################

library(tidyverse)
library(shiny)
library(readr)

nps_visit <- read_csv("Downloads/244/Lab_1/np_visit.csv")
View(np_visit)



#ca_np <- np_visit %>% 
  #filter(state == "CA" & type == "National Park") 

all_nps <- nps_visit %>% 
  filter(type == "National Park" | type == "National Monument") %>% 
  arrange(state)

all_nps$state <- as.factor(all_nps$state)

ui <- fluidPage(
  titlePanel("CA NP Visitation"),
  sidebarLayout(
    sidebarPanel(
      
      selectInput("state","State:", choices = unique(all_nps$state)),
      sliderInput(inputId = "Year",
                  label = "Year",
                  min = 1950,
                  max = 2916,
                  value = 2016)
    ), 
    
    mainPanel(
      plotOutput(outputId = "distPlot")
    )
    
  )
  
  
)

server <- function(input,output) {
  
  output$distPlot <- renderPlot({
    
    x <- all_nps$visitors
    Year <- input$Year
    pick_state <- input$state
    
    ggplot(subset(all_nps, year == Year & state == pick_state), aes(x= park_name, y = visitors)) +
      geom_col(aes(fill = park_name)) +
      coord_flip()
    
  })
}



shinyApp(ui, server)
