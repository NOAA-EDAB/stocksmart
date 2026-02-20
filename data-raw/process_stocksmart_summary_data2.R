#' Process xlsx files from Stock SMART
#'
#' NOAA Stock SMART site https://www.st.nmfs.noaa.gov/stocksmart?app=homepage
#' hosts stock assessment data for all managed species. Data is provided iin multiple xlsx files.
#' Read in and process this data and export as tidy Rdata file
#'
#'
#' ###################################################
#' Both summary and time series data sets now have same column names.
#' Field names and data sets are all snake_case with
#' all white space and non alphanumeric characters removed
#'
#' Other than that, identical to old data set
#' ###################################################
#'
read_summary_files <- function() {
  files <- list.files(here::here("data-raw"), pattern = "\\.xlsx$") |>
    tibble::enframe(name = NULL) |>
    dplyr::rename("Files" = "value")
  return(files)
}


#' process summary data
#'
#'@param exportFile Boolean. To save sumamry data file as rda to data folder. (Default = T)
#'
process_stocksmart_summary_data2 <- function(exportFile = T) {
  files <- read_summary_files()

  summaryfiles <- files |>
    dplyr::filter(grepl("Summary", Files))
  summaryData <- NULL
  for (fn in unlist(summaryfiles)) {
    print(fn)
    dataf <- readxl::read_xlsx(here::here("data-raw", fn), col_names = T)
    summaryData <- rbind(summaryData, dataf)
  }
  stockAssessmentSummary <- summaryData |>
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
  stockAssessmentSummary <- stockAssessmentSummary |>
    dplyr::rename_with(~ stringr::str_replace_all(., "\\s+", "_")) |>
    dplyr::rename_all(tolower) |>
    dplyr::rename_with(~ stringr::str_replace_all(., "\\?", "")) |>
    dplyr::rename_with(~ stringr::str_replace_all(., "\\/", "_over_")) |>
    dplyr::rename(itis = itis_taxon_serial_number)

  stock_assessment_summary <- tibble::as_tibble(stockAssessmentSummary)

  if (exportFile) {
    usethis::use_data(stock_assessment_summary, overwrite = T)
  }

  return(stock_assessment_summary)
}
## Process Summary data
