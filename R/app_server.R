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
  mod_binder_server("binder_main", con = con, pg="main")
  mod_binder_server("binder_attrib", con = con, pg="attrib")
  # --- Link to specific panels via ?tab=about / ?tab=pm / ?tab=dp ----
  observe({
    query <- parseQueryString(session$clientData$url_search)
    tab <- query[["tab"]]

    # Only allow known tabs
    valid_tabs <- c("about", "pm", "dp")

    if (!is.null(tab) && tab %in% valid_tabs) {
      bslib::nav_select(
        id       = "main_nav",  # must match page_navbar(id = ...)
        selected = tab,
        session  = session
      )
    }
  })
}
