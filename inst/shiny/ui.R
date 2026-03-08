
ui <- bslib::page_navbar(

  title = shiny::tags$span(
    shiny::tags$img(
      src = "hdruk_logo.svg",
      width = "auto",
      height = "46px",
      class = "me-3",
      alt = "logo"
    ),
    ""
  ),

  theme = bslib::bs_theme(bootswatch = "flatly"),

  # required for shinyjs show/hide
  header = shinyjs::useShinyjs(),

  bslib::nav_panel(
    title = "Background",
    icon = shiny::icon("book-atlas"),
    backgroundCard("background.md")
  ),

  bslib::nav_panel(
    title = "OmopCheckout",
    icon = shiny::icon("magnifying-glass-chart"),

    # panel to upload results
    bslib::accordion(
      id = "upload_accordion",
      open = TRUE,
      bslib::accordion_panel(
        title = "Upload Summarised Results",
        icon = shiny::icon("file-arrow-up"),
        shiny::fileInput(
          "file_results",
          label = NULL,
          accept = c(".csv")
        )
      )
    ),

    # processing log — visible while results are being processed
    shinyjs::hidden(
      div(
        id = "results_processing_wrapper",

        bslib::card(
          id = "results_processing",
          bslib::card_header(
            shiny::icon("gear"),
            " Processing results \u2014 please wait\u2026"
          ),
          shiny::tags$pre(id = "processing_log", style = "height:300px; overflow-y:auto; background:#1e1e1e; color:#d4d4d4; padding:10px; border-radius:4px; font-size:0.85em;")
        )
      )
    ),

    # summary panel — hidden until processing is complete
    shinyjs::hidden(
      div(
        id = "results_summary_wrapper",

        bslib::navset_card_tab(

          id = "results_summary",

          # check out panel
          bslib::nav_panel(
            title = "Checkout Summary",

            shiny::uiOutput("checkout_summary_html") |>
              shinycssloaders::withSpinner(type = 1, color = "#0d6efd"),

            # Raw markdown collapsible + download
            tags$details(
              tags$summary("Show raw markdown report"),
              verbatimTextOutput("checkout_summary_md")
            ),

            downloadButton("download_checkout_md", "Download summary (.md)")
          ),

          # explore results panel
          bslib::nav_panel(
            title = "Results explorer",

            # to select the result_type to explore
            shinyWidgets::pickerInput(
              label = "Result type to explore",
              inputId = "result_type",
              choices = NULL,
              selected = NULL,
              multiple = FALSE
            ),

            # summary of result_type generation
            shiny::textOutput("result_type_generation"),

            # card to explore
            bslib::card(
              reactable::reactableOutput("results_contents") |>
                shinycssloaders::withSpinner()
            )
          )

        )
      )
    )
  ),

  bslib::nav_spacer(),

  bslib::nav_item(bslib::input_dark_mode(id = "dark_mode", mode = "light"))
)
