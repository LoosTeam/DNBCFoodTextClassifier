#' attrib_bar_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_attrib_bar_plot_ui <- function(id) {
  ns <- NS(id)
  tagList(
    plotOutput(ns("barplot"))
  )
}

#' attrib_bar_plot Server Functions
#'
#' @noRd
mod_attrib_bar_plot_server <- function(id, user_options, con, label){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    barplot_data <- reactive({
      attribution_data(con = con,
                       classif_type = user_options$classif_type(),
                       food_category = user_options$food_category())
    })

    generate_barplot <- function(barplot_data, target_label) {
      barplot_data_mod <- barplot_data %>%
        dplyr::filter(label==target_label) %>%
        dplyr::arrange(attribution) %>%
        dplyr::top_n(10) %>%
        dplyr::mutate(label= as.character(label))

      title <- if (label == 1) {
        "Token attributions for class 'Positive'"
      } else {
        "Token attributions for class 'Negative'"
      }

      p <- ggplot2::ggplot(barplot_data_mod,
                           ggplot2::aes(x = attribution,
                                        y = reorder(input, attribution),
                                        fill = label,
                                        label = round(attribution, digits = 3))) +
        ggplot2::geom_bar(
          stat = "identity",
          alpha = 0.6,
          color = "black"
        ) +
        ggplot2::scale_fill_manual(
          values = c("1" = "#ff7f0e", "0" = "#1f77b4")
        ) +
        geom_text(
          size = 4,
          # position = position_dodge(width = 2, orientation = "y"),
          stat = "identity",
          hjust = 1.2
        ) +
        ggplot2::labs(
          x = "Attribution score",
          y = "Top 10 tokens",
          title = title
        ) +
        ggplot2::theme_minimal(base_size = 12) +
        ggplot2::theme(
          plot.title = ggplot2::element_text(face = "bold", size = 12),
          axis.text.y = ggplot2::element_text(face = "bold", size = 12),
          legend.position="none"
        )
      return(p)

    }

    output$barplot <- renderPlot({
      generate_barplot(barplot_data = barplot_data(), target_label = label)
    })

  })
}

## To be copied in the UI
# mod_attrib_bar_plot_ui("attrib_bar_plot_1")

## To be copied in the server
# mod_attrib_bar_plot_server("attrib_bar_plot_1")
