# Reference points, contact info, assessment metadata for USA assessed stocks

Stock assessment metadata and reference points for species found in
waters of the USA. Data is provided for actively managed stocks of a
federal Fisheries Management Plan (FMP). Stocks solely managed by US
States are not provided.

For a description of all variables please refer to the Stock SMART data
dictionary
<https://apps-st.fisheries.noaa.gov/stocksmart/StockSMART_DataDictionary.pdf>

## Usage

``` r
stock_assessment_summary
```

## Format

A data frame

- stock_name:

- stock_id:

  Unique Stock identifier

- assessment_id:

  Unique Assessment identifer

- jurisdiction:

- fmp:

- science_center:

- regional_ecosystem:

- fssi_stock:

- itis:

- scientific_name:

- common_name:

- stock_area:

- assessment_year:

- assessment_month:

- last_data_year:

- assessment_type:

  Joining of Update Type and Assessment Type: Describes the level of
  assessment effort

- review_result:

- assessment_model:

- model_version:

- lead_lab:

- citation:

- final_assessment_report_1:

- final_assessment_report_2:

- point_of_contact:

- life_history_data:

- abundance_data:

- catch_data:

- assessment_level:

- assessment_frequency:

- model_category:

- catch_input_data:

- abundance_input_data:

- biological_input_data:

- ecosystem_linkage:

- composition_input_data:

- f_year:

- estimated_f:

- f_unit:

- f_basis:

- flimit:

- flimit_basis:

- fmsy:

- fmsy_basis:

- f_over_flimit:

- f_over_fmsy:

- ftarget:

- ftarget_basis:

- f_over_ftarget:

- b_year:

- estimated_b:

- b_unit:

- b_basis:

- blimit:

- blimit_basis:

- bmsy:

- bmsy_basis:

- b_over_blimit:

- b_over_bmsy:

- msy:

- msy_unit:

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
[`stock_assessment_data`](https://noaa-edab.github.io/stocksmart/reference/stock_assessment_data.md)
