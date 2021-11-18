#' Filter most recent time series data
#'
#' Pulls the most recent full stock assessment data.
#' Often a benchmark or a Full update contains the longest time series of data
#' whereas partial updates only contain data since last benchmark.
#' The most recent year in which Abundance, Catch, Fmort, Recruitment are present is returned for each species
#'
#' @param itis Numeric vector. Species ITIS code (Default = NULL, all species)
#'
#' @return list of 2 data frames:
#' \item{data}{Data frame consisting of time series values of the most recent Benchmark or Full update for the metrics Abundance, Fmort, Recruitment, and Catch.}
#' \item{summary}{Summary of data returned in \code{data}. StockName, CommonName, StockArea, ITIS, Metric in addition to the
#' AssessmentYear the data came from, the FirstYear and LastYear of the data and the number of years (numYear) of data retrieved}
#'
#' @importFrom magrittr "%>%"
#' @importFrom rlang .data
#'
#' @export

get_latest_full_assessment <- function(itis=NULL) {

  allData <- stocksmart::stockAssessmentData %>%
    dplyr::filter(.data$UpdateType %in% c("Benchmark","Full Update"))

  # find all distinct ITIS codes
  itiscodes <- allData %>%
    dplyr::distinct(.data$ITIS) %>%
    tidyr::drop_na() %>%
    dplyr::pull()

  # find the first and last year of each assessment
  allStats <- allData %>%
    dplyr::group_by(.data$StockName,.data$CommonName,.data$StockArea,.data$ITIS,
                    .data$Metric,.data$AssessmentYear) %>%
    dplyr::summarise(FirstYear = min(.data$Year), LastYear = max(.data$Year),
                     numYears = .data$LastYear-.data$FirstYear + 1, .groups="drop") %>%
    dplyr::arrange(.data$ITIS,.data$StockName,.data$AssessmentYear,.data$Metric)

  # find assessment years in which all 4 metrics are reported. then select the most recent year
  # and join the last year, first year to the df
  stats <- allStats %>%
    dplyr::group_by(.data$StockName,.data$CommonName,.data$StockArea,.data$ITIS,
                    .data$AssessmentYear) %>%
    dplyr::summarise(sumMetric = dplyr::n(),.groups="drop") %>%
    dplyr::filter(.data$sumMetric == 4) %>%
    dplyr::filter(.data$AssessmentYear == max(.data$AssessmentYear)) %>%
    dplyr::left_join(.,allStats,by = c("StockName","ITIS","CommonName","StockArea","AssessmentYear")) %>%
    dplyr::select(-.data$sumMetric)

  # select the full time series for the most recent assessments that have all 4 metrics reported
  data <- stats %>%
    dplyr::left_join(.,allData,by=c("StockName","ITIS","CommonName","StockArea","Metric","AssessmentYear"))

  # if itis = Null, finished. otherwise filter by itis codes supplied by user
  if (!is.null(itis)) {
    # check for missing itis
    missingCodes <- setdiff(itis,itiscodes)
    if (length(missingCodes) > 0) {
      message("No ITIS codes found for: ",paste0(missingCodes, collapse = ", "))
    }

    stats <- stats %>%
      dplyr::filter(.data$ITIS %in% itis)
    data <- data %>%
      dplyr::filter(.data$ITIS %in% itis)

  }

  return(list(data = data, summary=stats))

}
