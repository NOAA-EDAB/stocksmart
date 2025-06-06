#' read in News.md and change content
#'
#'

write_to_news <- function(aa, con) {

  nms <- letters[1:length(names(aa))]
  names(aa) <- nms
  g <- aa %>%
    dplyr::mutate(b = paste0("(", b, "):")) %>%
    dplyr::mutate(entry = paste(a, b, c)) %>%
    dplyr::select(entry)
  for (iline in 1:nrow(g)) {
    writeLines(paste("*", as.character(g[iline, ])), con)
  }
  writeLines("", con)

}

update_news <- function(version, compare) {

  if (is.null(version)) {
    # No changes found between new and old data
    # no changes to news.md
  } else {
    # read in News.md file
    con <- file(here::here("NEWS.md"), open = "r")
    currentNews <- readLines(con)
    close(con)

    con <- file(here::here("NEWS.md"), open = "w")


    # translate compare to md text
    writeLines(paste0("# stocksmart ", version), con)
    writeLines("", con)
    writeLines(paste0("Data pull: ", format(Sys.Date(), "%B %d, %Y")), con)
    writeLines("", con)

    # write changes to top of file then write old news
    if (!is.null(compare$sumrowAdd) && nrow(compare$sumrowAdd) > 0) {
      writeLines("### Summaries added ", con)
      writeLines("", con)

      write_to_news(compare$sumrowAdd, con)

    }
    if (!is.null(compare$sumrowRem) && nrow(compare$sumrowRem) > 0) {
      writeLines("### Summaries removed ", con)
      writeLines("", con)

      write_to_news(compare$sumrowRem, con)

    }
    if (!is.null(compare$datrowAdd) && nrow(compare$datrowAdd) > 0) {
      writeLines("### Time series added ", con)
      writeLines("", con)

      write_to_news(compare$datrowAdd, con)
    }
    if (!is.null(compare$datrowRem) && nrow(compare$datrowRem) > 0) {
      writeLines("### Time series removed ", con)
      writeLines("", con)

      write_to_news(compare$datrowRem, con)
    }

    writeLines(currentNews, con)
    close(con)

  }

}
