#' about UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_about_ui <- function(id) {
  ns <- NS(id)
  tagList(
    bslib::page_fluid(
      bslib::layout_columns(
        col_widths = c(3,6,3),
        # min_height = "200px",
        NULL,
          includeMarkdown(system.file("app/www/about1.Rmd",
                                      package = "DNBCFoodTextClassifier")),
          NULL
            # includeMarkdown(system.file("app/www/about2.Rmd", package = "DNBCFoodTextClassifier")),

        ))
    # layout_column_wrap(
    #   width = 1/2,
    #   height = 300,
    #   bslib::card(
    #           card_header(class = "bg-light","About"),
    #           card_body(
    #           includeMarkdown(system.file("app/www/about1.Rmd",
    #                                       package = "DNBCFoodTextClassifier")))
    #           ),
    #   layout_column_wrap(
    #     width = 1,
    #     heights_equal = "row",
    #     bslib::card(
    #             card_header(class = "bg-light","Content"),
    #             card_body(
    #               includeMarkdown(system.file("app/www/about2.Rmd", package = "DNBCFoodTextClassifier")))
    #           ),
    #     bslib::card(
    #             card_header(class = "bg-light","Types of classifications"),
    #             card_body(
    #               includeMarkdown(system.file("app/www/about3.Rmd", package = "DNBCFoodTextClassifier")))
    #           ),
    #     bslib::card(
    #       card_header(class = "bg-light","Technical information"),
    #       card_body(
    #         includeMarkdown(system.file("app/www/about4.Rmd", package = "DNBCFoodTextClassifier")))
    #     )
    #   )
    # )
  )
}

#' about Server Functions
#'
#' @noRd
mod_about_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_about_ui("about_1")

## To be copied in the server
# mod_about_server("about_1")
