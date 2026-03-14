
newResult <- function(resultType = "my_result",
                      packageName = "OmopCheckout",
                      packageVersion = "1.0.0",
                      estimates = list(c("count", "mean"))) {
  estimates |>
    purrr::imap(\(x, k) {
      dplyr::tibble(
        result_id = k,
        cdm_name = "test",
        group_name = "overall",
        group_level = "overall",
        strata_name = "overall",
        strata_level = "overall",
        variable_name = "variable",
        variable_level = NA_character_,
        estimate_name = x,
        estimate_type = "numeric",
        estimate_value = as.character(runif(n = length(x))),
        additional_name  = "overall",
        additional_level = "overall"
      )
    }) |>
    dplyr::bind_rows() |>
    omopgenerics::newSummarisedResult(
      settings = dplyr::tibble(
        result_id = seq_along(resultType),
        result_type = resultType,
        package_name = packageName,
        package_version = packageVersion
      )
    )
}
