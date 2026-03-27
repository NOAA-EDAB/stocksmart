# Find reference points for a species stock

Filters the Summary data to find species reference point information

## Usage

``` r
get_reference_points(stock = NULL, ref_point = "bmsy")
```

## Arguments

- stock:

  Numeric or Character. Stock id number, found using
  [`get_species_itis`](https://noaa-edab.github.io/stocksmart/reference/get_species_itis.md)

- ref_point:

  Character string. The name of the reference point eg ("bmsy", "fmsy")

## Value

data frame

- ref_point:

  `ref_point` selected by user

- assessment_year:

  The year of the assessment

- assessment_type:

  Type of assessment conducted

- assessment_model:

  Type of assessment model used

## Examples

``` r
# Get fmsy reference point for stock_id = 10509 (Atlantic cod - Georges Bank)
get_reference_points(stock = 10509, ref_point = "fmsy")
#> # A tibble: 9 × 4
#>     fmsy assessment_year assessment_type assessment_model
#>    <dbl>           <dbl> <chr>           <chr>           
#> 1  0.180            2005 Full Update     VPA             
#> 2  0.25             2008 Benchmark       VPA             
#> 3  0.230            2012 Full Update     VPA             
#> 4  0.180            2013 Benchmark       ASAP            
#> 5 NA                2015 Full Update     ASAP            
#> 6 NA                2017 Full Update     Plan B Smooth   
#> 7 NA                2019 Operational     Plan B Smooth   
#> 8 NA                2021 Operational     PlanBSmooth     
#> 9  0.230            2024 Operational     WHAM            
get_reference_points(stock = "10509", ref_point = "bmsy")
#> # A tibble: 9 × 4
#>     bmsy assessment_year assessment_type assessment_model
#>    <dbl>           <dbl> <chr>           <chr>           
#> 1 217000            2005 Full Update     VPA             
#> 2 148084            2008 Benchmark       VPA             
#> 3 140424            2012 Full Update     VPA             
#> 4 186535            2013 Benchmark       ASAP            
#> 5     NA            2015 Full Update     ASAP            
#> 6     NA            2017 Full Update     Plan B Smooth   
#> 7     NA            2019 Operational     Plan B Smooth   
#> 8     NA            2021 Operational     PlanBSmooth     
#> 9   8290            2024 Operational     WHAM            
```
