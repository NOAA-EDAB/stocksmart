#' Pull real-time species stock data directly from StockSMART API
#'
#' Pulls data defined by stock directly to obtain current data. For those who
#' don't want to reinstall the package to get most recent data
#'
#' @param itis Numeric vector. Species itis code (Default = NULL, all species)
#' @param stock Character vector. String in which to use to search for stock
#'
#' @return  data frame (n x 3)
#' \item{stock_name}{Full name of stock}
#' \item{jurisdiction}{Management council}
#' \item{itis}{species itis code}
#'
#' @importFrom rlang .data
#'
#' @export

get_species_stock_data <- function(itis = NULL, stock = NULL) {
  # extract the stock ids since that is what is needed for the API
  itis_code <- itis
  meta <- get_species_itis(itis = itis_code, stock = stock)
  if (is.character(meta)) {
    return(meta)
  } else if (nrow(meta) == 0) {
    return(list(stock_ts = NULL, stock_refs = NULL))
  }
  user_stockids <- meta$stock_id

  # Start pull query
  allids <- list()
  allids$method <- "searchEntities"
  allids$entName <- "%"
  allids$scId <- "%"
  allids$jurId <- "%"
  allids$fmpId <- "%"
  allids$ecoId <- "%"
  jsonquery <- jsonlite::toJSON(allids, pretty = TRUE, auto_unbox = TRUE)

  stocksmart_url <- "https://apps-st.fisheries.noaa.gov/stocksmart/"

  file <- httr::GET(
    paste0(stocksmart_url, "sis_servlet"),
    query = list(jsonParam = jsonquery)
  )
  # pulls html content into a char
  allEntitiesChar <- base::rawToChar(file$content)
  #   allEntitiesChar <- httr::content(file,as="text")
  # converts to a readable R object
  allEntities <- jsonlite::fromJSON(allEntitiesChar)$data

  stockids <- allEntities |>
    dplyr::filter(id %in% user_stockids) |>
    dplyr::pull(id)

  # get and process the data for the stock
  summary_data <- process_stock_summary_data(stocksmart_url, stockids)

  ## 2. pull all id's assessment data using the entity ids (stockids)
  # url query

  assess <- list()
  assess$method <- "getAsmtYearsWithTimeSeriesDataForEntityList"
  assess$entityIdList <- paste(stockids, collapse = ",")

  jsonquery <- jsonlite::toJSON(assess, pretty = TRUE, auto_unbox = TRUE)

  file <- httr::GET(
    paste0(stocksmart_url, "sis_servlet"),
    query = list(jsonParam = jsonquery)
  )

  # pulls html content into a char
  assessChar <- base::rawToChar(file$content)
  # converts to a readable R object
  assessEntities <- jsonlite::fromJSON(assessChar)$asmtList

  # Check for missing assessments.
  # A list/df with no elements will have length zero
  if (length(assessEntities) == 0) {
    return(list(stock_ts = NULL, stock_refs = summary_data))
  }

  mainData <- allEntities |>
    dplyr::left_join(assessEntities, by = c("id" = "entity_id")) |>
    dplyr::filter(!is.na(asmt_id)) |>
    dplyr::arrange(name)

  asmtids <- mainData |>
    dplyr::pull(asmt_id)

  ## 3. pull time series data using the assessment ids (asmtids)
  # url query
  excel <- list()
  #excel$asmtList <- paste(c("10643","7920"),collapse = ",")
  excel$dataType <- "TimeSeriesData"
  excel$dataFormat <- "excel"
  excel$partIndex <- "1"
  excel$categories <- c("Catch", "Abundance", "Fmort", "Recruitment")
  excel$minYear <- "1872"
  excel$maxYear <- format(Sys.Date(), "%Y") #current year

  n <- 60
  # loop over the assessment ids in chunks of 100.
  # Server will crash if n is too much bigger
  stock_data <- NULL
  for (ifile in 1:ceiling(length(asmtids) / n)) {
    # format excel output name
    filenumber <- sprintf("%02d", ifile)

    start <- n * (ifile - 1) + 1
    fin <- ifile * n

    idds <- asmtids[start:fin]
    idds <- idds[!is.na(idds)]

    excel$asmtList <- paste(idds, collapse = ",")

    jsonquery <- jsonlite::toJSON(excel, pretty = TRUE, auto_unbox = TRUE)

    file <- httr::GET(
      paste0(stocksmart_url, "data-export-servlet"),
      query = list(jsonParam = jsonquery)
    )

    # The following is hacky but needed since the only output format is xlsx
    # would be better if API returned data in JSON format
    # pull data and download in temporary file
    api_data <- httr::GET(file$url)
    # create a temporary file to store download
    tmp <- tempfile(fileext = ".xlsx")
    # Write the binary content to the temp file
    writeBin(httr::content(api_data, as = "raw"), tmp)
    # read the temporary file
    data_itis <- suppressMessages(readxl::read_xlsx(tmp, col_names = FALSE))
    if (length(data_itis) == 0) {
      loop_data <- NULL
    } else {
      # process the data for the stock
      loop_data <- process_stock_tsdata(data_itis)
    }
    stock_data <- rbind(stock_data, loop_data)
  }

  if (!is.null(stock_data)) {
    stock_data <- stock_data |>
      dplyr::rename_all(tolower) |>
      dplyr::rename(
        stock_name = stockname,
        stock_id = stockid,
        assessment_id = assessmentid,
        assessment_year = assessmentyear
      )
    # Join summary data with stock data
    stock_data <- stock_data |>
      dplyr::left_join(
        summary_data,
        by = c("assessment_id")
      ) |>
      dplyr::select(
        stock_name.x,
        stock_id.x,
        assessment_id,
        year,
        value,
        metric,
        description,
        units,
        assessment_year.x,
        jurisdiction,
        fmp,
        common_name,
        scientific_name,
        itis,
        assessment_type,
        stock_area,
        regional_ecosystem
      ) |>
      dplyr::rename(
        stock_name = stock_name.x,
        stock_id = stock_id.x,
        assessment_year = assessment_year.x
      )
  }

  return(list(stock_ts = stock_data, stock_refs = summary_data))
}
