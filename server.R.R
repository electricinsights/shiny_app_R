# Load libraries
library(shiny)
library(tidyverse)

# Read in data
# Replace "adult.csv" with your actual file path
adult <- read_csv("adult.csv")
# Convert column names to lowercase for convenience 
names(adult) <- tolower(names(adult))

# Define server logic
shinyServer(function(input, output) {
  
  df_country <- reactive({
    adult %>% filter(native_country == input$country)
  })
  
  # TASK 5: Create logic to plot histogram or boxplot
  output$p1 <- renderPlot({
    if (input$graph_type == "histogram") {
      # Histogram
      ggplot(df_country(), aes_string(x = input$continuous_variable)) +
        geom_histogram() +
        labs(x = input$continuous_variable,
             y = "Frequency",
             title = "Histogram of Continuous Variable") +
        facet_wrap(~prediction)
    }
    else {
      # Boxplot
      ggplot(df_country(), aes_string(y = input$continuous_variable)) +
        geom_boxplot() +
        coord_flip() +
        labs(y = input$continuous_variable,
             x = "Income Prediction",
             title = "Boxplot of Continuous Variable") +
        facet_wrap(~prediction)
    }
  })
  
  # TASK 6: Create logic to plot faceted bar chart or stacked bar chart
  output$p2 <- renderPlot({
    # Bar chart
    p <- ggplot(df_country(), aes_string(x = input$categorical_variable)) +
      geom_bar() +
      labs(x = input$categorical_variable,
           y = "Count",
           title = "Bar Chart of Categorical Variable") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),
            legend.position = "bottom")
    
    if (input$is_stacked) {
      p + geom_bar(aes(fill = prediction), position = "stack")
    }
    else {
      p + geom_bar(aes(fill = input$categorical_variable), position = "dodge") +
        facet_wrap(~prediction)
    }
  })
})
