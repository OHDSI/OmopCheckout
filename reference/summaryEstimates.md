# Summarise results by estimate/strata

Summarise results by estimate/strata

## Usage

``` r
summaryEstimates(result, output = "console")
```

## Arguments

- result:

  A \`summarised_result\` object.

- output:

  Character vector, it can be:

  - `"console"` to print the summary in the console.

  - `"text"` to return a character vector.

  - `"show"` to show the result in the viewer (html format).

  - Otherwise `output` will be used as the name of an `'.md'` file to
    write the report in.

## Value

A character vector describing estimate/strata groupings and result ids.
