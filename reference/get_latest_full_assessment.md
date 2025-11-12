# Pulls the most recent full stock assessment data.

Often a benchmark or a Full update contains the longest time series of
data whereas partial updates only contain data since last benchmark. The
most recent year in which Abundance, Catch, Fmort, Recruitment are
present is returned for each species

## Usage

``` r
get_latest_full_assessment(itis = NULL)
```

## Arguments

- itis:

  Numeric vector. Species ITIS code (Default = NULL, all species)

## Value

list of 2 data frames:

- data:

  Data frame consisting of time series values of the most recent
  Benchmark or Full update for the metrics Abundance, Fmort,
  Recruitment, and Catch.

- summary:

  Summary of data returned in `data`. StockName, CommonName, StockArea,
  ITIS, Metric in addition to the AssessmentYear the data came from, the
  FirstYear and LastYear of the data and the number of years (numYear)
  of data retrieved
