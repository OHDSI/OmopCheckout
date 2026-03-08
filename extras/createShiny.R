
shinyDirectory <- file.path(getwd(), "extras", "shiny")
unlink(shinyDirectory, recursive = TRUE)
dir.create(path = shinyDirectory)
file.copy(
  from = file.path(getwd(), "inst", "shiny"),
  to = file.path(getwd(), "extras"),
  recursive = TRUE
)

bp <- file.path(getwd(), "extras", "shiny", "background.md")
backgoundFile <- c(
  readLines(con = bp),
  '',
  '**!NOTE** that if you upload results to this shiny app you are uploading those results to <shinyapp.io> you can easily set a local version of this shiny app with:',
  '',
  '```',
  '# pak::pkg_install("ohdsi/OmopCheckout")',
  'library(OmopCheckout)',
  'checkoutShiny()',
  '```'
) |>
  writeLines(bp)
