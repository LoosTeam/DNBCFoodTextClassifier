# Building a Prod-Ready, Robust Shiny Application.
#
# README: each step of the dev files is optional, and you don't have to
# fill every dev scripts before getting started.
# 01_start.R should be filled at start.
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
#
#
###################################
#### CURRENT FILE: DEV SCRIPT #####
###################################

# Engineering

## Dependencies ----
## Amend DESCRIPTION with dependencies read from package code parsing
## install.packages('attachment') # if needed.

#using renv with golem: https://thinkr-open.github.io/golem/articles/c_deploy.html

# usethis::use_package("bslib")
# usethis::use_package("dplyr")
# usethis::use_pipe()
# usethis::use_package("DBI")
# usethis::use_package("ggplot2")
# usethis::use_package("pROC")
# usethis::use_package("plotly")
# usethis::use_package("RSQLite")
# usethis::use_package("ggnewscale")

attachment::att_amend_desc()
attachment::create_renv_for_dev(dev_pkg = c(
  "renv",
  "devtools",
  "roxygen2",
  "usethis",
  "pkgload",
  "golem",
  "DBI",
  "ggplot2",
  "pROC",
  "plotly",
  "RSQLite",
  "ggnewscale",
  "shinyWidgets"
))

## Add modules ----
## Create a module infrastructure in R/
golem::add_module(name = "about")
golem::add_module(name = "scatter_plot")
golem::add_module(name = "options")
golem::add_module(name = "binder")
golem::add_module(name = "ppd_plot")
golem::add_module(name = "confmat_plot")
golem::add_module(name = "roc_curve_plot")
golem::add_module(name = "pr_curve_plot")

## Add helper functions ----
## Creates fct_* and utils_*
golem::add_fct("nav")
# golem::add_utils("helpers", with_test = TRUE)

## External resources
## Creates .js and .css files at inst/app/www
golem::add_js_file("script")
golem::add_js_handler("handlers")
golem::add_css_file("custom")
golem::add_sass_file("custom")
golem::add_any_file("file.json")

## Add internal datasets ----
## If you have data in your package
usethis::use_data_raw(name = "eir_db", open = FALSE)
usethis::use_data_raw(name = "category_map", open = FALSE)

## Tests ----
## Add one line by test you want to create
usethis::use_test("app")

# Documentation

## Vignette ----
usethis::use_vignette("DNBCFoodTextClassifier")
devtools::build_vignettes()

## Code Coverage----
## Set the code coverage service ("codecov" or "coveralls")
usethis::use_coverage()

# Create a summary readme for the testthat subdirectory
covrpage::covrpage()

## CI ----
## Use this part of the script if you need to set up a CI
## service for your application
##
## (You'll need GitHub there)
usethis::use_github()

# GitHub Actions
usethis::use_github_action()
# Chose one of the three
# See https://usethis.r-lib.org/reference/use_github_action.html
usethis::use_github_action_check_release()
usethis::use_github_action_check_standard()
usethis::use_github_action_check_full()
# Add action for PR
usethis::use_github_action_pr_commands()

# Circle CI
usethis::use_circleci()
usethis::use_circleci_badge()

# Jenkins
usethis::use_jenkins()

# GitLab CI
usethis::use_gitlab_ci()

# You're now set! ----
# go to dev/03_deploy.R
rstudioapi::navigateToFile("dev/03_deploy.R")
