#' Pull species data directly
#'
#' Pulls data defined by stock directly to obtain current data. For those who
#' don't want to reinstall the package to get most recent data
#'
#' @param itis Numeric vector. Species ITIS code (Default = NULL, all species)
#' @param stock Character vector. String in which to use to search for stock
#'
#' @return  data frame (n x 3)
#' \item{StockName}{Full name of stock}
#' \item{Jurisdiction}{Management council}
#' \item{ITIS}{species itis code}
#'
#' @importFrom rlang .data
#'
#' @export

get_species_stock <- function(itis = NULL, stock = NULL) {
  # extract the stock ids since that is what is needed for the API
  meta <- get_species_itis(itis = itis, stock = stock)
  user_stockids <- meta$StockID

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

  stockids <- allEntities |>
    dplyr::filter(id %in% user_stockids) |>
    dplyr::pull(id)

  ## 2. pull all id's assessment data using the entity ids (stockids)
  # url query

  assess <- list()
  assess$method <- "getAsmtYearsWithTimeSeriesDataForEntityList"
  assess$entityIdList <- paste(stockids, collapse = ",")

  jsonquery <- jsonlite::toJSON(assess, pretty = TRUE, auto_unbox = TRUE)

  file <- httr::GET(
    paste0(url, "sis_servlet"),
    query = list(jsonParam = jsonquery)
  )

  # pulls html content into a char
  assessChar <- base::rawToChar(file$content)
  # converts to a readable R object
  assessEntities <- jsonlite::fromJSON(assessChar)$asmtList

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
      paste0(url, "data-export-servlet"),
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

    # process the data for the stock
    loop_data <- process_stock_tsdata(data_itis)
    stock_data <- rbind(stock_data, loop_data)
  }

  ## Now get summary data

  ## 4. Get summary data using assessment id's (asmtids)
  # create object to convert to JSON for url parameter
  summary <- list()
  ssummary <- list()
  summary$dataType <- ""
  summary$scName <- "- Science Center -"
  summary$ecoName <- "- Reg. Ecosystem -"
  summary$jurName <- "- Jurisdiction -"
  summary$rgnName <- ""
  summary$fmpName <- "- Fish Mgmt Plan -"
  summary$monName <- ""
  summary$entityIdList <- paste(stockids, collapse = ",")
  summary$outputFieldList <- "as_year,as_month,as_last_data_year,as_update_type,as_review_type,as_model,as_model_version,as_lead_lab,as_citation,as_files,as_point_of_contact,as_life_history,as_abundance,as_catch,as_level,as_frequency,as_type,as_model_cat,as_catch_data,as_abundance_data,as_biological_data,as_ecosystem_data,as_comp_data,as_f_year,as_f_best,as_f_unit,as_f_basis,as_flimit,as_flimit_basis,as_fmsy,as_fmsy_basis,as_f_flimit_ratio,as_f_fmsy_ratio,as_ftarget,as_ftarget_basis,as_f_ftarget_ratio,as_b_year,as_b_best,as_b_unit,as_b_basis,as_blimit,as_blimit_basis,as_bmsy,as_bmsy_basis,as_b_blimit_ratio,as_b_bmsy_ratio,as_msy,as_msy_unit"
  summary$outputLabelList <- "Assessment Year,Assessment Month,Last Data Year,Update Type,Review Result,Assessment Model,Model Version,Lead Lab,Citation,Final Assessment Report,Point of Contact,Life History Data,Abundance Data,Catch Data,Assessment Level,Assessment Frequency,Assessment Type,Model Category,Catch Input Data,Abundance Input Data,Biological Input Data,Ecosystem Linkage,Composition Input Data,F Year,Estimated F,F Unit,F Basis,Flimit,Flimit Basis,Fmsy,Fmsy Basis,F/Flimit,F/Fmsy,Ftarget,Ftarget Basis,F/Ftarget,B Year,Estimated B,B Unit,B Basis,Blimit,Blimit Basis,Bmsy,Bmsy Basis,B/Blimit,B/Bmsy,MSY,MSY Unit"
  summary$entityAttrList <- "ent_name,jur_name,fmp_name,sc_name,eco_name,ent_fssi_flag,tsn,sn,cn,sa"
  summary$entityAttrLabelList <- "Stock Name,Jurisdiction,FMP,Science Center,Regional Ecosystem,FSSI Stock?,ITIS Taxon Serial Number,Scientific Name,Common Name,Stock Area"
  summary$fileTypeList <- ""
  summary$DownloadTool_includeNoAsmt <- "N"
  summary$segIndex <- "0"
  summary$DownloadTool_carryForward <- "N"
  summary$DownloadTool_ent_name <- ""
  summary$DownloadTool_jur_select <- "%"
  summary$DownloadTool_fmp_select <- "%"
  summary$DownloadTool_sc_select <- "%"
  summary$DownloadTool_eco_select <- "%"
  summary$DownloadTool_fssi_select <- ""
  summary$startYear <- "1800"
  summary$endYear <- format(Sys.Date(), "%Y") #current year
  summary$asmtYears <- ""
  ssummary$crit <- summary
  ssummary$dataType <- "Assessment Summary Data"
  ssummary$dataFormat <- "excel"

  # convert to JSON
  jsonquery <- jsonlite::toJSON(ssummary, pretty = TRUE, auto_unbox = TRUE)

  # make url request
  file <- httr::GET(
    paste0(url, "data-export-servlet"),
    query = list(fileTypeList = "", jsonParam = jsonquery)
  )

  # The following is hacky but needed since the only output format is xlsx
  # would be better if API returned data in JSON format
  # pull data and download in temporary file
  summary_api_data <- httr::GET(file$url)
  # create a temporary file to store download
  tmp <- tempfile(fileext = ".xlsx")
  # Write the binary content to the temp file
  writeBin(httr::content(summary_api_data, as = "raw"), tmp)
  # read the temporary file
  summary_data_itis <- suppressMessages(readxl::read_xlsx(
    tmp,
    col_names = TRUE
  ))

  # process the data for the stock
  summary_data <- process_stock_summary_data(summary_data_itis)

  stock_data <- stock_data |>
    dplyr::left_join(
      summary_data,
      by = c("Assessmentid" = "Assessment ID")
    ) |>
    dplyr::select(
      StockName,
      Stockid,
      Assessmentid,
      Year,
      Value,
      Metric,
      Description,
      Units,
      AssessmentYear,
      Jurisdiction,
      FMP,
      `Common Name`,
      `Scientific Name`,
      `ITIS Taxon Serial Number`,
      `Assessment Type`,
      `Stock Area`,
      `Regional Ecosystem`
    ) |>
    dplyr::rename(
      CommonName = `Common Name`,
      ScientificName = `Scientific Name`,
      ITIS = `ITIS Taxon Serial Number`,
      AssessmentType = `Assessment Type`,
      StockArea = `Stock Area`,
      RegionalEcosystem = `Regional Ecosystem`
    )

  return(list(stock_ts = stock_data, stock_refs = summary_data))
}
