#' Abundance, Catch, Fishing mortality, Recruitment for USA assessed stocks
#'
#' Stock assessment data for species found in waters of the USA. Data is provided for actively managed stocks of a federal Fisheries Management Plan (FMP). Stocks solely managed by US States are not provided.
#'
#' @format A data frame with n rows and m variables
#'
#' \describe{
#'   \item{StockName}{Species name and stock area for the assessed species}
#'   \item{CommonName}{Common name for species}
#'   \item{ScientificName}{Scientific name for species}
#'   \item{ITIS}{Species ITIS Taxon Serial Number }
#'   \item{StockArea}{Stock Area: The region in which the species is assessed}
#'   \item{Year}{Year the data was collected/generated}
#'   \item{Value}{Value of \code{Metric}}
#'   \item{Metric}{Typeof metric: Abundance of species, Index of Biomass, Catch, Recruitment of juvenile individuals, Fmort - Fishing mortality}
#'   \item{Description}{Description of \code{Metric}}
#'   \item{Units}{Units of \code{Value}}
#'   \item{AssessmentYear}{Year of Assessment from which the data was obtained}
#'   \item{FMP}{Fisheries management plan species is managed under}
#'   \item{RegionalEcosystem}{The Regional Ecosystem wher stock is found. There are 8 ecosystems defined around the coastal margins of the United States}
#'   \item{Jurisdiction}{The Fishery Management Council or other group responsible for managing this stock}
#'   \item{UpdateType}{Describes the level of assessment effort.
#'    Used for assessments completed in 2018 and earlier.
#'    New, Benchmark, Full Update, Partial Update}
#'
#'
#'
#' }
#'
#' @source \url{https://www.st.nmfs.noaa.gov/stocksmart?app=browse_by_stock}
#'
#' @family stockAssessments
#'
#' @section Data download:
#'
#' The data were downloaded from [Stock SMART](https://www.st.nmfs.noaa.gov/stocksmart?app=browse_by_stock) - Status, Management, Assessments & Resource Trends. Follow these steps:
#'
#' 1. Click the "Download Data" module
#' 2. Select data to download (dropdown) -> Assessment Time Series Data
#' 3. Click Search Stocks button
#' 4. Click Select All Stocks button
#' 5. Click Select All Asmts button
#' 5. Click Download button
#' 6. Download all Parts
#'
#'
#'
"stockAssessmentData"
