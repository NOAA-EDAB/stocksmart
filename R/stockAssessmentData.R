#' Abundance, Catch, fishing mortalit, Recruitment for USA assessed stocks
#' 
#' Stock assessment data for species found in waters of the USA. Data is provided for actively managed stocks of a federal Fisheries Management Plan (FMP). Stocks solely managed by US States are not provided.
#'
#' @format A dataframe with 45451 rows and 7 variables
#' 
#' \describe{
#'   \item{Species}{Common name for the assessed species}
#'   \item{Region}{Stock Region: The region in which the species is assessed}
#'   \item{Year}{Year the data was collected/generated}
#'   \item{Value}{Value of \code{Metric}}
#'   \item{Metric}{Typeof metric: Abundance of species, Index of Biomass, Catch, Recruitment of juvenile individuals, Fmort - Fishing mortality}
#'   \item{Description}{Description of \code{Metric}}
#'   \item{Units}{Units of \code{Value}}
#' 
#' }
#'
#' @source \url{https://www.st.nmfs.noaa.gov/stocksmart?app=browse_by_stock}
#' 
#' @section Data download:
#' 
#' The data were downloaded from [Stock SMART](https://www.st.nmfs.noaa.gov/stocksmart?app=browse_by_stock) - Status, Management, Assessments & Resource Trends. Follow these steps:
#' 
#' 1. Click the "Download Data" module
#' 2. Select data to download (dropdown) -> Assessment Time Series Data
#' 3. Click Search Stocks button
#' 4. Click Select All Stocks button
#' 5. Click Download All button
#' 6. Download all Parts
#'
#'
#'
"stockAssessmentData"