#' helpers
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd


#' @description A function to retrieve DB connection
#' @return DB connection
db_connect <- function(prod = golem::app_prod()) {

  if (prod) {

    conn <- DBI::dbConnect(
      drv      = RPostgres::Postgres(),
      dbname   = "eir_data",
      host     = "localhost",
      port     = 5432,
      user     = "postgres",
      password = "siddhi"
    )

  } else {

    con <- pool::dbPool(
      drv      = RPostgres::Postgres(),
      dbname   = "eir_data",
      host     = "localhost",
      port     = 5432,
      user     = "postgres",
      password = "siddhi"
    )
    onStop(function() {
      pool::poolClose(con)
    })

  }

  return(con)

}

# pool <- pool::dbPool(
#   drv      = RPostgres::Postgres(),
#   dbname   = "eir_data",
#   host     = "localhost",
#   port     = 5432,
#   user     = "postgres",
#   password = "siddhi"
# )
# dbGetQuery(pool, "SELECT * FROM predictions LIMIT 5;")
#
# pool::poolClose(pool)

#classif_type="major_classif"
#food_category="Alcohol"

#' @description A function to extract "category" ids
#' @return category ids
category_mapper <- function(con, classif_type, food_category=NULL) {
  if (!exists("food_category") || is.null(food_category) || food_category == "" || is.na(food_category)) {
    q1 <- paste0("SELECT category_id,name FROM categories WHERE type = '", classif_type, "'")
  } else {
    q1 <- paste0("SELECT category_id,name FROM categories WHERE type = '", classif_type,
                 "' AND name = '", food_category, "'")
  }

  category_mapper <- DBI::dbGetQuery(con, q1)

  return(category_mapper)
}

#' @description A function to extract "prediction" data
#' @return prediction dataset
prediction_data <- function(con, classif_type, food_category=NULL) {

  if (!exists("food_category") || is.null(food_category) || food_category == "" || is.na(food_category)) {
    q1 <- paste0("SELECT category_id FROM categories WHERE type = '", classif_type, "'")
  } else {
    q1 <- paste0("SELECT category_id FROM categories WHERE type = '", classif_type,
                 "' AND name = '", food_category, "'")
  }

  category_id <- DBI::dbGetQuery(con, q1)$category_id

  q2 <- paste0("SELECT * FROM predictions WHERE category_id IN (", paste(category_id, collapse = ","),")")

  pred_data <- DBI::dbGetQuery(con, q2) %>%
    dplyr::mutate(true_label_factor = factor(true_label, levels = c(0, 1),
                                             labels = c("Negative", "Positive")))

  return(pred_data)

}

#' @description A function to extract "metrics" data
#' @return metric dataset
metrics_data <- function(con, classif_type, food_category=NULL) {

  if (!exists("food_category") || is.null(food_category) || food_category == "" || is.na(food_category)) {
    q1 <- paste0("SELECT category_id FROM categories WHERE type = '", classif_type, "'")
  } else {
    q1 <- paste0("SELECT category_id FROM categories WHERE type = '", classif_type,
                 "' AND name = '", food_category, "'")
  }

  category_id <- DBI::dbGetQuery(con, q1)$category_id

  q2 <- paste0("SELECT * FROM metrics WHERE category_id IN (", paste(category_id, collapse = ","),")")
  metric_data <- DBI::dbGetQuery(con, q2)

  return(metric_data)
}
