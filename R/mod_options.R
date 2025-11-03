#' options UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_options_ui <- function(id, pg = c("main", "attrib")) {
  ns <- NS(id)
  tagList(
    if (pg == "main"){
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
          label = "Select one or more food categories",
          choices = NULL,
          selected = NULL,
          multiple = TRUE,
          selectize = TRUE,
          width = NULL,
          size = NULL
        )
      )
    } else if (pg == "attrib"){
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
      updateSelectInput(
        session = session,
        inputId = "select_type",
        choices = unique(categories$type)
      )
    })

    observe({
      req(input$select_type)
      filtered <- categories %>%
        dplyr::filter(type == input$select_type)
      if (input$select_type == "Major Categories"){
        filtered_list <- filtered %>%
          pull(name_exp)
      } else if (input$select_type == "Sub-Categories") {
        filtered_list <- filtered %>%
          dplyr::select(name_exp,broad_categ) %>%
          dplyr::group_by(broad_categ) %>%
          dplyr::summarise(items = list(name_exp)) %>%
          tibble::deframe() %>%
          lapply(as.list)
      }

      updateSelectInput(
        session = session,
        inputId = "select_category",
        choices = filtered_list

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
