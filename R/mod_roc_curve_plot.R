#' roc_curve_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_roc_curve_plot_ui <- function(id) {
  ns <- NS(id)
  tagList(
    plotOutput(ns("roc_curve_plot"))
  )
}

#' roc_curve_plot Server Functions
#'
#' @noRd
mod_roc_curve_plot_server <- function(id, user_options, con){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    roc_curve_data <- reactive({
      prediction_data(con = con,
                      classif_type = user_options$classif_type(),
                      food_category = user_options$food_category())
    })

    generate_roc_curve_plot <- function(pred_data){
      roc_obj <- pROC::roc(
        response = pred_data$true_label,       # 0/1 labels
        predictor = pred_data$predicted_value_1
      )
      roc_df <- data.frame(
        fpr = 1 - roc_obj$specificities,
        tpr = roc_obj$sensitivities
      )
      auc_val <- pROC::auc(roc_obj)

      p <- ggplot2::ggplot(roc_df, ggplot2::aes(x = fpr, y = tpr)) +
        ggplot2::geom_line(color = "#1f77b4", size = 1) +
        ggplot2::geom_abline(linetype = "dashed", color = "gray") +
        ggplot2::annotate(
          "text",
          x = 0.95,
          y = 0.2,
          label = paste0("AUC: ", round(auc_val, 4)),
          hjust = 1, vjust = 1,
          size = 5,
          fontface = "bold",
          color = "black"
        ) +
        ggplot2::labs(
          x = "False Positive Rate",
          y = "True Positive Rate",
          title = "ROC Curve"
        ) +
        ggplot2::theme_minimal(base_size = 12) +
        ggplot2::theme(
          plot.title = ggplot2::element_text(face = "bold", size = 12)
        )

      return(p)
    }

    output$roc_curve_plot <- renderPlot({
      generate_roc_curve_plot(pred_data = roc_curve_data())
    })

  })
}

## To be copied in the UI
# mod_roc_curve_plot_ui("roc_curve_plot_1")

## To be copied in the server
# mod_roc_curve_plot_server("roc_curve_plot_1")
