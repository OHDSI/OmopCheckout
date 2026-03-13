# Check a summarised_result object

Runs a full audit of a \`summarised_result\` object, covering
suppression status, package metadata, and estimate types. The report can
be printed to the console, returned as text, shown in the RStudio
viewer, or saved to a Markdown file.

## Usage

``` r
checkout(result, output = "console")
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

A character string containing the summary of all checks, returned
invisibly unless `output = "text"`.
