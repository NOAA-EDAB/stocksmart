#' Find reference points for a species stock
#'
#' Filters the Summary data to find species reference point information
#'
#' @param stock Numeric or Character. Stock id number, found using  \code{\link{get_species_itis}}
#' @param ref_point Character string. The name of the reference point eg ("bmsy", "fmsy")
#'
#' @return  data frame
#' \item{ref_point}{`ref_point` selected by user}
#' \item{assessment_year}{The year of the assessment}
#' \item{assessment_type}{Type of assessment conducted}
#' \item{assessment_model}{Type of assessment model used}
#'
#' @importFrom rlang .data
#'
#' @examples
#' # Get fmsy reference point for stock_id = 10509 (Atlantic cod - Georges Bank)
#' get_reference_points(stock = 10509, ref_point = "fmsy")
#' get_reference_points(stock = "10509", ref_point = "bmsy")
#'
#' @export

get_reference_points <- function(
  stock = NULL,
  ref_point = "bmsy"
) {
  # check for nulls
  if (is.null(stock)) {
    stop("stock_id can not be null. Please see get_species_itis()")
  }
  # convert to numeric
  stock <- as.numeric(stock)
  if (!(stock %in% stocksmart::stock_assessment_summary$stock_id)) {
    stop("Not a valid stock id. Please see get_species_itis()")
  }
  # check for valid reference point
  ref_point <- tolower(ref_point)
  if (!(ref_point %in% names(stocksmart::stock_assessment_summary))) {
    stop(
      " Please enter a valid reference point name. See the stock_assessment_summary data object"
    )
  }

  res <- stocksmart::stock_assessment_summary |>
    dplyr::filter(stock_id == stock) |>
    dplyr::select(
      {{ ref_point }},
      assessment_year,
      assessment_type,
      assessment_model
    ) |>
    dplyr::arrange(assessment_year)

  return(res)
}
