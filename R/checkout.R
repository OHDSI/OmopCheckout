
#' Check a summarised_result object
#'
#' @description
#' Runs a full audit of a `summarised_result` object, covering suppression
#' status, package metadata, and estimate types. The report can be printed
#' to the console, returned as text, shown in the RStudio viewer, or saved
#' to a Markdown file.
#'
#' @param result A `summarised_result` object.
#' @param output A single character string specifying where to send the output.
#'   It can be:
#' \itemize{
#'   \item \code{"console"} to print the summary in the console.
#'   \item \code{"text"} to return the summary as a character string.
#'   \item \code{"show"} to display the result in the viewer (HTML format).
#'   \item Otherwise \code{output} will be used as the name of an \code{'.md'}
#'     file to write the report to.
#' }
#'
#' @return A character string containing the summary of all checks, returned
#'   invisibly unless \code{output = "text"}.
#' @export
#'
checkout <- function(result, output = "console") {
  # initial check
  omopgenerics::validateResultArgument(result)
  output <- validateOutput(output)

  # suppress summary
  report <- c(
    "## <summarised_result>",
    "### Suppression",
    suppressCheck(result),
    "### Packages",
    packagesCheck(result),
    "### Estimates",
    estimatesCheck(result)
  ) |>
    paste0(collapse = "\n\n") |>
    writeReport(output)

  if (output == "text") {
    report
  } else {
    invisible(report)
  }
}
#' Check suppression correctness for each result_id
#'
#' For each unique `result_id` in `result`, checks whether suppression has been
#' applied and reports the minimum cell count used, the number of rows affected,
#' and the percentage of total results that are suppressed or unsuppressed.
#'
#' @inheritParams checkout
#'
#' @return A character string containing the suppression summary, returned
#'   invisibly unless \code{output = "text"}.
#' @export
summarySuppress <- function(result, output = "console") {
  # initial check
  omopgenerics::validateResultArgument(result)
  output <- validateOutput(output)

  report <- suppressCheck(result) |>
    writeReport(output)

  if (output == "text") {
    report
  } else {
    invisible(report)
  }
}

#' Summarise package usage in a summarised_result object
#'
#' For each package name and version found in the result settings, reports the
#' number of rows and result IDs associated with it, broken down by result type.
#'
#' @inheritParams checkout
#'
#' @return A character string containing the package summary, returned
#'   invisibly unless \code{output = "text"}.
#' @export
summaryPackages <- function(result, output = "console") {
  # initial check
  omopgenerics::validateResultArgument(result)
  output <- validateOutput(output)

  report <- packagesCheck(result) |>
    writeReport(output)

  if (output == "text") {
    report
  } else {
    invisible(report)
  }
}

#' Summarise estimate types by result type in a summarised_result object
#'
#' For each unique `result_type` in the result settings, reports which estimate
#' names are present along with their row counts and percentage of the total.
#'
#' @inheritParams checkout
#'
#' @return A character string containing the estimates summary, returned
#'   invisibly unless \code{output = "text"}.
#' @export
summaryEstimates <- function(result, output = "console") {
  # initial check
  omopgenerics::validateResultArgument(result)
  output <- validateOutput(output)

  report <- estimatesCheck(result) |>
    writeReport(output)

  if (output == "text") {
    report
  } else {
    invisible(report)
  }
}

