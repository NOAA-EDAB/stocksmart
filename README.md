
<!-- README.md is generated from README.Rmd. Please edit that file -->

# stocksmart <img src="man/figures/logo.png" align="right" width="120" />

<!-- badges: start -->

[![gh-pages](https://github.com/NOAA-EDAB/stocksmart/workflows/gh-pages/badge.svg)]((https://github.com/NOAA-EDAB/stocksmart/actions))
[![gitleaks](https://github.com/NOAA-EDAB/stocksmart/workflows/gitleaks/badge.svg)]((https://github.com/NOAA-EDAB/stocksmart/actions))
[![R-CMD-check](https://github.com/NOAA-EDAB/stocksmart/workflows/R-CMD-check/badge.svg)](https://github.com/NOAA-EDAB/stocksmart/actions)

<!-- badges: end -->
<!--ATTENTION:  **NOAA Stock SMART system is undergoing some structural changes. Until this has been finalized and tested, the state of this repo has been frozen in time from November 27, 2024.** -->

Stock assessments reports are typically lengthy documents containing a
great deal of information. This repo contains time series data for all
Federally assessed stocks in the United States. The following time
series are available:

- Catch - By weight or by number of individuals (species specific)
- Abundance - By weight or by number of individuals (species specific)
- Index - An index of abundance (shrimp only)
- Recruitment - By weight or by number of individuals (species specific)
- Fishing mortality

Summary statistics for these assessments are also available (FMSY, BMSY,
Ftarget etc) in addition to metadata (Stock Name, Stock Area,
Jurisdiction, Point of contact, Year of assessment etc)

The data are extracted and processed from NOAA’s [Stock
SMART](https://apps-st.fisheries.noaa.gov/stocksmart) web based data
portal (<https://apps-st.fisheries.noaa.gov/stocksmart>).

Any data issues found in this package should first be checked with the
web based data portal. If this data package reflects the data found in
the web portal please send emails to `Stock.SMART@noaa.gov`. Otherwise
please create an
[issue](https://github.com/NOAA-EDAB/stocksmart/issues/new/choose)

*Date of most recent data pull: 2025-05-07 17:47:04*

Note: Data is retrieved and processed every Wednesday at 1200 EST. Any
changes to the [Stock
SMART](https://apps-st.fisheries.noaa.gov/stocksmart) website will be
reflected in this data package at that time. The history of changes can
be found in the
[changelog](https://noaa-edab.github.io/stocksmart/news/index.html)

## Feature requests/Data Issues/Bugs

If you find any [issue with the
data](https://github.com/NOAA-EDAB/stocksmart/issues/new/choose),
[bugs](https://github.com/NOAA-EDAB/stocksmart/issues/new/choose) in any
of the code, or want to request [new
features](https://github.com/NOAA-EDAB/stocksmart/issues/new/choose)
please let us know

## Usage

### Installation

`remotes::install_github("NOAA-EDAB/stocksmart")`

or

`pak::pak("NOAA-EDAB/stocksmart")`

### Getting started

Please see the [getting started guide](articles/stocksmart.html)

## Contact

| [andybeet](https://github.com/andybeet)                                                                        |
|----------------------------------------------------------------------------------------------------------------|
| [![andybeet avatar](https://avatars1.githubusercontent.com/u/22455149?s=100&v=4)](https://github.com/andybeet) |

#### Legal disclaimer

*This repository is a scientific product and is not official
communication of the National Oceanic and Atmospheric Administration, or
the United States Department of Commerce. All NOAA GitHub project code
is provided on an ‘as is’ basis and the user assumes responsibility for
its use. Any claims against the Department of Commerce or Department of
Commerce bureaus stemming from the use of this GitHub project will be
governed by all applicable Federal law. Any reference to specific
commercial products, processes, or services by service mark, trademark,
manufacturer, or otherwise, does not constitute or imply their
endorsement, recommendation or favoring by the Department of Commerce.
The Department of Commerce seal and logo, or the seal and logo of a DOC
bureau, shall not be used in any manner to imply endorsement of any
commercial product or activity by DOC or the United States Government.*

<img src="https://raw.githubusercontent.com/nmfs-general-modeling-tools/nmfspalette/main/man/figures/noaa-fisheries-rgb-2line-horizontal-small.png" height="75" alt="NOAA Fisheries">

[U.S. Department of Commerce](https://www.commerce.gov/) \| [National
Oceanographic and Atmospheric Administration](https://www.noaa.gov) \|
[NOAA Fisheries](https://www.fisheries.noaa.gov/)
