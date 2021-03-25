#' Process xlsx files from Stock SMART
#'
#' NOAA Stock SMART site https://www.st.nmfs.noaa.gov/stocksmart?app=homepage
#' hosts stock assessment data for all managed species. Data is provided iin multiple xlsx files.
#' Read in and process this data and export as tidy Rdata file
#'
#'

library(magrittr)
read_summary_files <- function(){
  files <- list.files(here::here("data-raw"),pattern="\\.xlsx$") %>%
    tibble::enframe(name=NULL) %>%
    dplyr::rename("Files"="value")
  return(files)
}


#' process summary data
#'
process_stock_smart_summary_data <- function(){
  files <- read_summary_files()

  summaryfiles <- files %>% dplyr::filter(grepl("Summary",Files))
  summaryData <- NULL
  for (fn in unlist(summaryfiles)) {
    print(fn)
    dataf <- readxl::read_xlsx(here::here("data-raw",fn), col_names = T)
    summaryData <- rbind(summaryData,dataf)
  }
  stockAssessmentSummary <- summaryData

  # remove all spaces and ? in column names
  #names(stockAssessmentSummary) <- names(stockAssessmentSummary) %>%
  #  stringr::str_replace_all(.,"\\s+","") %>%
  #  stringr::str_replace(.,"\\?","") %>%
  #  stringr::str_replace(.,"\\/","_")


  stockAssessmentSummary <- tibble::as_tibble(stockAssessmentSummary)

  usethis::use_data(stockAssessmentSummary,overwrite = T)

  return(stockAssessmentSummary)
}
  ## Process Summary data



