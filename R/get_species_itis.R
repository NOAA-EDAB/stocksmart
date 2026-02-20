#' Find the species itis
#'
#' Filters the Summary data to find species stock information
#'
#' @param itis Numeric vector. Species itis code (Default = NULL, all species)
#' @param stock Vector. Either a character string or numeric in which to use to search for stock name or stock id
#'
#' @return  data frame
#' \item{stock_name}{Full name of stock}
#' \item{jurisdiction}{Management council}
#' \item{itis}{species itis code}
#' \item{stock_id}{stock id code}
#'
#' @importFrom rlang .data
#'
#' @examples
#' # Get ITIS info for Atlantic Cod, (ITIS code = 1647112)
#' get_species_itis(stock = "Atlantic cod")
#' get_species_itis(stock = "cod")
#' get_species_itis(itis = 167712)
#' # Get ITIS info for a specific cod stock
#' get_species_itis(stock = "12805")
#' get_species_itis(stock = 12805)
#'
#' @export

get_species_itis <- function(itis = NULL, stock = NULL) {
  # Error check for metric names
  itis_code <- itis
  if (is.null(itis_code) & is.null(stock)) {
    return(
      "If you do not know the `itis` code then please enter a value for the `stock` argument. A character string of any part of the stock name.  eg stock = \"Albacore\", stock = \"Cape Cod\""
    )
  }

  if (!is.null(itis_code)) {
    res <- stocksmart::stock_assessment_summary |>
      dplyr::filter(.data$itis == itis_code) |>
      dplyr::distinct(
        .data$stock_name,
        .data$jurisdiction,
        .data$itis,
        .data$stock_id
      )
  } else if (!is.null(stock)) {
    res <- stocksmart::stock_assessment_summary |>
      dplyr::filter(
        (grepl(stock, .data$stock_name) | .data$stock_id == stock)
      ) |>
      dplyr::distinct(
        .data$stock_name,
        .data$jurisdiction,
        .data$itis,
        .data$stock_id
      )
  }

  return(res)
}
