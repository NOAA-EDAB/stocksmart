#' Process xlsx files from Stock SMART
#'
#' NOAA Stock SMART site https://www.st.nmfs.noaa.gov/stocksmart?app=homepage
#' hosts stock assessment data for all managed species. Data is provided iin multiple xlsx files.
#' Read in and process this data and export as tidy Rdata file
#'
#'

library(magrittr)
source(here::here("data-raw","process_stock_smart_summary_data.R"))

read_assessment_files <- function(){
  files <- list.files(here::here("data-raw","allAssessments"),pattern="\\.xlsx$") %>%
    tibble::enframe(name=NULL) %>%
    dplyr::rename("Files"="value")
  return(files)
}


#' process time series data
#'
process_stock_smart_ts_data <- function() {
  files <- read_assessment_files()

  tsfiles <- files %>% dplyr::filter(grepl("TimeSeries",Files))
  stockAssessmentData <- NULL
  for (fn in unlist(tsfiles)) {
    print(fn)
    dataf <- readxl::read_xlsx(here::here("data-raw","allAssessments",fn), col_names = F)
    year <- as.numeric(unlist(dataf[6:nrow(dataf),2]))
    for (icol in 3:ncol(dataf)) {
      # get metadata for this species
      meta <- as.vector(unlist(dataf[1:5,icol]))
      # parse metadata to extract species name, region, metric, Description. Units
      spnm_region <- stringr::str_split(meta[1],"-")[[1]]
      SpeciesNm <- stringr::str_remove(spnm_region[1],"\\s+$")
      region <- stringr::str_remove(spnm_region[2],"^\\s+")
      AssessmentYear <- as.numeric(meta[2])
      metric <- meta[3]
      description <- meta[4]
      units <- meta[5]
      # time series data
      ts <- as.numeric(unlist(dataf[6:nrow(dataf),icol]))
      # select years where data is available
      ind <- !is.na(ts)
      Year <- year[ind]
      ts <- ts[ind]
      # length of data vailable
      nYrs <- length(Year)
      # build a tidy tibble
      speciesData <- tibble::tibble(Species=rep(SpeciesNm,nYrs),
                                    Region = rep(region,nYrs),
                                    Year=Year,Value=ts,
                                    Metric = rep(metric,nYrs),
                                    Description=rep(description,nYrs),
                                    Units=rep(units,nYrs),
                                    AssessmentYear=rep(AssessmentYear,nYrs))
      # combine data for this column to master
      stockAssessmentData <- rbind(stockAssessmentData,speciesData)
    }

  }

  # process summary data
  #summaryData <- process_stock_smart_summary_data()
  # join with processed data and export

  file.create(here::here("data-raw","datapull.txt"))

  stockAssessmentData <-  tibble::as_tibble(stockAssessmentData)
  usethis::use_data(stockAssessmentData,overwrite = T)
}


