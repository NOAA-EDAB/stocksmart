#' Find the available assessment times eries data
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
#' \item{nYrs}{Average number of years data (of Abundance, Catch, Recruitment, Fmort). Some assessments have differeing lengths of time series.  }
#'
#'
#' @importFrom magrittr "%>%"
#' @importFrom rlang .data
#'
#' @export

get_available_ts <- function(itis=NULL, jurisdiction=NULL) {


  #error check for metric names
  if (is.null(itis) | is.null(jurisdiction) ) {
    stop("If you do not know the ITIS code or jurisdiction then please use get_species_itis function")
  }

  # find the first and last year of each assessment

  res <- stocksmart::stockAssessmentData %>%
    dplyr::filter(.data$ITIS == itis, .data$Jurisdiction == jurisdiction) %>%

    dplyr::group_by(.data$StockName,.data$CommonName,.data$Jurisdiction,.data$StockArea,.data$ITIS,
                    .data$Metric,.data$AssessmentYear) %>%
    dplyr::summarise(FirstYear = min(.data$Year), LastYear = max(.data$Year),
                     numYears = .data$LastYear-.data$FirstYear + 1, .groups="drop")  %>%
    dplyr::group_by(.data$StockName,.data$Jurisdiction,.data$ITIS,.data$AssessmentYear) %>%
    dplyr::summarise(nYrs = mean(.data$numYears),.groups="drop")


  return(res)


}
