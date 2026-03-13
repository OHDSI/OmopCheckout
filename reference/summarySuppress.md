# Check suppression correctness for each result_id

For each unique \`result_id\` in \`result\`, checks whether suppression
has been applied and reports the minimum cell count used, the number of
rows affected, and the percentage of total results that are suppressed
or unsuppressed.

## Usage

``` r
summarySuppress(result, output = "console")
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

A character string containing the suppression summary, returned
invisibly unless `output = "text"`.
