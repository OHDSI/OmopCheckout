# Summarise estimate types by result type in a summarised_result object

For each unique \`result_type\` in the result settings, reports which
estimate names are present along with their row counts and percentage of
the total.

## Usage

``` r
summaryEstimates(result, output = "console")
```

## Arguments

- result:

  A \`summarised_result\` object.

- output:

  A single character string specifying where to send the output. It can
  be:

  - `"console"` to print the summary in the console.

  - `"text"` to return the summary as a character string.

  - `"show"` to display the result in the viewer (HTML format).

  - Otherwise `output` will be used as the name of an `'.md'` file to
    write the report to.

## Value

A character string containing the estimates summary, returned invisibly
unless `output = "text"`.
