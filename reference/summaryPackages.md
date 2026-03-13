# Summarise package usage in a summarised_result object

For each package name and version found in the result settings, reports
the number of rows and result IDs associated with it, broken down by
result type.

## Usage

``` r
summaryPackages(result, output = "console")
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

A character string containing the package summary, returned invisibly
unless `output = "text"`.
