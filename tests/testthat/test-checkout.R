
test_that("validateOutput accepts valid string options", {
  expect_equal(validateOutput("console"), "console")
  expect_equal(validateOutput("text"), "text")
  expect_equal(validateOutput("show"), "show")
  expect_equal(validateOutput("my_file"), "my_file.md")
  expect_equal(validateOutput("my_file2.md"), "my_file2.md")
  expect_error(validateOutput(123))
  expect_error(validateOutput(NULL))
  expect_error(validateOutput(c("console", "text")))
})

test_that("nicenum formats numbers with commas", {
  expect_equal(nicenum(1000), "1,000")
  expect_equal(nicenum(1000000), "1,000,000")
  expect_equal(nicenum(42), "42")
})

test_that("percentage", {
  expect_equal(percentage(0), "0%")
  expect_equal(percentage(NA_real_), "-%")
  expect_equal(percentage(0.0001), "<0.1%")
  expect_equal(percentage(0.5), "50.0%")
  expect_equal(percentage(1), "100.0%")
  expect_equal(percentage(0.333), "33.3%")
})

test_that("collapseIds", {
  expect_equal(collapseIds(5L), "5")
  expect_equal(collapseIds(1:3), "1\u20133")
  expect_equal(collapseIds(c(1L, 3L, 5L)), "1, 3, 5")
  expect_equal(collapseIds(c(1L, 6L, 2L, 3L, 5L, 8L)), "1\u20133, 5\u20136, 8")
  expect_equal(collapseIds(c(1L, 1L, 2L)), "1\u20132")
})

test_that("checkout", {
  result <- newResult()
  out <- withVisible(checkout(result, output = "console"))
  expect_false(out$visible)
  expect_type(out$value, "character")

  out2 <- withVisible(checkout(result, output = "text"))
  expect_true(out2$visible)

  tmp <- tempfile(fileext = ".md")
  on.exit(unlink(tmp))
  expect_false(file.exists(tmp))
  expect_message(checkout(result, output = tmp))
  expect_true(file.exists(tmp))
  content <- readLines(tmp, warn = FALSE) |> paste(collapse = "\n")

  expect_identical(out$value, out2$value)
  expect_identical(out$value, content)
  expect_identical(out$value, checkout(result, output = "text"))
  expect_identical(out$value, checkout(result, output = "console"))
  expect_identical(out$value, checkout(result, output = "show"))

  expect_error(checkout("not_a_result"))
  expect_error(checkout(data.frame(x = 1)))
  expect_error(checkout(NULL))
})

test_that("summarySuppress", {
  result <- newResult()

  # unsuppressed result
  report <- summarySuppress(result, output = "text")
  expect_match(report, "Unsuppresed", fixed = TRUE)

  # suppressed to 5
  result2 <- result |>
    omopgenerics::suppress(minCellCount = 5)
  report <- summarySuppress(result2, output = "text")
  expect_match(report, "minCellCount = 5", fixed = TRUE)

  result3 <- omopgenerics::bind(result, result2)
  report <- summarySuppress(result3, output = "text")
  expect_match(report, "Unsuppresed** results for result IDs: 1", fixed = TRUE)
  expect_match(report, "minCellCount = 5** for result IDs: 2", fixed = TRUE)

  empty <- omopgenerics::emptySummarisedResult()
  report <- summarySuppress(empty, output = "text")
  expect_match(report, "Empty", fixed = TRUE)

  empty <- omopgenerics::emptySummarisedResult()
  report <- summaryPackages(empty, output = "text")
  expect_match(report, "Empty", fixed = TRUE)
})

test_that("summaryPackages shows package name and version", {
  result1 <- newResult()
  report <- summaryPackages(result1, output = "text")
  expect_match(report, "OmopCheckout", fixed = TRUE)
  expect_match(report, "1.0.0", fixed = TRUE)

  result2 <- newResult(packageName = "CohortCharacteristics", packageVersion = "2.0.0")
  report <- summaryPackages(result2, output = "text")
  expect_match(report, "CohortCharacteristics", fixed = TRUE)
  expect_match(report, "2.0.0", fixed = TRUE)

  result <- newResult(resultType = "cohort_overlap")
  report <- summaryPackages(result, output = "text")
  expect_match(report, "cohort_overlap", fixed = TRUE)

  result <- newResult(packageName = NA_character_)
  report <- summaryPackages(result, output = "text")
  expect_match(report, "unknown", fixed = TRUE)

  result <- newResult(packageName = "-")
  report <- summaryPackages(result, output = "text")
  expect_match(report, "unknown", fixed = TRUE)

  result <- newResult(packageName = "  ")
  report <- summaryPackages(result, output = "text")
  expect_match(report, "unknown", fixed = TRUE)

  result <- omopgenerics::bind(result1, result2)
  report <- summaryPackages(result, output = "text")
  expect_match(report, "OmopCheckout", fixed = TRUE)
  expect_match(report, "CohortCharacteristics", fixed = TRUE)
})

