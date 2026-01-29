#' Pull list of all stock IDs in stockSMART database
#'
#' @description Pulls the complete list of all stock IDs found in the StockSMART database
#'
#' @return  list
#' \item{url}{The url of the API}
#' \item{stockids}{Complete list of all the stockids in database}
#'
#' @noRd

get_all_stock_ids <- function() {
  # Start pull query
  allids <- list()
  allids$method <- "searchEntities"
  allids$entName <- "%"
  allids$scId <- "%"
  allids$jurId <- "%"
  allids$fmpId <- "%"
  allids$ecoId <- "%"
  jsonquery <- jsonlite::toJSON(allids, pretty = TRUE, auto_unbox = TRUE)

  url <- "https://apps-st.fisheries.noaa.gov/stocksmart/"

  file <- httr::GET(
    paste0(url, "sis_servlet"),
    query = list(jsonParam = jsonquery)
  )
  # pulls html content into a char
  allEntitiesChar <- base::rawToChar(file$content)
  #   allEntitiesChar <- httr::content(file,as="text")
  # converts to a readable R object
  allEntities <- jsonlite::fromJSON(allEntitiesChar)$data

  stockids <- allEntities$id

  return(list(url = url, stockids = stockids))
}
