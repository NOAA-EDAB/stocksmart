# Pulls the most recent data for any combination of Abundance, Catch, Recruitment, Mort

Pulls the most recent data for set of metrics provided. Often a
benchmark or a Full update contains the longest time series of data
whereas partial updates only contain data since last benchmark. Data is
pulled from assessments defined as Operational. See
[`stockAssessmentData`](https://noaa-edab.github.io/stocksmart/reference/stockAssessmentData.md)

## Usage

``` r
get_latest_metrics(itis = NULL, metrics = c("Catch", "Abundance"))
```

## Arguments

- itis:

  Numeric vector. Species ITIS code (Default = NULL, all species)

- metrics:

  Character vector. The metrics for which data are required
  ("Catch","Abundance","Fmort","Recruitment"). Default =
  c("Catch","Abundance"). All selected metrics must be available for a
  successful data pull for each species.

## Value

list of 2 data frames:

- data:

  Data frame consisting of time series values of the most recent
  Benchmark or Full update for the requested metrics.

- summary:

  Summary of data returned in `data`. StockName, CommonName, StockArea,
  ITIS, Metric in addition to the AssessmentYear the data came from, the
  FirstYear and LastYear of the data and the number of years (numYear)
  of data retrieved

## Incomplete Results

The document "Implementing a Next Generation Stock Assessment
Enterprise" (NOAA, 2018) provides classification categories for
assessments completed in FY2019 and later to offer a consistent language
for the types of assessment analyses conducted.
