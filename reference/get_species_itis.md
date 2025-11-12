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

  Character vector. String in which to use to search for stock

## Value

data frame (n x 3)

- StockName:

  Full name of stock

- Jurisdiction:

  Management council

- ITIS:

  species itis code
