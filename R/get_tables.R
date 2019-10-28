#' Extracts table from pdf
#' 
#' @param pdfName String. Name of pdf file
#' @param pdfDir String. Directory pdf resides
#' @param tableTypes Dataframe. Two columms. Column 1 = Type of data in table ("Biomass","Landings", etc.). column2 = page number(s) in document where table exists
#' 
#'@return Nothing. 
#'
#'@section Input/Output files:
#'
#' Input: Pdf documents are assumed to be in the "docs" folder of the current working directory.
#' 
#' Output: RDS Files are written to the working directory. 
#' The files have the same name as \code{pdfName} with the "type" of data concatenated. ("_Biomass"). The 
#'"type" is taken from column 1 of \code{tableTypes}.

get_tables <- function(pdfName,tableTypes){

  # PDFS assumed to be in docs folder. Can remove/generalize this later
  filePath <- here::here("docs",paste0(pdfName,".pdf"))
  
  # for each unique type ("Biomass","catch" etc)
  for(dtype in unique(tableTypes$type)) {
    pages <- tableTypes %>% dplyr::filter(type == dtype) %>% dplyr::select(pages)
    dtables <- tabulizer::extract_tables(filePath,pages=unlist(pages),output="data.frame")
    #For types that exist in tables that span multiple pages. The table is read in parts, each page is part
    #of the table. They need to be rbind(ed) to create the full table
    newTable <- NULL
    for (i in 1:length(dtables)){
      tab <- dtables[[i]]
      tab <- lapply(tab, function(x) gsub(",", "", x, fixed=TRUE))
      tab <- as.data.frame(lapply(tab,as.numeric))
      # removes columns with all NAs. These are created by tabulizer
      colsToKeep <- which(!is.na(colMeans(tab,na.rm =T)))
      newtab <- tab %>% dplyr::select(colsToKeep)
      newTable <- rbind(newTable,newtab)
    }
    outPath <- here::here(paste0(pdfName,"_",dtype,".RDS"))
    saveRDS(newTable,outPath)
    message(paste0("Extracted data has been saved to: ",outPath))
  }

}
  
