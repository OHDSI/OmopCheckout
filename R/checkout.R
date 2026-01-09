
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
  set <- omopgenerics::settings(result)
  id <- set$result_id |> unique()
  isSuppressed <- omopgenerics::isResultSuppressed(result) |> suppressWarnings()
  if (isSuppressed) {
    minCellCount <- set |>
      dplyr::pull(.data$min_cell_count) |>
      as.numeric()
    set <- set |>
      dplyr::mutate(min_cell_count = 0L)
    res_new <- omopgenerics::newSummarisedResult(result, settings = set) |>
      omopgenerics::suppress(minCellCount = minCellCount)
    if (all(result == res_new)) {
      return(paste0("result ", id, " correctly suppressed with minCellCount = ", minCellCount))
    } else {
      return(paste0("result ", id, " not correctly suppressed with minCellCount = ", minCellCount))
    }
  } else {
    return(paste0("result ", id, " not suppressed"))
  }

  return(NULL)
}

summaryPackages <- function(result) {
  if (length(result) == 0) {
    return(paste0(
      "package name = ",NA_character_, "; version = ", NA_character_, "; number records = ",
      0L
    ))
  }
  x <- result |>
    omopgenerics::addSettings(
          settingsColumn = c("package_name", "package_version")
        ) |>
        dplyr::group_by(.data$package_name, .data$package_version) |>
        dplyr::summarise(number_rows = dplyr::n(), .groups = "drop") |>
        dplyr::right_join(
          omopgenerics::settings(result) |>
            dplyr::select(c("package_name", "package_version")) |>
            dplyr::distinct(),
          by = c("package_name", "package_version")
        ) |>
        dplyr::mutate(number_rows = dplyr::coalesce(.data$number_rows, 0))

        return(paste0(
          "package name = ",x$package_name, "; version = ", x$package_version, "; number records = ",
          x$number_rows
        ) )
}

summaryResult <- function(result) {
  if (length(result) == 0) {
    return()
  }
  x <- result |>
    omopgenerics::addSettings(
      settingsColumn = c("result_type")
    ) |>
    dplyr::group_by(.data$result_type, .data$variable_name, .data$estimate_name) |>
    dplyr::summarise(number_rows = dplyr::n(), .groups = "drop")

  return(paste0(
    "result type = ",x$result_type, "; variable name = ", x$variable_name, "; estimate name = ", x$estimate_name,"; number records = ",
    x$number_rows
  ) )
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

  # get settings and result ids (you said result_id is always present)
  set <- omopgenerics::settings(result)
  ids <- unique(set$result_id)

  # header
  report <- c(
    "# `<summarised_result>`",
    "",
    paste0("Total rows in object: ", nrow(result)),
    paste0("Result IDs: ", paste(ids, collapse = ", ")),
    ""
  )

  # iterate over each result id and append summaries
  for (id in ids) {
    res <- result |>
      dplyr::filter(.data$result_id == id)

    report <- c(report, paste0("## result: ", id), "")

    # suppression summary
    suppress_msg <- summarySuppress(subset)
    report <- c(report, "### suppression", paste(as.character(suppress_msg), collapse = "\n"), "")

    # packages summary
    packages_msg <- summaryPackages(subset)
    report <- c(report, "### packages", paste(as.character(packages_msg), collapse = "\n"), "")

    # result rows summary
    result_msg <- summaryResult(subset)
    report <- c(report, "### result rows", paste(as.character(result_msg), collapse = "\n"), "")

    # spacer
    report <- c(report, "------------------------------", "")
  }

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
