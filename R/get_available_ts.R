#' Find the available assessment time series data
#'
#' Filters the Summary data to find all time series data
#'
#' @param itis Numeric vector. Species ITIS code (Default = NULL, all species)
#' @param jurisdiction Character string. Management council
#'
#' @return  data frame (n x 5)
#' \item{StockName}{Full name of stock}
#' \item{Jurisdiction}{Management council}
#' \item{ITIS}{species itis code}
#' \item{AssessmentYear}{Year of assessment}
#' \item{nYrs}{Average number of years data (of Abundance, Catch, Recruitment,
#' Fmort). Some assessments have differing lengths of time series.  }
#'
#'
#' @importFrom rlang .data
#'
#' @export

get_available_ts <- function(itis = NULL, jurisdiction = NULL) {
  itis_code <- itis
  jurisdiction_code <- jurisdiction
  # Error check for metric names
  if (is.null(itis_code) || is.null(jurisdiction_code)) {
    return(
      "If you do not know the `itis` code or `jurisdiction` then please use `get_species_itis` function"
    )
  }

  # Pull filter the data to determine if present
  tsData <- stocksmart::stock_assessment_data |>
    dplyr::filter(
      .data$itis == itis_code,
      .data$jurisdiction == jurisdiction_code
    )

  if (nrow(tsData) == 0) {
    stop(
      "No data found. Either the itis or jurisdiction is not entered
    correctly. Please check your inputs or use get_species_itis() to find the
            correct ITIS code and jurisdiction."
    )
  }

  # find the first and last year of each assessment
  res <- tsData |>

    dplyr::group_by(
      .data$stock_name,
      .data$common_name,
      .data$jurisdiction,
      .data$stock_area,
      .data$itis,
      .data$metric,
      .data$assessment_year
    ) |>
    dplyr::summarise(
      FirstYear = min(.data$year),
      LastYear = max(.data$year),
      numYears = .data$LastYear - .data$FirstYear + 1,
      .groups = "drop"
    ) |>
    dplyr::group_by(
      .data$stock_name,
      .data$jurisdiction,
      .data$itis,
      .data$assessment_year
    ) |>
    dplyr::summarise(nYrs = mean(.data$numYears), .groups = "drop")

  return(res)
}
