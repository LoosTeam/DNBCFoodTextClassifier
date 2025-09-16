#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  con <- db_connect()

  # pass `con` to modules
  # mod_my_module_server("my_module_1", con = con)
  # mod_options_server("options_1", con = con)
  mod_binder_server("binder_1", con = con)
}
