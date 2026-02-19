#' Process the Timeseries data from stocksmart website
#'
#' @param dataf data.frame. Exported xlsx data object from stocksmart API
#'
#' @returns A data frame
#'
#' @family processing
#'@noRd

process_stock_tsdata <- function(dataf) {
  stock_tsdata <- NULL
  year <- as.numeric(unlist(dataf[9:nrow(dataf), 2]))
  for (icol in 3:ncol(dataf)) {
    # get metadata for this species. 1st 5 rows of data
    meta <- as.vector(unlist(dataf[1:8, icol]))
    # parse metadata to extract species name, region, metric,
    #Description, Units
    spnm_region <- meta[1]
    stockid <- as.numeric(meta[2])
    assessmentid <- as.numeric(meta[3])
    AssessmentYear <- as.numeric(meta[4])
    AssessmentMonth <- as.numeric(meta[5])
    metric <- meta[6]
    description <- meta[7]
    units <- meta[8]
    # time series data
    ts <- as.numeric(unlist(dataf[9:nrow(dataf), icol]))
    # select years where data is available
    ind <- !is.na(ts)
    Year <- year[ind]
    ts <- ts[ind]
    # length of data available
    nYrs <- length(Year)
    # build a tidy tibble
    species_data <- tibble::tibble(
      StockName = rep(spnm_region, nYrs),
      Stockid = rep(stockid, nYrs),
      Assessmentid = rep(assessmentid, nYrs),
      Year = Year,
      Value = ts,
      Metric = rep(metric, nYrs),
      Description = rep(description, nYrs),
      Units = rep(units, nYrs),
      AssessmentYear = rep(AssessmentYear, nYrs)
    )
    # combine data for this column to master
    stock_tsdata <- rbind(stock_tsdata, species_data)
  }

  return(stock_tsdata)
}
