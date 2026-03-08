
# # ---- Structured Checkout Summary (server) ----
# output$checkout_summary_html <- renderUI({
#   req(input$file_results)
#   res <- getUploadedResults()
#
#   # ensure we have a data.frame-like object
#   if (!is.data.frame(res)) {
#     return(tags$div(class = "alert alert-danger", "Uploaded result is not a data.frame/tibble."))
#   }
#
#   # --- Build structures ---------------------------------------------------
#   total_rows <- nrow(res)
#   result_ids <- sort(unique(res$result_id))
#
#   # suppression per result_id
#   suppression_df <- lapply(result_ids, function(id) {
#     r <- res |> dplyr::filter(result_id == id)
#     suppressed <- suppressWarnings(omopgenerics::isResultSuppressed(r))
#     data.frame(result_id = id, suppressed = isTRUE(suppressed), stringsAsFactors = FALSE)
#   }) |> dplyr::bind_rows()
#
#   # packages summary (add settings then group)
#   pkgs <- res |>
#     omopgenerics::addSettings(settingsColumn = c("package_name", "package_version")) |>
#     dplyr::group_by(package_name = .data$package_name, package_version = .data$package_version) |>
#     dplyr::summarise(
#       result_ids = list(sort(unique(result_id))),
#       number_rows = dplyr::n(),
#       .groups = "drop"
#     ) |>
#     dplyr::mutate(result_ids = sapply(result_ids, function(v) paste(v, collapse = ", ")))
#
#   # results content summary
#   results_summary <- res |>
#     dplyr::group_by(estimate_name = .data$estimate_name, strata_name = .data$strata_name) |>
#     dplyr::summarise(result_ids = list(sort(unique(result_id))), .groups = "drop") |>
#     dplyr::mutate(result_ids = sapply(result_ids, function(v) paste(v, collapse = ", ")))
#
#   # --- Create UI ---------------------------------------------------------
#   badge <- function(text, variant = "secondary") {
#     tags$span(class = paste0("badge bg-", variant, " me-1"), text)
#   }
#
#   kpi_row <- tags$div(
#     class = "row mb-3",
#     tags$div(class = "col-sm-3",
#              bslib::card(
#                bslib::card_header("Total rows"),
#                bslib::card_body(tags$h4(total_rows))
#              )),
#     tags$div(class = "col-sm-9",
#              bslib::card(
#                bslib::card_header("Result IDs"),
#                bslib::card_body(
#                  tags$div(
#                    lapply(result_ids, function(id) badge(id, variant = "primary"))
#                  )
#                )
#              ))
#   )
#
#   suppression_table <- tags$table(
#     class = "table table-sm",
#     tags$thead(tags$tr(tags$th("Result ID"), tags$th("Suppressed"))),
#     tags$tbody(
#       lapply(seq_len(nrow(suppression_df)), function(i) {
#         row <- suppression_df[i, ]
#         tags$tr(
#           tags$td(row$result_id),
#           tags$td(if (isTRUE(row$suppressed)) badge("yes", "success") else badge("no", "danger"))
#         )
#       })
#     )
#   )
#
#   # reactable widgets
#   pkg_widget <- reactable::reactable(
#     pkgs,
#     columns = list(
#       package_name = reactable::colDef(name = "Package"),
#       package_version = reactable::colDef(name = "Version"),
#       result_ids = reactable::colDef(name = "Result IDs"),
#       number_rows = reactable::colDef(name = "Rows")
#     ),
#     searchable = TRUE, pagination = TRUE, defaultPageSize = 5
#   )
#
#   results_widget <- reactable::reactable(
#     results_summary,
#     columns = list(
#       estimate_name = reactable::colDef(name = "Estimate"),
#       strata_name = reactable::colDef(name = "Strata"),
#       result_ids = reactable::colDef(name = "Result IDs")
#     ),
#     searchable = TRUE, pagination = TRUE, defaultPageSize = 10
#   )
#
#   # Final assembled UI
#   tagList(
#     bslib::card(
#       bslib::card_header(tags$h3("Checkout Summary")),
#       bslib::card_body(
#         kpi_row,
#         tags$h4("Suppression"),
#         suppression_table,
#         tags$hr(),
#         tags$h4("Packages"),
#         pkg_widget,
#         tags$hr(),
#         tags$h4("Result content"),
#         results_widget
#       ),
#       style = "max-width:1200px;"
#     )
#   )
# })
