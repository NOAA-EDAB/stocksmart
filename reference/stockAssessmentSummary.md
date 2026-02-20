# Reference points, contact info, assessment metadata for USA assessed stocks

**\[deprecated\]**

`stockAssessmentSummary` is deprecated and will be removed in the next
major release (1.0.0). Camel case is being replaced by snake case.
Please use
[stock_assessment_summary](https://noaa-edab.github.io/stocksmart/reference/stock_assessment_summary.md)
instead.

Stock assessment metadata and reference points for species found in
waters of the USA. Data is provided for actively managed stocks of a
federal Fisheries Management Plan (FMP). Stocks solely managed by US
States are not provided. For a description of all variables please refer
to the Stock SMART data dictionary
<https://apps-st.fisheries.noaa.gov/stocksmart/StockSMART_DataDictionary.pdf>

## Usage

``` r
stockAssessmentSummary
```

## Format

A data frame with n rows and m variables

- Stock Name:

- Stock ID:

  Unique Stock identifier

- Assessment ID:

  Unique Assessment identifer

- Jurisdiction:

- FMP:

- Science Center:

- Regional Ecosystem:

- FSSI Stock?:

- ITIS Taxon Serial Number:

- Scientific Name:

- Common Name:

- Stock Area:

- Assessment Year:

- Assessment Month:

- Last Data Year :

- Assessment Type:

  Joining of Update Type and Assessment Type: Describes the level of
  assessment effort

- Review Result :

- Assessment Model:

- Model Version:

- Lead Lab :

- Citation:

- Final Assessment Report 1:

- Final Assessment Report 2:

- Point of Contact:

- Life History Data:

- Abundance Data:

- Catch Data:

- Assessment Level:

- Assessment Frequency:

- Model Category :

- Catch Input Data:

- Abundance Input Data:

- Biological Input Data:

- Ecosystem Linkage:

- Composition Input Data:

- F Year:

- Estimated F:

- F Unit:

- F Basis:

- Flimit:

- Flimit Basis:

- Fmsy:

- Fmsy Basis:

- F/Flimit:

- F/Fmsy:

- Ftarget:

- Ftarget Basis:

- F/Ftarget:

- B Year:

- Estimated B :

- B Unit :

- B Basis :

- Blimit :

- Blimit Basis:

- Bmsy:

- Bmsy Basis:

- B/Blimit:

- B/Bmsy:

- MSY:

- MSY Unit:

## Source

<https://apps-st.fisheries.noaa.gov/stocksmart?app=homepage>

## Data download

The data were downloaded from [Stock
SMART](https://apps-st.fisheries.noaa.gov/stocksmart?app=browse-by-stock) -
Status, Management, Assessments & Resource Trends.

For Manual download:

1.  Click the "Download Data" module

2.  Select data to download (dropdown) -\> Assessment Summary Data

3.  Select full range of years from Start Calendar Year- End Calendar
    Year

4.  Click Search Stocks button

5.  Click Select All Stocks button

6.  Click Select All Fields button

7.  Click Download button

8.  Download all Parts

## See also

Other stockAssessments:
[`stockAssessmentData`](https://noaa-edab.github.io/stocksmart/reference/stockAssessmentData.md),
[`stock_assessment_data`](https://noaa-edab.github.io/stocksmart/reference/stock_assessment_data.md),
[`stock_assessment_summary`](https://noaa-edab.github.io/stocksmart/reference/stock_assessment_summary.md)
