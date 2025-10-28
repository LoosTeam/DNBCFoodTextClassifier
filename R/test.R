
# Basic usage
library("shiny")
library(shinyWidgets)

ui <- fluidPage(
  virtualSelectInput(
    inputId = "id",
    label = "Select:",
    choices = list(
      "Spring" = c("March", "April", "May"),
      "Summer" = c("June", "July", "August"),
      "Autumn" = c("September", "October", "November"),
      "Winter" = c("December", "January", "February")
    ),
    showValueAsTags = TRUE,
    search = TRUE,
    multiple = F
  )
)

server <- function(input, output) {
  output$value <- renderPrint(input$somevalue)
}

shinyApp(ui, server)


# jkfndv ------------------------------------------------------------------

shinyWidgetsGallery()
