
#' An
#'
#' @param result A `summarised_result` object.
#' @param file Name of an '.md' file to write the report.
#'
#' @return Whether the result object passes the checks or not.
#' @export
#'
checkout <- function(result,
                     file = NULL) {
  # initial check
  result <- omopgenerics::validateResultArgument(result = result)
  omopgenerics::assertCharacter(file, length = 1, minNumCharacter = 1, null = TRUE)
  if (!is.null(file)) {
    if (!endsWith(x = file, suffix = ".md")) {
      file <- paste0(file, ".md")
    }
  }

  # suppress summary
  sup <- checkoutSuppress(result = result)


}

checkoutSuppress <- function(result) {
  result
}
checkoutSummary <- function(result) {
  report <- c("# `<summarised_result>`", "")

  # initial summary

  # summarise suppression

  # summarise packages, functions and estimates

  invisible(report)
}
showReport <- function(x) {
  if (interactive()) {
    # temporary file
    file <- tempfile(fileext = ".html")

    # compile md
    x <- paste0(
      "<!doctype html>\n<html>\n<head>\n<meta charset='utf-8'>\n<title>Preview</title>\n</head>\n<body>\n",
      commonmark::markdown_html(x),
      "\n</body>\n</html>"
    )

    # write to temporary file
    writeLines(text = x, con = file)

    # visualise report
    if (rlang::is_installed("rstudioapi")) {
      if (rstudioapi::isAvailable()) {
        rstudioapi::viewer(url = file)
      } else {
        utils::browseURL(url = file)
      }
    } else {
      utils::browseURL(url = file)
    }
  }

  invisible()
}
writeReport <- function(x, file) {
  if (!is.null(file)) {
    writeLines(text = x, con = file)
  }
  invisible()
}
