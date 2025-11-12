# Package index

## Data

Lazydata bundled along with the package

- [`stockAssessmentData`](https://noaa-edab.github.io/stocksmart/reference/stockAssessmentData.md)
  : Abundance, Catch, Fishing mortality, Recruitment for USA assessed
  stocks
- [`stockAssessmentSummary`](https://noaa-edab.github.io/stocksmart/reference/stockAssessmentSummary.md)
  : Reference points, contact info, assessment metadata for USA assessed
  stocks

## Filtering functions

Functions used to help user extract information from the bundled data

- [`get_latest_full_assessment()`](https://noaa-edab.github.io/stocksmart/reference/get_latest_full_assessment.md)
  : Pulls the most recent full stock assessment data.
- [`get_latest_metrics()`](https://noaa-edab.github.io/stocksmart/reference/get_latest_metrics.md)
  : Pulls the most recent data for any combination of Abundance, Catch,
  Recruitment, Mort
- [`get_available_ts()`](https://noaa-edab.github.io/stocksmart/reference/get_available_ts.md)
  : Find the available assessment time series data
- [`get_species_itis()`](https://noaa-edab.github.io/stocksmart/reference/get_species_itis.md)
  : Find the species itis

## Plotting functions

Functions used to help user visualize the bundled data

- [`plot_ts()`](https://noaa-edab.github.io/stocksmart/reference/plot_ts.md)
  : Plot time series data for a particular species
