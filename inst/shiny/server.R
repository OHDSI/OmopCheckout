
server <- function(input, output, session) {

  # result processing ----
  # Reactive log messages accumulated during processing
  log_messages <- shiny::reactiveVal(character(0))
  explore_results <- shiny::reactiveVal(list())

  # Helper to append a line to the processing log
  log_msg <- function(msg) {
    log_messages(c(log_messages(), paste0("[", format(Sys.time(), "%H:%M:%S"), "] ", msg)))
  }

  # Render the processing log
  output$processing_log <- shiny::renderText({
    paste(log_messages(), collapse = "\n")
  })

  # Observe file upload and trigger processing
  shiny::observeEvent(input$file_results, {

    # Collapse the upload accordion now that a file has been provided
    bslib::accordion_panel_close("upload_accordion", "Upload Summarised Results")

    # Reset log and show the processing panel; hide results
    log_messages(character(0))
    shinyjs::show("results_processing_wrapper")
    shinyjs::hide("results_summary_wrapper")

    log_msg("File received. Starting processing...")

    tryCatch({

      log_msg(paste0("Reading file: ", input$file_results$name))
      results <- readr::read_csv(input$file_results$datapath, show_col_types = FALSE)

      log_msg("Attempting to convert file to `summarised_result` object.")
      results <- omopgenerics::newSummarisedResult(x = results)

      Sys.sleep(10)

      log_msg("Splitting result by result type")
      rt <- unique(omopgenerics::settings(results)$result_type)

      log_msg("Processing complete.")

      # Hide processing panel and reveal summary panel
      shinyjs::hide("results_processing_wrapper")
      shinyjs::show("results_summary_wrapper")

    }, error = function(e) {
      log_msg(paste0("ERROR: ", conditionMessage(e)))
    })

  })

}
