#' scatter_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_scatter_plot_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tableOutput(ns("mytable"))
  )
}

#' scatter_plot Server Functions
#'
#' @noRd
mod_scatter_plot_server <- function(id, con){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    output$mytable <- renderTable({
      dbGetQuery(con, "SELECT * FROM predictions LIMIT 10;")
    })
  })
}

## To be copied in the UI
# mod_scatter_plot_ui("scatter_plot_1")

## To be copied in the server
# mod_scatter_plot_server("scatter_plot_1")
