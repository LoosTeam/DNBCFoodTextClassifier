## code to prepare `eir_db` dataset goes here
library(DBI)
library(RSQLite)

# Connect to MSSQL
con_mssql <- DBI::dbConnect(
  drv      = RPostgres::Postgres(),
  dbname   = "eir_data",
  host     = "localhost",
  port     = 5432,
  user     = "postgres",
  password = "siddhi"
)

# Connect to SQLite
con_sqlite <- dbConnect(RSQLite::SQLite(), "inst/extdata/eir_data.sqlite")

# List MSSQL tables
tables <- dbListTables(con_mssql)

# Copy each table to SQLite
for (tbl in tables) {
  message("Exporting: ", tbl)
  df <- dbReadTable(con_mssql, tbl)
  dbWriteTable(con_sqlite, tbl, df, overwrite = TRUE)
}

dbDisconnect(con_mssql)
dbDisconnect(con_sqlite)

