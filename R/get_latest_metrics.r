#' Pulls the most recent data for any combination of Abundance, Catch,
#' Recruitment, Mort
#'
#' @description
#' Pulls the most recent data for set of metrics provided.
#' Often a benchmark or a Full update contains the longest time series of data
#' whereas partial updates only contain data since last benchmark.
#' Data is pulled from assessments defined as Operational.
#' See \code{\link{stockAssessmentData}}
#'
#' @section Incomplete Results:
#'
#' The document "Implementing a Next Generation Stock Assessment Enterprise"
#' (NOAA, 2018) provides classification categories for assessments completed
#'  in FY2019 and later to offer a consistent language for the types of
#'   assessment analyses conducted.
#'
#'
#'
#' @param itis Numeric vector. Species ITIS code (Default = NULL, all species)
#' @param metrics Character vector. The metrics for which data are required
#' ("Catch","Abundance","Fmort","Recruitment").
#' Default = c("Catch","Abundance"). All selected metrics must be available
#' for a successful data pull for each species.
#'
#' @return list of 2 data frames:
#' \item{data}{Data frame consisting of time series values of the most recent
#'  Benchmark or Full update for the requested metrics.}
#' \item{summary}{Summary of data returned in \code{data}. StockName,
#' CommonName, StockArea, ITIS, Metric in addition to the AssessmentYear
#' the data came from, the FirstYear and LastYear of the data and the number
#'  of years (numYear) of data retrieved}
#'
#' @importFrom rlang .data
#'
#' @export

get_latest_metrics <- function(itis = NULL, metrics = c("Catch", "Abundance")) {
  itis_code <- itis
  #error check for metric names
  if (!all(metrics %in% c("Catch", "Abundance", "Fmort", "Recruitment"))) {
    stop(
      "Please check the spelling of metrics used. Only \"Catch\",
         \"Abundance\",\"Fmort\",\"Recruitment\" are permitted"
    )
  }

  # Filter Operational Assesments (old codes = New, Full Updates,
  #Benchmark assessments)
  allData <- stocksmart::stock_assessment_data |>
    dplyr::filter(
      .data$assessment_type %in%
        c(
          "New",
          "Benchmark",
          "Full Update",
          "Research & Operational",
          "Operational"
        )
    )

  # find all distinct ITIS codes
  itiscodes <- allData |>
    dplyr::distinct(.data$itis) |>
    tidyr::drop_na() |>
    dplyr::pull()

  # find the first and last year of each assessment
  allStats <- allData |>
    dplyr::group_by(
      .data$stock_name,
      .data$common_name,
      .data$stock_area,
      .data$itis,
      .data$metric,
      .data$assessment_year,
      .data$regional_ecosystem
    ) |>
    dplyr::summarise(
      FirstYear = min(.data$year),
      LastYear = max(.data$year),
      numYears = .data$LastYear - .data$FirstYear + 1,
      .groups = "drop"
    ) |>
    dplyr::arrange(
      .data$itis,
      .data$stock_name,
      .data$assessment_year,
      .data$metric
    )

  # find assessment years in which all selected metrics are reported.
  # Then select the most recent year, join the last year, first year to the df
  statsprep <- allStats |>
    dplyr::filter(.data$metric %in% metrics) |>
    dplyr::group_by(
      .data$stock_name,
      .data$common_name,
      .data$stock_area,
      .data$itis,
      .data$assessment_year,
      .data$regional_ecosystem
    ) |>
    dplyr::summarise(sumMetric = dplyr::n(), .groups = "drop") |>
    dplyr::filter(sumMetric == length(metrics)) |>
    dplyr::group_by(
      .data$stock_name,
      .data$common_name,
      .data$stock_area,
      .data$itis
    ) |>
    dplyr::filter(.data$assessment_year == max(.data$assessment_year))

  stats <- dplyr::left_join(
    statsprep,
    allStats,
    by = c(
      "stock_name",
      "itis",
      "common_name",
      "stock_area",
      "assessment_year",
      "regional_ecosystem"
    )
  ) |>
    dplyr::select(-sumMetric) |>
    dplyr::filter(.data$metric %in% metrics) |>
    dplyr::ungroup()

  # select the full time series for the most recent assessments that have
  #all 4 metrics reported
  data <- dplyr::left_join(
    stats,
    allData,
    by = c(
      "stock_name",
      "itis",
      "common_name",
      "stock_area",
      "metric",
      "assessment_year",
      "regional_ecosystem"
    )
  )

  # if itis = Null, finished. otherwise filter by itis codes supplied by user
  if (!is.null(itis_code)) {
    # check for missing itis
    missingCodes <- setdiff(itis_code, itiscodes)
    if (length(missingCodes) > 0) {
      message(
        "No ITIS codes found for: ",
        paste0(missingCodes, collapse = ", ")
      )
    }

    stats <- stats |>
      dplyr::filter(.data$itis %in% itis_code)
    data <- data |>
      dplyr::filter(.data$itis %in% itis_code)
  }

  return(list(data = data, summary = stats))
}
