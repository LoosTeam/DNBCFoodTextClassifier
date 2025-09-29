#' confmat_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_confmat_plot_ui <- function(id) {
  ns <- NS(id)
  tagList(
    plotOutput(ns("confmat_plot"))
  )
}

#' confmat_plot Server Functions
#'
#' @noRd
mod_confmat_plot_server <- function(id, user_options, con){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    confmat_data <- reactive({
      prediction_data(con = con,
                      classif_type = user_options$classif_type(),
                      food_category = user_options$food_category())
    })

    generate_confmat_plot <- function(pred_data, normalize = "True", title_extra = "") {
      pred_data <- pred_data %>%
        dplyr::mutate(
          pred_class = ifelse(predicted_value_1 > predicted_value_0, "Positive", "Negative")
        )

      cm <- as.data.frame(table(True = pred_data$true_label_factor,
                                Pred = pred_data$pred_class))

      if (!is.null(normalize)) {
        cm <- cm %>%
          dplyr::group_by(!!dplyr::sym(normalize)) %>%
          dplyr::mutate(Prop = Freq / sum(Freq)) %>%
          dplyr::ungroup()
      } else {
        cm <- cm %>% dplyr::mutate(Prop = Freq)
      }

      cm <- cm %>%
        dplyr::mutate(Label = if (!is.null(normalize)) {
          scales::percent(Prop, accuracy = 0.01)
        } else {
          as.character(Freq)
        })


      if (title_extra == "") {
        title_extra <- ifelse(is.null(normalize), "Confusion Matrix", "Normalized Confusion Matrix")
      }

      p <- ggplot2::ggplot(cm, ggplot2::aes(x = Pred, y = True, fill = Prop)) +
        ggplot2::geom_tile(color = "white", linewidth = 0.6) +
        ggplot2::geom_text(ggplot2::aes(label = Label), size = 5, fontface = "bold", color = "white") +
        ggplot2::scale_fill_gradient(low = "#1f77b4", high = "#ff7f0e") +
        ggplot2::labs(
          title = title_extra,
          x = "Predicted Label",
          y = "True Label",
          fill = ifelse(is.null(normalize), "Count", "Proportion")
        ) +
        ggplot2::theme_minimal(base_size = 12) +
        ggplot2::theme(
          # axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
          plot.title = ggplot2::element_text(face = "bold", size = 12),
          legend.position="bottom",
          legend.text = ggplot2::element_text(angle = 45, hjust = 1)
        )

      return(p)
    }

    output$confmat_plot <- renderPlot({
      generate_confmat_plot(pred_data = confmat_data())
    })

  })
}

## To be copied in the UI
# mod_confmat_plot_ui("confmat_plot_1")

## To be copied in the server
# mod_confmat_plot_server("confmat_plot_1")
