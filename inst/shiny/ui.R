
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

  bslib::nav_panel(
    title = "Background",
    icon = shiny::icon("book-atlas"),
    backgroundCard("background.md")
  ),

  bslib::nav_panel(
    title = "OmopCheckout",
    icon = shiny::icon("magnifying-glass-chart"),

    # panel to upload results
    bslib::card(
      shiny::fileInput(
        "file_results",
        "Upload Summarised Results",
        accept = c(".csv")
      )
    ),

    bslib::card(
      id = "results_processing",

      "processing results"
    ),

    # so it can be hidden and shown
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

            bslib::card(
              bslib::card_header("Result type to explore"),

              # to select the result_type to explore
              shinyWidgets::pickerInput(
                label = "Result type to explore",
                inputId = "result_type",
                choices = NULL,
                selected = NULL,
                multiple = FALSE
              ),

              # summary of result_type generation
              shiny::textOutput("result_type_generation")
            ),

            # crad to explore
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

  # bslib::nav_item(
  #   bslib::popover(
  #     shiny::icon("download"),
  #     shiny::downloadButton(
  #       outputId = "download_raw",
  #       label = "Download raw data",
  #       icon = shiny::icon("download")
  #     )
  #   )
  # ),

  bslib::nav_item(bslib::input_dark_mode(id = "dark_mode", mode = "light"))
)
