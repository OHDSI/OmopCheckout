# # download raw data -----
# output$download_raw <- shiny::downloadHandler(
#   filename = "results.csv",
#   content = function(file) {
#     # Be careful: 'data' must exist here. As a safe fallback, export the uploaded table if available:
#     df <- NULL
#     try({
#       df <- getUploadedResults()
#     }, silent = TRUE)
#
#     if (!is.null(df) && is.data.frame(df)) {
#       utils::write.csv(df, file, row.names = FALSE)
#     } else {
#       # fallback: if your original code expects a specific pipeline, restore it here.
#       writeLines("no data available", file)
#     }
#   }
# )
#
# # Reactive: import uploaded file and coerce to data.frame if possible
# getUploadedResults <- shiny::reactive({
#   req(input$file_results)
#   infile <- input$file_results
#   path <- infile$datapath
#   name <- infile$name
#
#   message("Uploading file: ", name, " -> ", path)
#
#   # try import - capture errors cleanly
#   imported <- NULL
#   import_err <- NULL
#   tryCatch({
#     imported <- omopgenerics::importSummarisedResult(path)
#   }, error = function(e) {
#     import_err <<- e
#     message("omopgenerics import error: ", conditionMessage(e))
#   }, warning = function(w) {
#     message("omopgenerics import warning: ", conditionMessage(w))
#   })
#
#
#   if (is.null(imported)) {
#     showNotification("Failed to import file. Check R console for details.", type = "error", duration = 6)
#     stop("Import failed for file: ", path)
#   }
#
#
#   message("Imported data.frame rows=", nrow(imported), " cols=", ncol(imported))
#   imported
# })
#
# # Render debug text in UI if you add verbatimTextOutput("debug_uploaded")
# output$debug_uploaded <- renderPrint({
#   if (is.null(input$file_results)) return("No file uploaded yet.")
#   tryCatch({
#     d <- getUploadedResults()
#     paste0("Imported class=", paste(class(d), collapse = ", "),
#            "  Rows=", nrow(d), "  Cols=", ncol(d))
#   }, error = function(e) {
#     paste("Import error:", conditionMessage(e))
#   })
# })
#
# # render the reactable table (must match UI id 'results_contents')
# output$results_contents <- reactable::renderReactable({
#   req(input$file_results)
#   df <- getUploadedResults()
#   validate(
#     need(is.data.frame(df), "Imported object is not a data.frame/tibble."),
#     need(nrow(df) > 0, "Uploaded file contains no rows")
#   )
#   # Limit columns if extremely wide to avoid browser problems
#   if (ncol(df) > 120) {
#     showNotification("Data has many columns; showing first 120 for responsiveness.", type = "message", duration = 4)
#     df <- df[, seq_len(120), drop = FALSE]
#   }
#   reactable::reactable(df, searchable = TRUE, filterable = TRUE, pagination = TRUE, defaultPageSize = 25)
# })
#
# # reactive that returns the markdown lines (character vector)
# checkout_md <- shiny::reactive({
#   req(input$file_results)
#   df <- getUploadedResults()
#
#   # capture printed output because checkoutSummary() uses cat() then returns invisibly
#   md_lines <- tryCatch(
#     {
#       capture.output({
#
#         OmopCheckout::checkoutSummary(df)
#
#       })
#     },
#     error = function(e) {
#       c("# Error generating checkout summary", "", paste0("Error: ", conditionMessage(e)))
#     }
#   )
#
#   # ensure it's a character vector
#   if (is.null(md_lines)) md_lines <- character(0)
#   md_lines
# })
#
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
#
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
#
# # Raw markdown capture (useful for download / verbatim)
# checkout_md <- reactive({
#   req(input$file_results)
#   # If your checkoutSummary() prints via cat() and returns invisibly, capture printed output:
#   capture.output({
#     # call namespaced if necessary: omopcheckout::checkoutSummary(getUploadedResults())
#     checkoutSummary(getUploadedResults())
#   })
# })
#
# output$checkout_summary_md <- renderText({
#   paste(checkout_md(), collapse = "\n")
# })
#
# # Download handler for the markdown summary
# output$download_checkout_md <- downloadHandler(
#   filename = function() paste0("checkout_summary_", Sys.Date(), ".md"),
#   content = function(file) writeLines(checkout_md(), con = file)
# )
