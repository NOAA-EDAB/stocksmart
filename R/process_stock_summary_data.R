#' Process the summary data table for an individual itis
#'
#' @description Relabel and combine fields
#'
#' @param url String. The url of the stocksmart API
#' @param stockids Vector. The Stock ID numbers by which data are referenced
#'
#' @return A data frame
#'
#' @family processing
#'@noRd

process_stock_summary_data <- function(url, stockids) {
  ## Now get summary data

  ## Get summary data using assessment id's (asmtids)
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

  summary_data <- summary_data_itis |>
    dplyr::mutate(
      Type = dplyr::case_when(
        is.na(`Update Type`) ~ `Assessment Type`,
        TRUE ~ `Update Type`
      )
    ) |>
    dplyr::select(-`Assessment Type`, -`Update Type`) |>
    dplyr::rename(`Assessment Type` = Type)

  # replace all whitespace with underscore, remove ? and all lowercase
  # rename all field names to snake case
  summary_data <- summary_data |>
    dplyr::rename_with(~ stringr::str_replace_all(., "\\s+", "_")) |>
    dplyr::rename_all(tolower) |>
    dplyr::rename_with(~ stringr::str_replace_all(., "\\?", "")) |>
    dplyr::rename_with(~ stringr::str_replace_all(., "\\/", "_over_")) |>
    dplyr::rename(itis = itis_taxon_serial_number)

  return(summary_data)
}
