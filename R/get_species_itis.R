#' Find the species itis
#'
#' Filters the Summary data to find species stock information
#'
#' @param itis Numeric vector. Species ITIS code (Default = NULL, all species)
#' @param stock Character vector. String in which to use to search for stock
#'
#' @return  data frame (n x 3)
#' \item{StockName}{Full name of stock}
#' \item{Jurisdiction}{Management council}
#' \item{ITIS}{species itis code}
#'
#'
#' @importFrom magrittr "%>%"
#' @importFrom rlang .data
#'
#' @export

get_species_itis <- function(itis = NULL, stock = NULL) {


  # Error check for metric names
  if (is.null(itis) & is.null(stock)) {
    stop("If you do not know the ITIS code then please enter a value for the
    `stock` argument. A character string of any part of the stock name.
         eg stock = \"Albacore\", stock = \"Cape Cod\"")
  }

  if (!is.null(itis)) {
    res <- stocksmart::stockAssessmentSummary %>%
      dplyr::filter(.data$`ITIS Taxon Serial Number` == itis) %>%
      dplyr::distinct(.data$`Stock Name`,
                      .data$Jurisdiction,
                      .data$`ITIS Taxon Serial Number`)
  } else if (!is.null(stock)) {
    res <- stocksmart::stockAssessmentSummary %>%
      dplyr::filter(grepl(stock,
                          .data$`Stock Name`)) %>%
      dplyr::distinct(.data$`Stock Name`,
                      .data$Jurisdiction,
                      .data$`ITIS Taxon Serial Number`)
  }


  res <- res %>%
    dplyr::rename(ITIS = .data$`ITIS Taxon Serial Number`) %>%
    dplyr::rename(StockName = .data$`Stock Name`)



  return(res)


}
