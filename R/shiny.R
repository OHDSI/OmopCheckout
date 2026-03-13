
#' Launch the OmopCheckout Shiny application
#'
#' @description
#' Opens an interactive Shiny application for uploading, exploring, and
#' validating `summarised_result` objects. The app provides the same checks
#' as [checkout()] in a point-and-click interface, without needing to write
#' R code. Also you can explore the results in the explore Tab.
#'
#' @return Called for its side effect of launching the Shiny app. Returns
#'   \code{NULL} invisibly.
#' @export
checkoutShiny <- function() {

  # Check required packages
  rlang::check_installed(c(
    "bslib", "markdown", "purrr", "reactable", "readr", "rstudioapi", "shiny",
    "shinycssloaders", "shinyjs", "shinyWidgets", "testthat", "yaml"
  ))

  # Run app
  shiny::runApp(
    appDir = system.file("shiny", package = "OmopCheckout")
  )

}
