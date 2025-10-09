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

    generate_confmat_plot <- function(pred_data, normalize = NULL, title_extra = "") {
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

      library(ggplot2)
      library(ggnewscale)
      library(dplyr)

      p <- ggplot() +
        # --- Negative row ---
        geom_tile(
          data = filter(cm, True == "Negative"),
          aes(x = Pred, y = True, fill = Freq),
          color = "white", linewidth = 0.6
        ) +
        scale_fill_gradient(
          name = "Class 'negative' counts",
          low = "#89b2cf",
          high = "#1f77b4"

        ) +

        # --- Reset fill scale ---
        ggnewscale::new_scale_fill() +

        # --- Positive row ---
        geom_tile(
          data = filter(cm, True == "Positive"),
          aes(x = Pred, y = True, fill = Freq),
          color = "white", linewidth = 0.6
        ) +
        scale_fill_gradient(
          name = "Class 'positive' counts",
          low = "#e8bf9c",
          high = "#ff7f0e"
        ) +

        # --- Labels ---
        geom_text(
          data = cm,
          aes(x = Pred, y = True, label = Label),
          size = 5, fontface = "bold", color = "white"
        ) +

        labs(
          title = title_extra,
          x = "Predicted Label",
          y = "True Label"
        ) +
        theme_minimal(base_size = 12) +
        theme(
          plot.title = element_text(face = "bold", size = 12),
          legend.position = "bottom",
          legend.text = element_text(angle = 45, hjust = 1)
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
