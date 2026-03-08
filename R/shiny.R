
#' Launch the OmopCheckout Shiny application
#'
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
