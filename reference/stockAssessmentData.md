# Abundance, Catch, Fishing mortality, Recruitment for USA assessed stocks

Stock assessment data for species found in waters of the USA. Data is
provided for actively managed stocks of a federal Fisheries Management
Plan (FMP). Stocks solely managed by US States are not provided.

## Usage

``` r
stockAssessmentData
```

## Format

A data frame with n rows and m variables

- StockName:

  Species name and stock area for the assessed species

- Stockid:

  Unique stock identifier

- Assessmentid:

  Unique assessment identifier

- CommonName:

  Common name for species

- ScientificName:

  Scientific name for species

- ITIS:

  Species ITIS Taxon Serial Number

- StockArea:

  Stock Area: The region in which the species is assessed

- Year:

  Year the data was collected/generated

- Value:

  Value of `Metric`

- Metric:

  Typeof metric: Abundance of species, Index of Biomass, Catch,
  Recruitment of juvenile individuals, Fmort - Fishing mortality

- Description:

  Description of `Metric`

- Units:

  Units of `Value`

- AssessmentYear:

  Year of Assessment from which the data was obtained

- FMP:

  Fisheries management plan species is managed under

- RegionalEcosystem:

  The Regional Ecosystem wher stock is found. There are 8 ecosystems
  defined around the coastal margins of the United States

- Jurisdiction:

  The Fishery Management Council or other group responsible for managing
  this stock

- AssessmentType:

  Describes the level of assessment effort. For assessments completed
  prior to 2018 :New, Benchmark, Full Update, Partial Update, for post
  2018: Operational, Stock Monitoring Update, Research & Operational

## Source

<https://apps-st.fisheries.noaa.gov/stocksmart?app=homepage>

## Data download

The data were downloaded from [Stock
SMART](https://apps-st.fisheries.noaa.gov/stocksmart?app=browse-by-stock) -
Status, Management, Assessments & Resource Trends.

For Manual download:

1.  Click the "Download Data" module

2.  Select data to download (dropdown) -\> Assessment Time Series Data

3.  Click Search Stocks button

4.  Click Select All Stocks button

5.  Click Select All Asmts button

6.  Click Download button

7.  Download all Parts

## See also

Other stockAssessments:
[`stockAssessmentSummary`](https://noaa-edab.github.io/stocksmart/reference/stockAssessmentSummary.md)
