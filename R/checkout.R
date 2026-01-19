
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

summarySuppress <- function(result) {
  ids <- unique(result$result_id)
  msg <- character(0)
  for (id in ids) {
    res <- result |> omopgenerics::filterSettings(.data$result_id == .env$id)
    set <- omopgenerics::settings(res)
    isSuppressed <- suppressWarnings(
      omopgenerics::isResultSuppressed(res)
    )

    if (!isSuppressed) {
      msg <- c(msg, paste0("result ", id, " not suppressed"))
    } else {
      minCellCount <- set |>
        dplyr::pull(.data$min_cell_count) |>
        as.numeric()

      set0 <- set |>
        dplyr::mutate(min_cell_count = 0L)

      res_new <- omopgenerics::newSummarisedResult(res, settings = set0) |>
        omopgenerics::suppress(minCellCount = minCellCount)

      if (isTRUE(dplyr::all_equal(res, res_new))) {
        msg <- c(msg, paste0("result ", id, " correctly suppressed with minCellCount = ", minCellCount))
      } else {
        msg <- c(msg, paste0("result ", id, " not correctly suppressed with minCellCount = ", minCellCount))
      }
    }
  }
  return(msg)
}


summaryPackages <- function(result) {

  if (nrow(result) == 0) {
    return(
      paste0(
        "package name = ", NA_character_,
        "; version = ", NA_character_,
        "; number records = 0"
      )
    )
  }

  result <- result |>
    omopgenerics::addSettings(
      settingsColumn = c("package_name", "package_version")
    )
  x <- result |>
    dplyr::group_by(.data$package_name, .data$package_version) |>
    dplyr::summarise(number_rows = dplyr::n(), result_id = list(sort(unique(result_id))), .groups = "drop") |>
    dplyr::mutate(number_rows = dplyr::coalesce(.data$number_rows, 0L))

  paste0(
    "package name = ", x$package_name,
    "; version = ", x$package_version,
    "; result id = ", sapply(x2$result_id, function(v) paste(v, collapse = ", ")),
    "; number records = ", x$number_rows
  )
}


summaryResult <- function(result) {

  if (nrow(result) == 0) {
    return(character(0))
  }

  x <- result |>
    dplyr::group_by(
      .data$estimate_name,
      .data$strata_name ) |>
    dplyr::summarise(
      result_id = list(sort(unique(result_id))),
      .groups = "drop"
    )

  paste(
    "estimate name = ", x$estimate_name,
    "; strata = ", x$strata_name,
    "; result id = ", sapply(x$result_id, function(v) paste(v, collapse = ", ")),
    collapse = "\n")
}


checkoutSummary <- function(result) {
  # handle empty input
  if (length(result) == 0 || nrow(result) == 0) {
    report <- c(
      "# `<summarised_result>`",
      "",
      "No data in `result`."
    )
    cat(paste(report, collapse = "\n"), "\n")
    invisible(report)
  }


  # header
  report <- c(
    "# `<summarised_result>`",
    "",
    paste0("Total rows in object: ", nrow(result)),
    paste0("Result IDs: ", paste(ids, collapse = ", ")),
    ""
  )

  # iterate over each result id and append summaries

    # suppression summary
    suppress_msg <- summarySuppress(result)
    report <- c(report, "### suppression", paste(as.character(suppress_msg), collapse = "\n"), "")

    # packages summary
    packages_msg <- summaryPackages(result)
    report <- c(report, "### packages", paste(as.character(packages_msg), collapse = "\n"), "")

    # result rows summary
    result_msg <- summaryResult(result)
    report <- c(report, "### result content", paste(as.character(result_msg), collapse = "\n"), "")

    # spacer
    report <- c(report, "------------------------------", "")
  # print and return invisibly
  cat(paste(report, collapse = "\n"), "\n")
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
