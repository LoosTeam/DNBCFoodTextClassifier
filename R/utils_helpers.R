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