test_that("summaryEstimates shows estimate names present in result", {
  result <- newResult(estimates = list(c("count", "mean")))
  report <- summaryEstimates(result, output = "text")
  expect_match(report, "count", fixed = TRUE)
  expect_match(report, "mean",  fixed = TRUE)

  result <- newResult(
    resultType = c("incidence", "characteristics"),
    estimates = list("ir", c("count", "mean"))
  )
  report <- summaryEstimates(result, output = "text")
  expect_match(report, "incidence", fixed = TRUE)
  expect_match(report, "ir", fixed = TRUE)
  expect_match(report, "characteristics", fixed = TRUE)
  expect_match(report, "count", fixed = TRUE)
  expect_match(report, "mean", fixed = TRUE)

  empty <- omopgenerics::emptySummarisedResult()
  report <- summaryEstimates(empty, output = "text")
  expect_match(report, "Empty", fixed = TRUE)
})

test_that("checkout text output contains all three section headers", {
  result <- newResult()
  report <- checkout(result, output = "text")
  expect_match(report, "### Suppression", fixed = TRUE)
  expect_match(report, "### Packages",    fixed = TRUE)
  expect_match(report, "### Estimates",   fixed = TRUE)

  # repeated tests suppress
  report <- checkout(result, output = "text")
  expect_match(report, "Unsuppresed", fixed = TRUE)
  result2 <- result |>
    omopgenerics::suppress(minCellCount = 5)
  report <- checkout(result2, output = "text")
  expect_match(report, "minCellCount = 5", fixed = TRUE)
  result3 <- omopgenerics::bind(result, result2)
  report <- checkout(result3, output = "text")
  expect_match(report, "Unsuppresed** results for result IDs: 1", fixed = TRUE)
  expect_match(report, "minCellCount = 5** for result IDs: 2", fixed = TRUE)
  empty <- omopgenerics::emptySummarisedResult()
  report <- checkout(empty, output = "text")
  expect_match(report, "Empty", fixed = TRUE)

  # repeated tests packages
  result1 <- newResult()
  report <- checkout(result1, output = "text")
  expect_match(report, "OmopCheckout", fixed = TRUE)
  expect_match(report, "1.0.0", fixed = TRUE)
  result2 <- newResult(packageName = "CohortCharacteristics", packageVersion = "2.0.0")
  report <- checkout(result2, output = "text")
  expect_match(report, "CohortCharacteristics", fixed = TRUE)
  expect_match(report, "2.0.0", fixed = TRUE)
  result <- newResult(resultType = "cohort_overlap")
  report <- checkout(result, output = "text")
  expect_match(report, "cohort_overlap", fixed = TRUE)
  result <- newResult(packageName = NA_character_)
  report <- checkout(result, output = "text")
  expect_match(report, "unknown", fixed = TRUE)
  result <- newResult(packageName = "-")
  report <- checkout(result, output = "text")
  expect_match(report, "unknown", fixed = TRUE)
  result <- newResult(packageName = "  ")
  report <- checkout(result, output = "text")
  expect_match(report, "unknown", fixed = TRUE)
  result <- omopgenerics::bind(result1, result2)
  report <- checkout(result, output = "text")
  expect_match(report, "OmopCheckout", fixed = TRUE)
  expect_match(report, "CohortCharacteristics", fixed = TRUE)

  # summarise estimates
  result <- newResult(estimates = list(c("count", "mean")))
  report <- checkout(result, output = "text")
  expect_match(report, "count", fixed = TRUE)
  expect_match(report, "mean",  fixed = TRUE)
  result <- newResult(
    resultType = c("incidence", "characteristics"),
    estimates = list("ir", c("count", "mean"))
  )
  report <- checkout(result, output = "text")
  expect_match(report, "incidence", fixed = TRUE)
  expect_match(report, "ir", fixed = TRUE)
  expect_match(report, "characteristics", fixed = TRUE)
  expect_match(report, "count", fixed = TRUE)
  expect_match(report, "mean", fixed = TRUE)
  empty <- omopgenerics::emptySummarisedResult()
  report <- checkout(empty, output = "text")
  expect_match(report, "Empty", fixed = TRUE)
})
