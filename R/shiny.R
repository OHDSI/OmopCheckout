
#' Launch the OmopCheckout Shiny application
#'
#' @export
checkoutShiny <- function() {

  # Check required packages
  rlang::check_installed(c(
    "shiny",
    "bslib",
    "reactable",
    "dplyr",
    "omopgenerics",
    "commonmark",
    "shinycssloaders" ,
    "rlang"
  ))

  # Run app
  shiny::runApp(
    appDir = system.file("shiny", package = "OmopCheckout")
  )

}
