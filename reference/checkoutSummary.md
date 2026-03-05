# Create a markdown-style checkout summary

Generate a small markdown report summarising suppression, packages and
result content for a \`summarised_result\`.

## Usage

``` r
checkoutSummary(result)
```

## Arguments

- result:

  A \`summarised_result\` object.

## Value

Invisibly returns a character vector with the markdown lines (also
printed to console). The value is suitable for writing to an \`.md\`
file.
