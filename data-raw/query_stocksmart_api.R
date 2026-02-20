#' Test API to pull data.
#'
#' Will use this in GtiHub action to pull and update the data on a monthly basis
#'
#'

library(magrittr)

query_stocksmart_api <- function() {
  ## 1. Get all entries (stockids and names)
  allids <- list()
  allids$method <- "searchEntities"
  allids$entName <- "%"
  allids$scId <- "%"
  allids$jurId <- "%"
  allids$fmpId <- "%"
  allids$ecoId <- "%"
  jsonquery <- jsonlite::toJSON(allids, pretty = TRUE, auto_unbox = TRUE)

  url <- "https://apps-st.fisheries.noaa.gov/stocksmart/"
  # url query
  # file <- httr::GET("https://www.st.nmfs.noaa.gov/stocksmart/sis_servlet",
  #                   query=list(jsonParam = jsonquery))
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

  mainData <- allEntities %>%
    dplyr::left_join(., assessEntities, by = c("id" = "entity_id")) %>%
    dplyr::filter(!is.na(asmt_id)) %>%
    dplyr::arrange(name)

  asmtids <- mainData %>%
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
  excel$maxYear <- "2032"

  n <- 60
  # loop over the assessment ids in chunks of 100.
  # Server will crash if n is too much bigger
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

    # create dir if doesnt exist
    if (!dir.exists(here::here("data-raw/allAssessments"))) {
      dir.create(here::here("data-raw/allAssessments"))
    }
    # save excel file
    httr::GET(
      file$url,
      httr::write_disk(
        path = here::here(paste0(
          "data-raw/allAssessments/Assessment_TimeSeries_Data_Part_",
          filenumber,
          ".xlsx"
        )),
        overwrite = TRUE
      )
    )
  }

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
  summary$endYear <- "2032"
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

  # save as excel file
  httr::GET(
    file$url,
    httr::write_disk(
      path = here::here(paste0("data-raw/Assessment_Summary_Data.xlsx")),
      overwrite = TRUE
    )
  )
}
