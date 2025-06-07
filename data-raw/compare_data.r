# Save current rda file and compare with new one
#

library(magrittr)
compare_data <- function() {

  current <- readRDS(here::here("data-raw/tempSummary.rds"))
  new <- readRDS(here::here("data-raw/newSummary.rds"))

  c1 <- current %>%
    dplyr::select(`Stock Name`,
                  `ITIS Taxon Serial Number`,
                  `Stock Name`,
                  `Assessment Year`)
  n1 <- new %>%
    dplyr::select(`Stock Name`,
                  `ITIS Taxon Serial Number`,
                  `Stock Name`,
                  `Assessment Year`)

  #######################################################
  #######################################################
  ## Checks on summaries
  #######################################################
  #######################################################

  if (!all(dim(current) == dim(new))) {# dimensions not same
    # find if columns added or removed
    sumcolsAdded <- setdiff(names(new), names(current))
    if (rlang::is_empty(sumcolsAdded)) {
      sumcolsAdded <- data.frame()
    }
    sumcolsRemoved <- setdiff(names(current), names(new))
    if (rlang::is_empty(sumcolsRemoved)) {
      sumcolsRemoved <- data.frame()
    }
    sumspeciesAdded <- dplyr::setdiff(n1, c1)
    sumspeciesRemoved <- dplyr::setdiff(c1, n1)

  } else {
    sumcolsAdded <- data.frame()
    sumcolsRemoved <- data.frame()
    sumspeciesAdded <- data.frame()
    sumspeciesRemoved <- data.frame()
  }


  #######################################################
  #######################################################
  ## Checks on data
  #######################################################
  #######################################################

  current <- readRDS(here::here("data-raw/tempData.rds"))
  new <- readRDS(here::here("data-raw/newData.rds"))

  if (!all(dim(current) == dim(new))) { #dimensions not same
    # find if columns added or removed
    datcolsAdded <- setdiff(names(new), names(current))
    if (rlang::is_empty(datcolsAdded)) {
      datcolsAdded <- data.frame()
    }
    datcolsRemoved <- setdiff(names(current), names(new))
    if (rlang::is_empty(datcolsRemoved)) {
      datcolsRemoved <- data.frame()
    }

    newsp <- new %>%
      dplyr::select(StockName, ITIS, StockArea, AssessmentYear) %>%
      dplyr::distinct()
    currentsp <- current %>%
      dplyr::select(StockName, ITIS, StockArea, AssessmentYear) %>%
      dplyr::distinct()

    datspeciesAdded <- dplyr::setdiff(newsp, currentsp) %>%
      dplyr::select(-StockArea)
    datspeciesRemoved <- dplyr::setdiff(currentsp, newsp) %>%
      dplyr::select(-StockArea)

  } else {
    datcolsAdded <- data.frame()
    datcolsRemoved <- data.frame()
    datspeciesAdded <- data.frame()
    datspeciesRemoved <- data.frame()
  }

  params  <-  list(
    sumrowAdd = sumspeciesAdded,
    sumrowRem = sumspeciesRemoved,
    sumcolAdd = sumcolsAdded,
    sumcolRem = sumcolsRemoved,
    datrowAdd = datspeciesAdded,
    datrowRem = datspeciesRemoved,
    datcolAdd = datcolsAdded,
    datcolRem = datcolsRemoved)

  return(params)

}