validateOutput <- function(output, call = parent.frame()) {
  omopgenerics::assertCharacter(output, length = 1, call = call)
  if (!output %in% c("console", "text", "show") & !endsWith(output, ".md")) {
    output <- paste0(output, ".md")
  }
  output
}
suppressCheck <- function(result) {
  counts <- result |>
    dplyr::group_by(.data$result_id) |>
    dplyr::tally()
  set <- omopgenerics::settings(result)
  if (nrow(set) == 0) {
    return("*Empty results*")
  }
  set |>
    dplyr::select("result_id", "min_cell_count") |>
    dplyr::mutate(min_cell_count = dplyr::coalesce(
      as.numeric(.data$min_cell_count), 0
    )) |>
    dplyr::arrange(.data$min_cell_count) |>
    dplyr::group_by(.data$min_cell_count) |>
    dplyr::group_split() |>
    as.list() |>
    purrr::map(\(x) {
      n <- x |>
        dplyr::left_join(counts, by = "result_id") |>
        dplyr::mutate(n = dplyr::coalesce(.data$n, 0)) |>
        dplyr::pull("n") |>
        sum()
      minCellCount <- unique(x$min_cell_count)
      if (minCellCount == 0) {
        msg <- paste0(
          "- **Unsuppresed** results for result IDs: ",
          collapseIds(x$result_id),
          " (",
          nicenum(n),
          " rows; ",
          percentage(n/sum(counts$n)),
          ")"
        )
      } else {
        msg <- paste0(
          "- Results suppressed with **minCellCount = ",
          minCellCount,
          "** for result IDs: ",
          collapseIds(x$result_id),
          " (",
          nicenum(n),
          " rows; ",
          percentage(n/sum(counts$n)),
          ")"
        )
      }
    }) |>
    paste0(collapse = "\n")
}
packagesCheck <- function(result) {
  counts <- result |>
    dplyr::group_by(.data$result_id) |>
    dplyr::tally()
  total <- sum(counts$n)
  set <- omopgenerics::settings(result)
  if (nrow(set) == 0) {
    return("*Empty results*")
  }

  set |>
    dplyr::select("result_id", "package_name", "package_version", "result_type") |>
    dplyr::mutate(dplyr::across(
      c("package_name", "package_version"),
      \(x) {
        x[is.na(x)] <- "unknown"
        x[x == "-"] <- "unknown"
        x[trimws(x) == ""] <- "unknown"
        x
      }
    )) |>
    dplyr::arrange(.data$package_name, .data$package_version) |>
    dplyr::group_by(.data$package_name, .data$package_version) |>
    dplyr::group_split() |>
    as.list() |>
    purrr::map(\(x) {
      pkg <- unique(x$package_name)
      version <- unique(x$package_version)
      x <- x |>
        dplyr::left_join(counts, by = "result_id") |>
        dplyr::mutate(n = dplyr::coalesce(.data$n, 0))
      n <- sum(x$n)
      msg <- paste0(
        "**", pkg, " (", version, ")** for result IDs: ",
        collapseIds(x$result_id), " (", nicenum(n), " rows ; ",
        percentage(n/total), "):"
      )
      msgs <- x |>
        dplyr::group_by(.data$result_type) |>
        dplyr::group_split() |>
        purrr::map_chr(\(xx) {
          rt <- unique(xx$result_type)
          n <- sum(xx$n)
          paste0(
            "- *", rt, "* for result IDs: ",
            collapseIds(xx$result_id), " (", nicenum(n), " rows ; ",
            percentage(n/total), ")"
          )
        })
      paste0(c(msg, "", msgs, ""), collapse = "\n")
    }) |>
    paste0(collapse = "\n")
}
estimatesCheck <- function(result) {
  counts <- result |>
    dplyr::group_by(.data$result_id, .data$estimate_name) |>
    dplyr::tally() |>
    dplyr::ungroup()
  total <- sum(counts$n)
  set <- omopgenerics::settings(result) |>
    dplyr::select("result_id", "result_type") |>
    dplyr::inner_join(counts, by = "result_id")
  if (nrow(set) == 0) {
    return("*Empty results*")
  }

  set  |>
    dplyr::arrange(.data$result_type) |>
    dplyr::group_by(.data$result_type) |>
    dplyr::group_split() |>
    as.list() |>
    purrr::map(\(x) {
      rt <- unique(x$result_type)
      n <- sum(x$n)
      msg <- paste0(
        "**", rt, "** for result IDs: ", collapseIds(x$result_id), " (",
        nicenum(n), " rows ; ", percentage(n/total), "):"
      )
      x <- x |>
        dplyr::group_by(.data$estimate_name) |>
        dplyr::summarise(n = sum(.data$n))
      msgs <- paste0(
        "- *", x$estimate_name, "* (", x$n, " rows; ", percentage(x$n/total), ")"
      )
      paste0(c(msg, "", msgs, ""), collapse = "\n")
    }) |>
    paste0(collapse = "\n")
}
writeReport <- function(x, output) {
  if (output == "console") {
    cat(x)
  } else if (output == "show") {
    showReport(x)
  } else if (output != "text") {
    cli::cli_inform(c("i" = "Writing {.cls checkout_summary} to {.path {output}}"))
    writeLines(text = x, con = output)
  }
  return(x)
}
nicenum <- function(x) {
  format(x, big.mark = ",", scientific = FALSE)
}
percentage <- function(x) {
  purrr::map_chr(x, \(x) {
    if (is.na(x)) {
      return("-%")
    }
    if (x == 0) {
      return("0%")
    }
    x <- round(100 * x, 1)
    if (x == 0) {
      return("<0.1%")
    } else {
      return(paste0(sprintf("%.1f", x), "%"))
    }
  })
}
collapseIds <- function(ids) {
  ids <- sort(unique(ids))

  # Group into consecutive runs
  groups <- split(ids, cumsum(c(1, diff(ids) != 1)))

  # Format each group
  parts <- sapply(groups, function(g) {
    if (length(g) == 1) as.character(g)
    else paste(g[1], g[length(g)], sep = "\u2013")  # en dash
  })

  paste(parts, collapse = ", ")
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
