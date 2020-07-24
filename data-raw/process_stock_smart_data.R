#' Process xlsx files from Stock SMART
#'
#' NOAA Stock SMART site https://www.st.nmfs.noaa.gov/stocksmart?app=homepage
#' hosts stock assessment data for all managed species. Data is provided iin multiple xlsx files. 
#' Read in and process this data and export as tidy Rdata file
#'
#'

process_stock_smart_data <- function() {
  #find all excel files
  files <- list.files(here::here("data-raw"),pattern="\\.xlsx$")
  stockAssessmentData <- NULL
  for (fn in files) {
    dataf <- readxl::read_xlsx(here::here("data-raw",fn), col_names = F)
    year <- as.numeric(unlist(dataf[6:nrow(dataf),2]))
    nYrs <- length(year)
    for (icol in 3:ncol(dataf)) {
      # get metadata for this species
      meta <- as.vector(unlist(dataf[1:5,icol]))
      # parse metadata to extract species name, region, metric, Description. Units
      spnm_region <- stringr::str_split(meta[1],"-")[[1]]
      SpeciesNm <- stringr::str_remove(spnm_region[1],"\\s+$")
      region <- stringr::str_remove(spnm_region[2],"^\\s+")
      metric <- meta[3]
      description <- meta[4]
      units <- meta[5]
      # time series data
      ts <- as.numeric(unlist(dataf[6:nrow(dataf),icol]))
      # build a tidy tibble
      speciesData <- tibble::tibble(Species=rep(SpeciesNm,nYrs),Region = rep(region,nYrs),year=year,ts=ts,Metric = rep(metric,nYrs),Description=rep(description,nYrs),Units=rep(units,nYrs))
      stockAssessmentData <- rbind(stockAssessmentData,speciesData)
    }
    
  }
  
  save(stockAssessmentData,file = here::here("data","stockAssessmentData.Rdata"))

  
}
