#' scatter_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import dplyr
#' @import plotly
mod_scatter_plot_ui <- function(id) {
  ns <- NS(id)
  tagList(
    plotly::plotlyOutput(ns("scatter_plot"))
  )
}

#' scatter_plot Server Functions
#'
#' @noRd
mod_scatter_plot_server <- function(id, user_options, con){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    scatter_plot_data <- reactive({
      pred_data <- prediction_data(con = con,
                        classif_type = user_options$classif_type())

      metric_data <- metrics_data(con = con,
                    classif_type = user_options$classif_type())

      categ_data <- category_mapper(con = con,
                        classif_type = user_options$classif_type())

      scatter_plot_data <- pred_data %>%
      dplyr::mutate(
        pred_class = ifelse(predicted_value_1 > predicted_value_0, "Positive", "Negative")
      ) %>%
        dplyr::group_by(category_id, true_label_factor, pred_class) %>%
        dplyr::summarise(true_positives = n(), .groups = "drop") %>%
        dplyr::filter(true_label_factor == "Positive", pred_class == "Positive") %>%
        dplyr::select(category_id, true_positives) %>%
        dplyr::full_join(metric_data, by = "category_id") %>%
        dplyr::full_join(categ_data, by = "category_id") %>%
        tidyr::pivot_longer(
        cols = c(mcc, acc, roc_auc_macro, ap_macro),
        names_to = "metric",
        values_to = "value"
      )
      selected_cats <- user_options$food_category()
      if (!is.null(selected_cats) && any(!is.na(selected_cats))) {
        food_categ_ids <- purrr::map(selected_cats, ~ {
          category_mapper(
            con = con,
            classif_type = user_options$classif_type(),
            food_category = .x
          )$category_id
        }) %>%
          unlist() %>%
          unique()

        return(scatter_plot_data %>%
          dplyr::filter(category_id %in% food_categ_ids))
      } else {
        return(scatter_plot_data)
      }
    })

    generate_scatter_plot <- function(scatter_plot_data){
      mean_lines <- scatter_plot_data %>%
        dplyr::group_by(metric) %>%
        dplyr::summarise(mean_value = mean(value, na.rm = TRUE))

      p <- ggplot2::ggplot(scatter_plot_data,
                           ggplot2::aes(x = true_positives,
                                        y = value,
                                        colour = name_exp,
                                        text = text_format_plotly(name_exp,metric,value, true_positives))) +
        ggplot2::geom_point(alpha = 0.7, size = 2) +
        ggplot2::geom_hline(
          data = mean_lines,
          ggplot2::aes(yintercept = mean_value),
          linetype = "dashed",
          color = "grey",
          linewidth = 0.7
        ) +
        ggplot2::ylim(0,1)+
        ggplot2::facet_wrap(~ metric) +
        ggplot2::theme_minimal(base_size = 12) +
        ggplot2::labs(
          x = "True Frequency",
          y = "Metric Value",
          title = "Performance Metrics vs True Positives"
        ) +
        ggplot2::theme(legend.position = "none")
      p_ly <- plotly::ggplotly(p, tooltip = "text") %>%
        plotly::config(modeBarButtonsToRemove = c("zoom2d",
                                                  "zoomIn2d",
                                                  "zoomOut2d",
                                                  "lasso2d",
                                                  "select2d",
                                                  "hoverClosestCartesian",
                                                  "hoverCompareCartesian",
                                                  "pan2d"),
                       displaylogo = FALSE)
      return(p_ly)
    }

    output$scatter_plot <- plotly::renderPlotly({
      generate_scatter_plot(scatter_plot_data = scatter_plot_data())
    })




  })
}

## To be copied in the UI
# mod_scatter_plot_ui("scatter_plot_1")

## To be copied in the server
# mod_scatter_plot_server("scatter_plot_1")
