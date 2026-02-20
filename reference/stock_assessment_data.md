# Abundance, Catch, Fishing mortality, Recruitment for USA assessed stocks

Stock assessment data for species found in waters of the USA. Data is
provided for actively managed stocks of a federal Fisheries Management
Plan (FMP). Stocks solely managed by US States are not provided.

## Usage

``` r
stock_assessment_data
```

## Format

A data frame

- stock_name:

  Species name and stock area for the assessed species

- stock_id:

  Unique stock identifier

- assessment_id:

  Unique assessment identifier

- common_name:

  Common name for species

- scientific_name:

  Scientific name for species

- itis:

  Species ITIS Taxon Serial Number

- stock_area:

  Stock Area: The region in which the species is assessed

- year:

  Year the data was collected/generated

- value:

  Value of `Metric`

- metric:

  Typeof metric: Abundance of species, Index of Biomass, Catch,
  Recruitment of juvenile individuals, Fmort - Fishing mortality

- description:

  Description of `Metric`

- units:

  Units of `Value`

- assessment_year:

  Year of Assessment from which the data was obtained

- fmp:

  Fisheries management plan species is managed under

- regional_ecosystem:

  The Regional Ecosystem wher stock is found. There are 8 ecosystems
  defined around the coastal margins of the United States

- jurisdiction:

  The Fishery Management Council or other group responsible for managing
  this stock

- assessment_type:

  Describes the level of assessment effort. For assessments completed
  prior to 2018 :New, Benchmark, Full Update, Partial Update, for post
  2018: Operational, Stock Monitoring Update, Research & Operational

## Source

<https://apps-st.fisheries.noaa.gov/stocksmart?app=homepage>

## Data download

The data were downloaded from [Stock
SMART](https://apps-st.fisheries.noaa.gov/stocksmart?app=browse-by-stock) -
Status, Management, Assessments & Resource Trends.

## See also

Other stockAssessments:
[`stockAssessmentData`](https://noaa-edab.github.io/stocksmart/reference/stockAssessmentData.md),
[`stockAssessmentSummary`](https://noaa-edab.github.io/stocksmart/reference/stockAssessmentSummary.md),
[`stock_assessment_summary`](https://noaa-edab.github.io/stocksmart/reference/stock_assessment_summary.md)
