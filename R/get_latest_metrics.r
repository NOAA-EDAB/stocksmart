#' Pulls the most recent data for any combination of Abundance, Catch, Recruitment, Mort
#'
#' Pulls the most recent data for set of metrics provided.
#' Often a benchmark or a Full update contains the longest time series of data
#' whereas partial updates only contain data since last benchmark.
#' Data from the most recent Full Update or Benchmark is returned.
#'
#'
#' @param itis Numeric vector. Species ITIS code (Default = NULL, all species)
#' @param metrics Character vector. The metrics for which data are required ("Catch","Abundance","Fmort","Recruitment").
#' Default = c("Catch","Abundance"). All selected metrics must be available for a successful data pull for each species.
#'
#' @return list of 2 data frames:
#' \item{data}{Data frame consisting of time series values of the most recent Benchmark or Full update for the requested metrics.}
#' \item{summary}{Summary of data returned in \code{data}. StockName, CommonName, StockArea, ITIS, Metric in addition to the
#' AssessmentYear the data came from, the FirstYear and LastYear of the data and the number of years (numYear) of data retrieved}
#'
#' @importFrom magrittr "%>%"
#' @importFrom rlang .data
#'
#' @export

get_latest_metrics <- function(itis=NULL, metrics = c("Catch","Abundance")) {


  #error check for metric names
  if (!all(metrics %in% c("Catch","Abundance","Fmort","Recruitment"))) {
    stop("Please check the spelling of metrics used. Only \"Catch\",\"Abundance\",\"Fmort\",\"Recruitment\" are permitted")
  }


  # Filter Full Updates or Benchmark assessments
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


  # find assessment years in which all selected metrics are reported. then select the most recent year
  # and join the last year, first year to the df
  stats <- allStats %>%
    dplyr::filter(.data$Metric %in% metrics) %>%
    dplyr::group_by(.data$StockName,.data$CommonName,.data$StockArea,.data$ITIS,
                    .data$AssessmentYear) %>%
    dplyr::summarise(sumMetric = dplyr::n(),.groups="drop") %>%
    dplyr::filter(.data$sumMetric == length(metrics)) %>%
    dplyr::group_by(.data$StockName,.data$CommonName,.data$StockArea,.data$ITIS) %>%
    dplyr::filter(.data$AssessmentYear == max(.data$AssessmentYear)) %>%
    dplyr::left_join(.,allStats,by = c("StockName","ITIS","CommonName","StockArea","AssessmentYear")) %>%
    dplyr::select(-.data$sumMetric) %>%
    dplyr::filter(.data$Metric %in% metrics) %>%
    dplyr::ungroup()

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