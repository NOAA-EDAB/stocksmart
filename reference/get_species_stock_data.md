# Pull real-time species stock data directly from StockSMART API

Pulls data defined by stock directly to obtain current data. For those
who don't want to reinstall the package to get most recent data

## Usage

``` r
get_species_stock_data(itis = NULL, stock = NULL)
```

## Arguments

- itis:

  Numeric vector. Species itis code (Default = NULL, all species)

- stock:

  Character vector. String in which to use to search for stock

## Value

data frame (n x 3)

- stock_name:

  Full name of stock

- jurisdiction:

  Management council

- itis:

  species itis code
