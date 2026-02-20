#' Pulls the most recent full stock assessment data.
#'
#' Often a benchmark or a Full update contains the longest time series of data
#' whereas partial updates only contain data since last benchmark.
#' The most recent year in which Abundance, Catch, Fmort, Recruitment are
#'  present is returned for each species
#'
#' @param itis Numeric vector. Species ITIS code (Default = NULL, all species)
#'
#' @return list of 2 data frames:
#' \item{data}{Data frame consisting of time series values of the most recent
#' Benchmark or Full update for the metrics Abundance, Fmort, Recruitment,
#' and Catch.}
#' \item{summary}{Summary of data returned in \code{data}. StockName,
#' CommonName, StockArea, ITIS, Metric in addition to the
#' AssessmentYear the data came from, the FirstYear and LastYear of the data
#'  and the number of years (numYear) of data retrieved}
#'
#' @importFrom rlang .data
#'
#' @export

get_latest_full_assessment <- function(itis = NULL) {
  itis_code <- itis
  result <- get_latest_metrics(
    itis = itis_code,
    metrics = c("Catch", "Abundance", "Fmort", "Recruitment")
  )

  return(result)
}
