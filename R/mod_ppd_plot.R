#' ppd_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_ppd_plot_ui <- function(id) {
  ns <- NS(id)
  tagList(
    plotOutput(ns("ppd_plot"))
  )
}

#' ppd_plot Server Functions
#'
#' @noRd
mod_ppd_plot_server <- function(id, user_options, con){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    ppd_data <- reactive({
      prediction_data(con = con,
                      classif_type = user_options$classif_type(),
                      food_category = user_options$food_category())
    })

    generate_ppd_plot <- function(pred_data) {

      roc_obj <- pROC::roc(pred_data$true_label_factor, pred_data$predicted_value_1, levels = c("Negative", "Positive"))
      auc_val <- pROC::auc(roc_obj)

      p <- ggplot2::ggplot(pred_data, ggplot2::aes(x = predicted_value_1, fill = true_label_factor)) +
        ggplot2::geom_histogram(
          position = "identity",
          alpha = 0.6,
          color = "black",
          bins = 30
        ) +
        ggplot2::scale_fill_manual(
          values = c("Negative" = "#1f77b4", "Positive" = "#ff7f0e"),
          labels = paste0(c("Negative", "Positive"), " (n=", table(pred_data$true_label_factor), ")")
        ) +
        ggplot2::labs(
          x = "Predicted probability for class 'Positive'",
          y = "Frequency",
          title = "Prediction Score Distribution"
        ) +
        # ggplot2::annotate(
        #   "text",
        #   x = 0.95,
        #   y = max(table(cut(pred_data$predicted_value_1, breaks = 30))),
        #   label = paste0("AUC: ", round(auc_val, 4)),
        #   hjust = 1, vjust = 1,
        #   size = 5,
        #   fontface = "bold",
        #   color = "black"
        # ) +
        ggplot2::theme_minimal(base_size = 12) +
        ggplot2::theme(
          plot.title = ggplot2::element_text(face = "bold", size = 12),
          legend.title = ggplot2::element_blank(),
          legend.position="bottom"
        )

      return(p)
    }

    output$ppd_plot <- renderPlot({
      generate_ppd_plot(pred_data = ppd_data())
      })

  })
}

## To be copied in the UI
# mod_ppd_plot_ui("ppd_plot_1")

## To be copied in the server
# mod_ppd_plot_server("ppd_plot_1")
