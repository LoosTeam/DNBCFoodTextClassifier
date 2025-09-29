#' pr_curve_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_pr_curve_plot_ui <- function(id) {
  ns <- NS(id)
  tagList(
    plotOutput(ns("pr_curve_plot"))
  )
}

#' pr_curve_plot Server Functions
#'
#' @noRd
mod_pr_curve_plot_server <- function(id, user_options, con){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    pr_curve_data <- reactive({
      prediction_data(con = con,
                      classif_type = user_options$classif_type(),
                      food_category = user_options$food_category())
    })

    generate_pr_curve_plot <- function(pred_data){
      pr_df <- pred_data %>%
        arrange(desc(predicted_value_1)) %>%
        mutate(
          tp = cumsum(true_label == 1),
          fp = cumsum(true_label == 0),
          fn = sum(true_label == 1) - tp,
          precision = tp / (tp + fp),
          recall = tp / (tp + fn)
        )
      pr_auc <- sum(diff(pr_df$recall) * zoo::rollmean(pr_df$precision, 2))

      p <- ggplot2::ggplot(pr_df, ggplot2::aes(x = recall, y = precision)) +
        ggplot2::geom_line(color = "#1f77b4", size = 1) +
        ggplot2::ylim(0, 1) + ggplot2::xlim(0, 1) +
        ggplot2::labs(
          x = "Recall (TPR)",
          y = "Precision (PPV)",
          title = "Precision–Recall Curve"
        ) +
        ggplot2::annotate(
          "text",
          x = 0.95,
          y = 0.2,
          label = paste0("AUC: ", round(pr_auc, 4)),
          hjust = 1, vjust = 1,
          size = 5,
          fontface = "bold",
          color = "black"
        ) +
        ggplot2::labs(
          x = "False Positive Rate",
          y = "True Positive Rate"
        ) +
        ggplot2::theme_minimal(base_size = 12) +
        ggplot2::theme(
          plot.title = ggplot2::element_text(face = "bold", size = 12),
        )

      return(p)
    }

    output$pr_curve_plot <- renderPlot({
      generate_pr_curve_plot(pred_data = pr_curve_data())
    })

  })
}

## To be copied in the UI
# mod_pr_curve_plot_ui("pr_curve_plot_1")

## To be copied in the server
# mod_pr_curve_plot_server("pr_curve_plot_1")
