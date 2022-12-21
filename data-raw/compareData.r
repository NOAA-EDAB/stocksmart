# Save current rda file and compare with new one
#

library(magrittr)
compareData <- function() {

  current <- readRDS(here::here("data-raw/tempSummary.rds"))
  new <- readRDS(here::here("data-raw/newSummary.rds"))

  c1 <- current %>%
    dplyr::select(`Stock Name`,`ITIS Taxon Serial Number`,`Stock Name`,`Assessment Year`)
  n1 <- new %>%
    dplyr::select(`Stock Name`,`ITIS Taxon Serial Number`,`Stock Name`,`Assessment Year`)

  #######################################################
  #######################################################
  ## Checks on summaries
  #######################################################
  #######################################################

  if (!all(dim(current) == dim(new))) {# dimensions not same
    # find if columns added or removed
      sumcolsAdded <- setdiff(names(new),names(current))
      sumcolsRemoved <- setdiff(names(current),names(new))
      sumspeciesAdded <- dplyr::setdiff(n1,c1)
      sumspeciesRemoved <- dplyr::setdiff(c1,n1)

  } else {
    sumcolsAdded <- NULL
    sumcolsRemoved <- NULL
    sumspeciesAdded <- NULL
    sumspeciesRemoved <- NULL
  }


  #######################################################
  #######################################################
  ## Checks on data
  #######################################################
  #######################################################

  current <- readRDS(here::here("data-raw/tempData.rds"))
  new <- readRDS(here::here("data-raw/newData.rds"))

  #current <- current[1:(nrow(current)-55000),]

  if (!all(dim(current) == dim(new))) { #dimensions not same
    # find if columns added or removed
    datcolsAdded <- setdiff(names(new),names(current))
    datcolsRemoved <- setdiff(names(current),names(new))

    newsp <- new %>%
      dplyr::select(StockName,ITIS,StockArea,AssessmentYear) %>%
      dplyr::distinct()
    currentsp <- current %>%
      dplyr::select(StockName,ITIS,StockArea,AssessmentYear) %>%
      dplyr::distinct()

    datspeciesAdded <- dplyr::setdiff(newsp,currentsp)
    datspeciesRemoved <- dplyr::setdiff(currentsp,newsp)


  } else {
    datcolsAdded <- NULL
    datcolsRemoved <- NULL
    datspeciesAdded <- NULL
    datspeciesRemoved <- NULL
  }

  rmarkdown::render(here::here("data-raw/sendAsEmail.Rmd"),
                    params = list(
                      sumrowAdd = sumspeciesAdded,
                      sumrowRem = sumspeciesRemoved,
                      sumcolAdd = sumcolsAdded,
                      sumcolRem = sumcolsRemoved,
                      datrowAdd = datspeciesAdded,
                      datrowRem = datspeciesRemoved,
                      datcolAdd = datcolsAdded,
                      datcolRem = datcolsRemoved))



}
