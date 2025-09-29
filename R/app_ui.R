#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny bslib
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    bslib::page_navbar(
      title = "DNBCFoodTextClassifier",
      # theme = bslib::bs_theme(bootswatch = "flatly"),  # pick any Bootswatch theme you like
      navbar_options = bslib::navbar_options(
        underline = TRUE
      ),
      bslib::nav_spacer(),
      bslib::nav_panel(
        title = "Main",
          mod_binder_ui("binder_main", pg="main")
      ),

      bslib::nav_panel(
        title = "Attrib",
          mod_binder_ui("binder_attrib", pg="attrib")
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "DNBCFoodTextClassifier"
    )#,
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
    # tags$link(
    #   rel="stylesheet",
    #   type="text/css",
    #   href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css",
    #   integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH",
    #   crossorigin="anonymous"
    # ),
    # tags$script(
    #   src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js",
    #   integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz",
    #   crossorigin="anonymous"
    # ),
    # tags$link(
    #   rel="stylesheet",
    #   type="text/css",
    #   href="www/styles.css"
    # ),
    # tags$script(src="www/main.js")
  )
}
