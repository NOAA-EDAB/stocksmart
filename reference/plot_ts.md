# Plot time series data for a particular species

Exploratory plots of Catch, Abundance, F, Recruitment for all
assessments for a particular species

## Usage

``` r
plot_ts(
  itis = NULL,
  stock = NULL,
  metric = "Catch",
  facetplot = FALSE,
  printfig = TRUE
)
```

## Arguments

- itis:

  Numeric. Species ITIS code

- stock:

  Character. Full name of stock (only required if more than one stock
  exists for ITIS code)

- metric:

  Character vector. Specifying which metric to plot (Catch, Abundance,
  Fmort, Recruitment, Index)

- facetplot:

  Boolean. How to plot results. Plot each assessment in its own facet
  (TRUE) or pplot all assessments on a single plot (default = FALSE)

- printfig:

  Boolean. Print figure to figure window (Default = T)

## Value

A list of two items is returned

- plot:

  ggplot object

- data:

  dataframe used in the plotting

## Units

The units of some of the metrics change over time. For example, catch
for one assessment may be presented in metric tons whereas other
assessments may be in thousand metric tons. This is not resolved in the
plotting. When this arises it is best to use `facet = TRUE` since each
facet uses its own yaxis scale
