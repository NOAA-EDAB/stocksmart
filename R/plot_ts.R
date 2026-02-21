#' Plot time series data for a particular species
#'
#' Exploratory plots of Catch, Abundance, F, Recruitment for all assessments
#' for a particular species
#'
#' @param itis Numeric. Species ITIS code
#' @param stock Character. Full name of stock (only required if more than one
#' stock exists for ITIS code)
#' @param metric Character vector. Specifying which metric to plot (Catch,
#' Abundance, Fmort, Recruitment, Index)
#' @param facetplot Boolean. How to plot results. Plot each assessment in its
#' own facet (TRUE) or pplot all assessments on a single plot (default = FALSE)
#' @param printfig Boolean. Print figure to figure window (Default = T)
#'
#'
#' @section Units:
#' The units of some of the metrics change over time. For example, catch for
#' one assessment may be presented in metric tons whereas other assessments
#' may be in thousand metric tons. This is not resolved in the plotting.
#' When this arises it is best to use \code{facet = TRUE} since
#' each facet uses its own yaxis scale
#'
#' @return A list of two items is returned
#' \item{plot}{ggplot object}
#' \item{data}{dataframe used in the plotting}
#'
#' @importFrom rlang .data
#'
#' @export

plot_ts <- function(
  itis = NULL,
  stock = NULL,
  metric = "Catch",
  facetplot = FALSE,
  printfig = TRUE
) {
  itis_code <- itis
  metric_code <- metric
  #error check for metric names
  if (is.null(itis_code)) {
    stop(
      "If you do not know the `itis` code then please use `get_species_itis()`"
    )
  }
  if (
    !metric_code %in% c("Catch", "Fmort", "Recruitment", "Abundance", "Index")
  ) {
    stop(
      "Please use of the defined metrics to plot. Catch, Fmort, Recruitment,
         Abundance, Index"
    )
  }

  # if (!(stock %in% unique(stock_assessment_data$stock_name))) {
  #   return(paste0("Stock = ", stock, " isn't a valid stock"))
  # }

  # filter by ITIS and Metric
  dataToPlot <- stocksmart::stock_assessment_data |>
    dplyr::filter(.data$itis == itis_code, .data$metric == metric_code) |>
    dplyr::mutate(assessment_year = as.factor(.data$assessment_year))

  if (!is.null(stock)) {
    # filter by stock
    dataToPlot <- dataToPlot |>
      dplyr::filter(.data$stock_name == stock)
  }

  if (nrow(dataToPlot) == 0) {
    message("The metric you selected doesn't exist for this stock")
    return()
  }

  # select stocks for this ITIS
  stocks <- dataToPlot |>
    dplyr::distinct(.data$stock_name)

  # if multiple stocks and user argument - NULL
  if ((nrow(stocks) > 1) && (is.null(stock))) {
    message(paste0(
      "There are multiple stocks for itis = ",
      itis_code,
      ". Please specify which stock you'd like to plot"
    ))
    return(stocks)
  }
  # if multiple stocks and user argument doesn't match
  if ((nrow(stocks) > 1) && (!stock %in% (stocks |> dplyr::pull()))) {
    message(paste0("Please specify a valid stock to plot "))
    return(stocks)
  }

  # if only a single stock and user argument doesn't match
  if (nrow(stocks) == 1) {
    if (is.null(stock)) {
      # user left blank
      stock <- stocks
    } else {
      # user entered a string
      if (!stock %in% (stocks |> dplyr::pull())) {
        message(paste0("Please specify a valid stock to plot "))
        stop(stocks)
      }
    }
  }

  # filter out stock to plot
  if (length(unique(dataToPlot$stock_area)) > 1) {
    # filter out stock
    stockToPlot <- dataToPlot |>
      dplyr::filter(.data$stock_name == stock) |>
      dplyr::mutate(
        AssmtYrUnits = as.factor(paste0(
          .data$assessment_year,
          " (",
          .data$units,
          ")"
        ))
      )
  } else {
    # no need to filter out stock (else causes error in dplyr 1.1.0)
    stockToPlot <- dataToPlot |>
      dplyr::mutate(
        AssmtYrUnits = as.factor(paste0(
          .data$assessment_year,
          " (",
          .data$units,
          ")"
        ))
      )
  }

  # units check and standardize
  # eg if units change over time from say mt to thousands mt

  # plot data
  if (facetplot == TRUE) {
    p <- ggplot2::ggplot(stockToPlot) +
      ggplot2::geom_line(ggplot2::aes(x = .data$year, y = .data$value)) +
      ggplot2::facet_wrap(~ .data$AssmtYrUnits, scales = "free_y") +
      ggplot2::ylab(metric_code)
  } else {
    if ((stockToPlot |> dplyr::distinct(.data$units) |> nrow()) > 1) {
      message(
        "The units change over time. Plotting as a facet plot
              will be better"
      )
    }
    p <- ggplot2::ggplot(stockToPlot) +
      ggplot2::geom_line(ggplot2::aes(
        x = .data$year,
        y = .data$value,
        color = .data$assessment_year
      )) +
      ggplot2::ylab(paste0(
        metric_code,
        " (",
        stockToPlot |>
          dplyr::distinct(.data$units),
        ")"
      )) +
      ggplot2::labs(color = "Assessment Year")
  }

  p <- p +
    ggplot2::ggtitle(stockToPlot |> dplyr::distinct(.data$stock_name))

  # print figure to window
  if (printfig) {
    print(p)
  }

  return(list(plot = p, data = stockToPlot))
}
