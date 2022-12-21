# Compare stocksmart with this repo
#

library(magrittr)
compareDataLocal <- function() {

  current <- stocksmart::stockAssessmentSummary
  new <- testapi::stockAssessmentSummary

  c1 <- current %>%
    dplyr::select(`Stock Name`,`ITIS Taxon Serial Number`,`Stock Name`,`Assessment Year`)
  n1 <- new %>%
    dplyr::select(`Stock Name`,`ITIS Taxon Serial Number`,`Stock Name`,`Assessment Year`)

  #current <- testapi::stockAssessmentSummary
  #new <- stocksmart::stockAssessmentSummary

  #new <- new[,1:(ncol(new)-1)]
  #current <- tail(current,-25)
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

  current <- stocksmart::stockAssessmentData
  new <- testapi::stockAssessmentData

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
