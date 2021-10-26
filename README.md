
<!-- README.md is generated from README.Rmd. Please edit that file -->

# stocksmart <img src="man/figures/logo.png" align="right" width="120" />

<!-- badges: start -->

![deploy to github
pages](https://github.com/NOAA-EDAB/stocksmart/workflows/deploy%20to%20github%20pages/badge.svg)
![Install on
windows](https://github.com/NOAA-EDAB/stocksmart/workflows/Install%20on%20windows/badge.svg)
![gitleaks](https://github.com/NOAA-EDAB/stocksmart/workflows/gitleaks/badge.svg)
<!-- badges: end -->

Stock assessments reports are typically lengthy documents containing a
great deal of information. This repo contains time series data for all
assessed stocks in the United States. The following time series are
available:

-   Catch - By weight or by number of individuals (species specific)
-   Abundance - By weight or by number of individuals (species specific)
-   Index - An index of abundance (shrimp only)
-   Recruitment - By weight or by number of individuals (species
    specific)
-   Fishing mortality

Summary statistics for these assessments are also available (FMSY, BMSY,
Ftarget etc) in addition to metadata (Stock Name, Stock Area,
Jurisdiction, Point of contact, Year of assessment etc)

The data are extracted and processed from NOAA’s [Stock
SMART](https://www.st.nmfs.noaa.gov/stocksmart?app=homepage) web based
data portal. <sup>1</sup>NOAA Fisheries. 2021. Stock SMART data records.
Retrieved from www.st.nmfs.noaa.gov/stocksmart.

Any data issues found in this package should first be checked with the
web based data portal. If this data package reflects the data found in
the web portal please send emails to `Stock.SMART@noaa.gov`. Otherwise
please create an [issue](https://github.com/NOAA-EDAB/stocksmart/issues)

*Date of most recent data pull: 2021-10-26*

## Contact

| [andybeet](https://github.com/andybeet)                                                         |
|-------------------------------------------------------------------------------------------------|
| [![](https://avatars1.githubusercontent.com/u/22455149?s=100&v=4)](https://github.com/andybeet) |

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
