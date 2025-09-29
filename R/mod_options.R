#' options UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_options_ui <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(inputId=ns("select_type"),
                 label = "Select a type",
                choices = NULL,#unique(categories$type),
                selected = NULL,
                multiple = FALSE,
                selectize = TRUE,
                width = NULL,
                size = NULL
                ),
    selectInput(
      inputId=ns("select_category"),
      label = "Select a food category",
      choices = NULL,#unique(categories$type),
      selected = NULL,
      multiple = FALSE,
      selectize = TRUE,
      width = NULL,
      size = NULL
    )
  )
}

#' options Server Functions
#'
#' @noRd
mod_options_server <- function(id, con){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    categories <- DBI::dbGetQuery(con, "SELECT * FROM categories;")


    observe({
      # req(input$select_category)
      # cat("User selected food category:", input$select_category, "\n")
      updateSelectInput(
        session = session,
        inputId = "select_type",
        choices = unique(categories$type)
      )
    })

    observe({
      req(input$select_type)
      filtered <- categories %>%
        dplyr::filter(type == input$select_type) %>%
        dplyr::pull(name)
      # cat("input$select_type =", input$select_type, "\n")
      # print(filtered)

      updateSelectInput(
        session = session,
        inputId = "select_category",
        choices = filtered
        # selected = input$select_category
      )
    })


    return(
      list(
        classif_type = reactive({input$select_type}),
        food_category = reactive({input$select_category})
      )
    )
  })
}

## To be copied in the UI
# mod_options_ui("options_1")

## To be copied in the server
# mod_options_server("options_1")
