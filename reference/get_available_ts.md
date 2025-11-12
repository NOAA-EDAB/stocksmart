# Find the available assessment time series data

Filters the Summary data to find all time series data

## Usage

``` r
get_available_ts(itis = NULL, jurisdiction = NULL)
```

## Arguments

- itis:

  Numeric vector. Species ITIS code (Default = NULL, all species)

- jurisdiction:

  Character string. Management council

## Value

data frame (n x 5)

- StockName:

  Full name of stock

- Jurisdiction:

  Management council

- ITIS:

  species itis code

- AssessmentYear:

  Year of assessment

- nYrs:

  Average number of years data (of Abundance, Catch, Recruitment,
  Fmort). Some assessments have differing lengths of time series.
