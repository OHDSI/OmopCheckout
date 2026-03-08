
shinyDirectory <- file.path(getwd(), "extras", "shiny")
unlink(shinyDirectory, recursive = TRUE)
dir.create(path = shinyDirectory)
file.copy(
  from = system.file("shiny", package = "OmopCheckout"),
  to = file.path(getwd(), "extras"),
  recursive = TRUE
)

print(list.files(shinyDirectory, full.names = TRUE))

print(list.files(getwd(), full.names = TRUE))

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
