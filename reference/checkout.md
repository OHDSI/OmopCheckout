# Check a summarised_result object

Check a summarised_result object

## Usage

``` r
checkout(result, output = "console")
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

Whether the result object passes the checks or not.
