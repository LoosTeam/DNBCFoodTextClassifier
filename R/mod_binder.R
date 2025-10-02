#' binder UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import bslib
mod_binder_ui <- function(id, pg = c("main","attrib")) {
  ns <- NS(id)
  tagList(
    if (pg == "main") {
      bslib::layout_sidebar(
        sidebar = bslib::sidebar(
          mod_options_ui(ns("user_options"), "main")
        ),
        bslib::page_fluid(
          bslib::layout_columns(
            min_height = "750px",
            mod_scatter_plot_ui(ns("scatter_plot_1"))
          )
        )

      )
    } else if (pg == "attrib"){
      bslib::layout_sidebar(
        sidebar = bslib::sidebar(
          mod_options_ui(ns("user_options"), "attrib")
        ),
        bslib::page_fluid(
          bslib::layout_columns(
            col_widths = c(6, 6, 6, 6),
            min_height = "200px",
            mod_ppd_plot_ui(ns("ppd_plot_1")),
            mod_confmat_plot_ui(ns("confmat_plot_1")),
            mod_roc_curve_plot_ui(ns("roc_curve_plot_1")),
            mod_pr_curve_plot_ui(ns("pr_curve_plot_1"))
          )
        )

      )
    }
  )
}

#' binder Server Functions
#'
#' @noRd
mod_binder_server <- function(id, con, pg){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    if (pg == "main") {

      mod_options_server("user_options", con=con)
      user_options <- mod_options_server("user_options", con=con)
      mod_scatter_plot_server("scatter_plot_1", user_options = user_options, con = con)

    } else if (pg == "attrib") {
      mod_options_server("user_options", con=con)
      user_options <- mod_options_server("user_options", con=con)


      mod_ppd_plot_server("ppd_plot_1", user_options = user_options, con = con)
      mod_confmat_plot_server("confmat_plot_1", user_options = user_options, con = con)
      mod_roc_curve_plot_server("roc_curve_plot_1", user_options = user_options, con = con)
      mod_pr_curve_plot_server("pr_curve_plot_1", user_options = user_options, con = con)
    }
  })
}

## To be copied in the UI
# mod_binder_ui("binder_1")

## To be copied in the server
# mod_binder_server("binder_1")
