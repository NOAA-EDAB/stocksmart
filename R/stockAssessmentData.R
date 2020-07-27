#' Abundance, Catch, fishing mortalit, Recruitment for USA assessed stocks
#' 
#' Stock assessment data for species found in waters of the USA. Data is provided for actively managed stocks of a federal Fisheries Management Plan (FMP). Stocks solely managed by US States are not provided.
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