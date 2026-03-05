# Check suppression correctness for each result_id

For each unique \`result_id\` in \`result\`, checks whether suppression
is applied and produces messages describing whether suppression is
correct.

## Usage

``` r
summarySuppress(result)
```

## Arguments

- result:

  A \`summarised_result\` object.

## Value

A character vector of messages (one per checked result id).
