#' read in DESCRIPTION and change version number
#'
#' Increment last digit

update_description <- function(compare,digit){

  numRows <- unlist(lapply(compare,nrow))
  if (!(any(numRows>0))) {
    # empty list. No changes found between new and old data
    # no changes to news.md or DESCRIPTION
    version <- NULL
  } else {
    # read in DESCRIPTION file
    con <- file(here::here("DESCRIPTION"))
    tab <- readLines(con)

    #find line with version number on it
    line <- which(grepl("Version",tab))

    # Increment the last digit by 1
    spl <- strsplit(tab[line],":")
    v <- unlist(strsplit(unlist(spl)[2],"\\."))

    # increment digit
    v[digit] <- as.numeric(v[digit]) +1
    v[1] <- as.numeric(v[1])
    if (digit == 3) {
    } else if (digit == 2) {
      v[digit+1] <- 0
    } else if (digit == 1) {
      v[digit+1] <- 0
      v[digit+2] <- 0
    }

    newv <- paste0("Version: ",paste0(v,collapse = "."))

    tab[line] <- newv

    # write back to DESCRIPTION
    writeLines(tab,con)
    close(con)
    version <- paste0(v,collapse = ".")
  }
  return(version)

}
