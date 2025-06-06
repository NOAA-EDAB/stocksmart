#' Process xlsx files from Stock SMART
#'
#' NOAA Stock SMART site https://www.st.nmfs.noaa.gov/stocksmart?app=homepage
#' hosts stock assessment data for all managed species. Data is provided in
#'  multiple xlsx files. Read in and process this data and export
#'  as tidy Rdata file
#'
#'


library(magrittr)
source(here::here("data-raw", "process_stocksmart_summary_data.R"))

read_assessment_files <- function() {
  files <- list.files(here::here("data-raw", "allAssessments"),
                      pattern = "\\.xlsx$") %>%
    tibble::enframe(name = NULL) %>%
    dplyr::rename("Files" = "value")
  return(files)
}



#' Process the Timeseries data from stocksmart website
#'
#' @param exportFile Boolean. Create rda files and save to data folder
#' (Default = FALSE)
#' @param isRunLocal Boolean. Is function being run locally (Default = TRUE).
#'  A different file name is created if running locally that doesn't interfere
#'  with git
#'
#'@return list of 2 data frames


#' process time series data
#'
process_stocksmart_ts_data <- function(exportFile = FALSE, isRunLocal = TRUE) {
  files <- read_assessment_files()

  tsfiles <- files %>% dplyr::filter(grepl("TimeSeries", Files))
  stockAssessmentData <- NULL
  for (fn in unlist(tsfiles)) {
    print(fn)
    dataf <- readxl::read_xlsx(here::here("data-raw", "allAssessments", fn),
                               col_names = FALSE)
    year <- as.numeric(unlist(dataf[9:nrow(dataf), 2]))
    for (icol in 3:ncol(dataf)) {
      # get metadata for this species. 1st 5 rows of data
      meta <- as.vector(unlist(dataf[1:8, icol]))
      # parse metadata to extract species name, region, metric,
      #Description, Units
      spnm_region <- meta[1]
      stockid <- as.numeric(meta[2])
      assessmentid <- as.numeric(meta[3])
      AssessmentYear <- as.numeric(meta[4])
      AssessmentMonth <- as.numeric(meta[5])
      metric <- meta[6]
      description <- meta[7]
      units <- meta[8]
      # time series data
      ts <- as.numeric(unlist(dataf[9:nrow(dataf), icol]))
      # select years where data is available
      ind <- !is.na(ts)
      Year <- year[ind]
      ts <- ts[ind]
      # length of data available
      nYrs <- length(Year)
      # build a tidy tibble
      speciesData <- tibble::tibble(StockName = rep(spnm_region, nYrs),
                                    Stockid = rep(stockid, nYrs),
                                    Assessmentid = rep(assessmentid, nYrs),
                                    Year = Year,
                                    Value = ts,
                                    Metric = rep(metric, nYrs),
                                    Description = rep(description, nYrs),
                                    Units = rep(units, nYrs),
                                    AssessmentYear = rep(AssessmentYear, nYrs))
      # combine data for this column to master
      stockAssessmentData <- rbind(stockAssessmentData, speciesData)
    }
  }

  ## process the summary data and join with time series data
  # rename variable and remove a bunch
  summaryData <- process_stocksmart_summary_data(exportFile = exportFile)
  stockAssessmentData <- dplyr::left_join(stockAssessmentData,
                                 summaryData,
                                 by = c("Assessmentid" = "Assessment ID")) %>%
    dplyr::select(StockName,
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
                  `Regional Ecosystem`) %>%
    dplyr::rename(CommonName = `Common Name`,
                  ScientificName = `Scientific Name`,
                  ITIS = `ITIS Taxon Serial Number`,
                  AssessmentType = `Assessment Type`,
                  StockArea = `Stock Area`,
                  RegionalEcosystem = `Regional Ecosystem`)



  # create a differnt file if run locally
  if (isRunLocal) {
    fn <- "localdatapull.txt"
  } else {
    fn <- "datapull.txt"
  }

  file.create(here::here("data-raw", fn))
  dateCreated <- Sys.time()
  cat(paste0(dateCreated, "\n"), file = here::here("data-raw", fn))
  cat(paste0("Number of files read = ", nrow(files), "\n"),
      file = here::here("data-raw", fn),
      append = TRUE)
  cat(paste0("number of rows of data object = ",
             nrow(stockAssessmentData), "\n"),
      file = here::here("data-raw", fn),
      append = TRUE)
  cat(paste0("number of rows stocksmart data object = ",
             nrow(stocksmart::stockAssessmentData), "\n"),
      file = here::here("data-raw", fn),
      append = TRUE)
  cat(paste0("number of rows of summary object = ",
             nrow(summaryData), "\n"),
      file = here::here("data-raw", fn),
      append = TRUE)
  cat(paste0("number of rows stocksmart summary data object = ",
             nrow(stocksmart::stockAssessmentSummary), "\n"),
      file = here::here("data-raw", fn),
      append = TRUE)


  stockAssessmentData <- tibble::as_tibble(stockAssessmentData)

  if (exportFile) {
    usethis::use_data(stockAssessmentData, overwrite = TRUE)
  }

  return(list(tsData = stockAssessmentData, summaryData = summaryData))

}
