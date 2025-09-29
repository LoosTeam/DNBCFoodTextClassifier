# library(dplyr)
# library(ggplot2)
#
# pr_df <- pred_data %>%
#   arrange(desc(predicted_value_1)) %>%
#   mutate(
#     tp = cumsum(true_label == 1),
#     fp = cumsum(true_label == 0),
#     fn = sum(true_label == 1) - tp,
#     precision = tp / (tp + fp),
#     recall = tp / (tp + fn)
#   )
# pr_auc <- sum(diff(pr_df$recall) * zoo::rollmean(pr_df$precision, 2))
# ggplot(pr_df, aes(x = recall, y = precision)) +
#   geom_line(color = "darkred") +
#   ylim(0, 1) + xlim(0, 1) +
#   labs(
#     x = "Recall (TPR)",
#     y = "Precision (PPV)",
#     title = paste0("Precision–Recall Curve (AUC = ", round(pr_auc, 3), ")")
#   ) +
#   theme_minimal()
#
