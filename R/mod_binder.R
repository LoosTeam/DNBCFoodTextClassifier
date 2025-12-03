#' binder UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import bslib
mod_binder_ui <- function(id, pg = c("main","attrib")) {
  ns <- NS(id)
  tagList(
    if (pg == "main") {
      bslib::layout_sidebar(
        sidebar = bslib::sidebar(
          mod_options_ui(ns("user_options"), "main")
        ),
        bslib::page_fluid(
          bslib::layout_columns(
            min_height = "200px",
            col_widths = c(6, 6),
            bslib::card(
                        card_header(class = "bg-light","Matthews Correlation Coefficient (MCC)",
                                    tooltip(
                                      bsicons::bs_icon("info-circle"),
                                      "A balanced measure of prediction quality that considers true and false positives and negatives simultaneously. Useful for imbalanced food categories."
                                    )),
                        card_body(
                          mod_scatter_plot_ui(ns("scatter_plot_mcc")))
                        ),
            bslib::card(
              card_header(class = "bg-light","Accuracy",
                          tooltip(
                            bsicons::bs_icon("info-circle"),
                            "The proportion of correct label predictions for a given food category (true positives and true negatives) out of the total number of predictions across all text entries."
                          )),
              card_body(
                mod_scatter_plot_ui(ns("scatter_plot_acc")))
            ),
            bslib::card(
              card_header(class = "bg-light","ROC-AUC",
                          tooltip(
                            bsicons::bs_icon("info-circle"),
                            "Receiver Operating Characteristic – Area Under the Curve (macro-averaged) measures how well the model distinguishes between positive and negative cases for each food category, averaged equally across all food categories."
                          )),
              card_body(
                mod_scatter_plot_ui(ns("scatter_plot_roc")))
            ),
            bslib::card(
              card_header(class = "bg-light","Average Precision (macro-averaged)",
                          tooltip(
                            bsicons::bs_icon("info-circle"),
                            "The area under the precision-recall curve which represents the average precision for a given food category, averaged equally across all food categories."
                          )),
              card_body(
                mod_scatter_plot_ui(ns("scatter_plot_ap")))
            ),

          )
        )

      )
    } else if (pg == "attrib"){
      bslib::layout_sidebar(
        sidebar = bslib::sidebar(
          mod_options_ui(ns("user_options"), "attrib")
        ),
        bslib::page_fluid(
          bslib::layout_columns(
            col_widths = c(6, 6, 6, 6, 6, 6),
            min_height = "200px",
            bslib::card(
              card_header(class = "bg-light","Prediction Score Distribution",
                          tooltip(
                            bsicons::bs_icon("info-circle"),
                            "Displays how prediction probabilities are distributed across true and predicted food categories."
                          )),
              card_body(
                mod_ppd_plot_ui(ns("ppd_plot_1")))
            ),
            bslib::card(
              card_header(class = "bg-light","Confusion matrix",
                          tooltip(
                            bsicons::bs_icon("info-circle"),
                            "Visualizes correct and incorrect predictions across food categories to identify patterns of misclassification."
                          )),
              card_body(
                mod_confmat_plot_ui(ns("confmat_plot_1")))
            ),
            bslib::card(
              card_header(class = "bg-light","ROC Curve",
                          tooltip(
                            bsicons::bs_icon("info-circle"),
                            "Plots the true positive rate against the false positive rate to evaluate classification thresholds."
                          )),
              card_body(
                mod_roc_curve_plot_ui(ns("roc_curve_plot_1")))
            ),
            bslib::card(
              card_header(class = "bg-light","Precision-Recall Curve",
                          tooltip(
                            bsicons::bs_icon("info-circle"),
                            "Shows the trade-off between precision and recall at different thresholds."
                          )),
              card_body(
                mod_pr_curve_plot_ui(ns("pr_curve_plot_1")))
            ),
            bslib::card(
              card_header(class = "bg-light","Feature importance (Negative)",
                          tooltip(
                            bsicons::bs_icon("info-circle"),
                            "Highlights individual tokens (words) that contributed negatively to the food category prediction. "
                          )),
              card_body(
                mod_attrib_bar_plot_ui(ns("attrib_bar_plot_negative")))
            ),
            bslib::card(
              card_header(class = "bg-light","Feature importance (Positive)",
                          tooltip(
                            bsicons::bs_icon("info-circle"),
                            "Highlights individual tokens (words) that contributed positively to the food category prediction. "
                          )),
              card_body(
                mod_attrib_bar_plot_ui(ns("attrib_bar_plot_positive")))
            ),

          )
        )

      )
    }
  )
}

#' binder Server Functions
#'
#' @noRd
mod_binder_server <- function(id, con, pg){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    if (pg == "main") {

      mod_options_server("user_options", con=con)
      user_options <- mod_options_server("user_options", con=con)
      mod_scatter_plot_server("scatter_plot_mcc", user_options = user_options, con = con, plot_metric = "MCC")
      mod_scatter_plot_server("scatter_plot_acc", user_options = user_options, con = con, plot_metric = "Accuracy")
      mod_scatter_plot_server("scatter_plot_roc", user_options = user_options, con = con, plot_metric = "ROC-AUC")
      mod_scatter_plot_server("scatter_plot_ap", user_options = user_options, con = con, plot_metric = "Average Precision")

    } else if (pg == "attrib") {
      mod_options_server("user_options", con=con)
      user_options <- mod_options_server("user_options", con=con)


      mod_ppd_plot_server("ppd_plot_1", user_options = user_options, con = con)
      mod_confmat_plot_server("confmat_plot_1", user_options = user_options, con = con)
      mod_roc_curve_plot_server("roc_curve_plot_1", user_options = user_options, con = con)
      mod_pr_curve_plot_server("pr_curve_plot_1", user_options = user_options, con = con)
      mod_attrib_bar_plot_server("attrib_bar_plot_negative", user_options = user_options, con = con, label = 0)
      mod_attrib_bar_plot_server("attrib_bar_plot_positive", user_options = user_options, con = con, label = 1)
    }
  })
}

## To be copied in the UI
# mod_binder_ui("binder_1")

## To be copied in the server
# mod_binder_server("binder_1")
