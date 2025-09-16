#' binder UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_binder_ui <- function(id) {
  ns <- NS(id)
  tagList(
    col_4(
      mod_options_ui(ns("user_options"))
    ),
    col_8(
      mod_ppd_plot_ui(ns("ppd_plot_1"))
      )
  )
}

#' binder Server Functions
#'
#' @noRd
mod_binder_server <- function(id, con){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    mod_options_server("user_options", con=con)
    user_options <- mod_options_server("user_options", con=con)

    mod_ppd_plot_server("ppd_plot_1", user_options = user_options, con = con)

  })
}

## To be copied in the UI
# mod_binder_ui("binder_1")

## To be copied in the server
# mod_binder_server("binder_1")
