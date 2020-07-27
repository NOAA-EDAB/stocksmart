#' Abundance, Catch, fishing mortalit, Recruitment for USA assessed stocks
#' 
#' Stock assessment data for many of the species found in waters of the USA
#'
#' @format A datafram with 45451 rows and 7 variables
#' 
#' \describe{
#'   \item{Species}{Common Name}
#'   \item{Region}{Stock Region}
#'   \item{Year}{Year}
#'   \item{Value}{Value of Metric}
#'   \item{Metric}{Abundance, Index, Catch, Recruitment, Fmort}
#'   \item{Description}{Description of Metric}
#'   \item{Units}{Units of \code{Value}}
#' 
#' }
#'
#' @source \url{https://www.st.nmfs.noaa.gov/stocksmart?app=browse_by_stock}
#' 
#' @section Data download:
#' 
#' The data were downloaded from [Stock SMART](https://www.st.nmfs.noaa.gov/stocksmart?app=browse_by_stock) - Status, Management, Assessments & Resource Trends.
#' 
#' 1. Download Data module
#' 2. Select data to download (dropdown) -> Assessment Time Series Data
#' 3. Click Search Stocks button
#' 4. Click Select All Stocks button
#' 5. Click Download All button
#' 6. Download all Parts
#'
#'
#'
"stockAssessmentData"