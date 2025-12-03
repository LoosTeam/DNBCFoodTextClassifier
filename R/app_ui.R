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
      id = "main_nav",
      title = tagList(
        tags$img(src = "www/icon_final_hex.png", height = "60px"),
        span("DNBCFoodTextClassifier", style = "font-weight: 700;margin-left: 6px;")
      ),
      theme = bslib::bs_theme(
        5,
        preset = "spacelab",
        # navbar_light_bg = "#1189BF", # flatly's success color (teal)
        # navbar_dark_bg = "#2C3E50",   # flatly's primary color (navy)
        # success ="#1189BF"
      ),
      # theme = bslib::bs_theme(bootswatch = "flatly"),  # pick any Bootswatch theme you like
      navbar_options = bslib::navbar_options(
        underline = TRUE,
        # class = "bg-primary",
      ),
      bslib::nav_spacer(),
      bslib::nav_panel(
        title = "About",
        value = "about",
        mod_about_ui("about")
      ),
      bslib::nav_panel(
        title = "Performance Metrics",
        value = "pm",
          mod_binder_ui("binder_main", pg="main")
      ),

      bslib::nav_panel(
        title = "Detailed Plots",
        value = "dp",
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
    )

  )
}
