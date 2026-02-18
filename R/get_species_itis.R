#' Find the species itis
#'
#' Filters the Summary data to find species stock information
#'
#' @param itis Numeric vector. Species ITIS code (Default = NULL, all species)
#' @param stock Vector. Either a characterstring or numeric in which to use to search for stock name or stock id
#'
#' @return  data frame
#' \item{StockName}{Full name of stock}
#' \item{Jurisdiction}{Management council}
#' \item{ITIS}{species itis code}
#' \item{StockID}{stock id code}
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
  if (is.null(itis) & is.null(stock)) {
    return(
      "If you do not know the ITIS code then please enter a value for the
    `stock` argument. A character string of any part of the stock name.
         eg stock = \"Albacore\", stock = \"Cape Cod\""
    )
  }

  if (!is.null(itis)) {
    res <- stocksmart::stockAssessmentSummary |>
      dplyr::filter(.data$`ITIS Taxon Serial Number` == itis) |>
      dplyr::distinct(
        .data$`Stock Name`,
        .data$Jurisdiction,
        .data$`ITIS Taxon Serial Number`,
        .data$`Stock ID`
      )
  } else if (!is.null(stock)) {
    res <- stocksmart::stockAssessmentSummary |>
      dplyr::filter(
        (grepl(stock, .data$`Stock Name`) | .data$`Stock ID` == stock)
      ) |>
      dplyr::distinct(
        .data$`Stock Name`,
        .data$Jurisdiction,
        .data$`ITIS Taxon Serial Number`,
        .data$`Stock ID`
      )
  }

  res <- res |>
    dplyr::rename(
      ITIS = .data$`ITIS Taxon Serial Number`,
      StockName = .data$`Stock Name`,
      StockID = .data$`Stock ID`
    )

  return(res)
}
