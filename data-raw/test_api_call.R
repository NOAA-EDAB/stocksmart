ids <- stocksmart:::get_all_stock_ids()
stockids <- sort(ids$stockids) #[!(ids$stockids %in% c(17280, 17281, 17282))]

ic <- 0
null_stockts <- NULL
null_summary <- NULL
for (id in stockids[92:length(stockids)]) {
  ic <- ic + 1
  message(paste0(ic, " of ", length(ids$stockids), " - ", id))
  tictoc::tic()
  attempt <- 1
  while (!success) {
    attempt <- attempt + 1
    tryCatch(
      {
        a <- stocksmart::get_species_stock_data(stock = id)
        success <- TRUE
      },
      error = function(e) {
        message("An error occurred: ", conditionMessage(e))
        message(paste0("Attempt # ", attempt, " after a 10 second sleep"))
        Sys.sleep(10)
      }
    )
  }

  tictoc::toc()
  Sys.sleep(1)

  print(paste0(
    "stockdata = ",
    nrow(a$stock_ts),
    " stocksummary = ",
    nrow(a$stock_refs)
  ))
  if (is.null(a$stock_ts)) {
    null_stockts <- c(null_stockts, id)
  }
  if (is.null(a$stock_refs)) {
    null_summary <- c(null_summary, id)
  }
}

stocksmart:::process_stock_summary_data(ids$url, 10415)

stockAssessmentSummary |> dplyr::filter(`Stock ID` == 15577)
stockAssessmentData |> dplyr::filter(Stockid == 15577)

stocksmart::get_species_stock(stock = 10415)
stocksmart::get_species_itis(stock = 10670)
