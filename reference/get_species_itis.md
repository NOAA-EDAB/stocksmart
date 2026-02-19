# Find the species itis

Filters the Summary data to find species stock information

## Usage

``` r
get_species_itis(itis = NULL, stock = NULL)
```

## Arguments

- itis:

  Numeric vector. Species ITIS code (Default = NULL, all species)

- stock:

  Vector. Either a characterstring or numeric in which to use to search
  for stock name or stock id

## Value

data frame

- StockName:

  Full name of stock

- Jurisdiction:

  Management council

- ITIS:

  species itis code

- StockID:

  stock id code

## Examples

``` r
# Get ITIS info for Atlantic Cod, (ITIS code = 1647112)
get_species_itis(stock = "Atlantic cod")
#> # A tibble: 6 × 4
#>   StockName                            Jurisdiction   ITIS StockID
#>   <chr>                                <chr>         <dbl>   <dbl>
#> 1 Atlantic cod - Eastern Georges Bank  NEFMC        164712   12805
#> 2 Atlantic cod - Eastern Gulf of Maine NEFMC        164712   17281
#> 3 Atlantic cod - Georges Bank          NEFMC        164712   10509
#> 4 Atlantic cod - Gulf of Maine         NEFMC        164712   10508
#> 5 Atlantic cod - Southern New England  NEFMC        164712   17282
#> 6 Atlantic cod - Western Gulf of Maine NEFMC        164712   17280
get_species_itis(stock = "cod")
#> # A tibble: 12 × 4
#>    StockName                            Jurisdiction   ITIS StockID
#>    <chr>                                <chr>         <dbl>   <dbl>
#>  1 Atlantic cod - Eastern Georges Bank  NEFMC        164712   12805
#>  2 Atlantic cod - Eastern Gulf of Maine NEFMC        164712   17281
#>  3 Atlantic cod - Georges Bank          NEFMC        164712   10509
#>  4 Atlantic cod - Gulf of Maine         NEFMC        164712   10508
#>  5 Atlantic cod - Southern New England  NEFMC        164712   17282
#>  6 Atlantic cod - Western Gulf of Maine NEFMC        164712   17280
#>  7 Pacific cod - Aleutian Islands       NPFMC        164711   12745
#>  8 Pacific cod - Bering Sea             NPFMC        164711   12746
#>  9 Pacific cod - Gulf of Alaska         NPFMC        164711   10506
#> 10 Cowcod - Southern California         PFMC         166754   10443
#> 11 Lingcod - Northern Pacific Coast     PFMC         167116   12194
#> 12 Lingcod - Southern Pacific Coast     PFMC         167116   12195
get_species_itis(itis = 167712)
#> # A tibble: 0 × 4
#> # ℹ 4 variables: StockName <chr>, Jurisdiction <chr>, ITIS <dbl>, StockID <dbl>
# Get ITIS info for a specific cod stock
get_species_itis(stock = "12805")
#> # A tibble: 1 × 4
#>   StockName                           Jurisdiction   ITIS StockID
#>   <chr>                               <chr>         <dbl>   <dbl>
#> 1 Atlantic cod - Eastern Georges Bank NEFMC        164712   12805
get_species_itis(stock = 12805)
#> # A tibble: 1 × 4
#>   StockName                           Jurisdiction   ITIS StockID
#>   <chr>                               <chr>         <dbl>   <dbl>
#> 1 Atlantic cod - Eastern Georges Bank NEFMC        164712   12805
```
