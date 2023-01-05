#' Plot time series data for a particular species
#'
#' Exploratory plots of Catch, Abundance, F, Recruitment for all assessments for a particular species
#'
#' @param itis Numeric. Species ITIS code
#' @param stock Character. Full name of stock (only required if more than one stock exists for ITIS code)
#' @param metric Character vector. Specifying which metric to plot (Catch, Abundance, Fmort, Recruitment)
#' @param plotAs Character. How to plpot results. Plot all assessments on a single plot ("one") or
#' plot each assessment in its own facet ("facet")
#'
#' @section Units:
#' The units of some of the metrics change over time. For example, catch for one assessment may be presented in metric tons
#' whereas other assessments may be in thousand metric tons. This is not resolved in the plotting. When this arises it is best
#' to use \code{plotAs = "facet"} since each facet uses its own yaxis scale
#'
#' @return A ggplot object is returned. A figure is also returned
#'
#' @importFrom magrittr "%>%"
#' @importFrom rlang .data
#'
#' @export

plot_ts <- function(itis=NULL, stock=NULL, metric = "Catch", plotAs="one") {


  #error check for metric names
  if (is.null(itis)) {
    stop("If you do not know the ITIS code then please use get_species_itis()")
  }
  if (!metric %in% c("Catch","Fmort","Recruitment","Abundance","Index")) {
    stop("Please use of the defined metrics to plot. Catch, Fmort, Recruitment, Abundance, Index")
  }


  # filter by ITIS and Metric
  dataToPlot <- stocksmart::stockAssessmentData %>%
    dplyr::filter(.data$ITIS == itis,.data$Metric == metric) %>%
    dplyr::mutate(AssessmentYear = as.factor(.data$AssessmentYear))

  if(nrow(dataToPlot) ==0){
    message("The metric you selected doesn't exist for this stock")
    return()
  }

  # select stocks for this ITIS
  stocks <- dataToPlot %>%
    dplyr::distinct(.data$StockName)

  # if multiple stocks and user argument - NULL
  if ((nrow(stocks) > 1) && (is.null(stock))){
    message(paste0("There are multiple stocks for ITIS = ",itis,". Please specify which stock you'd like to plot"))
    stop(stocks)
  }
  # if multiple stocks and user argument doesn't match
  if ((nrow(stocks) > 1) && (!stock %in% (stocks %>% dplyr::pull()))){
    message(paste0("Please specify a valid stock to plot "))
    stop(stocks)
  }

  # if only a single stock and user argument doesn't match
  if (nrow(stocks) == 1) {
    if (is.null(stock)) { # user left blank
      stock = stocks
    } else { # user entereres a string
      if (!stock %in% (stocks %>% dplyr::pull())) {
        message(paste0("Please specify a valid stock to plot "))
        stop(stocks)
      }
    }

  }

  # filter out stock
  stockToPlot <- dataToPlot %>%
    dplyr::filter(.data$StockName == stock)

  # units check and standardize
  # eg if units change over time from say mt to thousands mt


  # plot data
  if (plotAs == "facet"){
    p <- ggplot2::ggplot(stockToPlot) +
      ggplot2::geom_line(ggplot2::aes(x=.data$Year,y=.data$Value)) +
      ggplot2::facet_wrap(~.data$AssessmentYear,scales = "free_y")
  } else {
    if ((stockToPlot %>% dplyr::distinct(.data$Units) %>% nrow()) >1) {
      message("The units change over time. Plotting as a facet plot will be better")
    }
    p <- ggplot2::ggplot(stockToPlot) +
      ggplot2::geom_line(ggplot2::aes(x=.data$Year,y=.data$Value,color = .data$AssessmentYear))
  }

  p <- p +
    ggplot2::ylab(paste0(metric," (",stockToPlot %>% dplyr::distinct(.data$Units),")")) +
    ggplot2::ggtitle(stockToPlot %>% dplyr::distinct(.data$StockName))

  print(p)

  return(p)


}
