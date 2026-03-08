# Summarise package usage in the result

Produces one-line summaries per package/version indicating number of
rows and which result_ids each package/version covers.

## Usage

``` r
summaryPackages(result, output = "console")
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

A character vector of package summary strings.
