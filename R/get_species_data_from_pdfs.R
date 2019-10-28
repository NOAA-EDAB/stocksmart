library(magrittr)
source(here::here("R","get_tables.R"))

############ MACKEREL #################
pdfName <- "2017_mackerel_GOM-GB-MA_18-06"
tables <- data.frame(type = c("Catch","Biomass"),pages=c(74,121,75,122))

get_tables(pdfName,tables)

############### HERRING ################
species <- "Herring"
pdfName <- "2018_herring_GOM-CC-MA_18-11"
tables <- data.frame(type = c("Landings","Discards","Biomass"),pages=c(353,354,442))

# filePath <- here::here("docs",paste0(pdfName,".pdf"))
# dtype <- "Discards"
# pages <- tables %>% dplyr::filter(type == dtype) %>% dplyr::select(pages)
# dtables <- tabulizer::extract_tables(filePath,pages=unlist(pages),output="data.frame")

get_tables(pdfName,tables)


############### GB COD ################
pdfName <- "2017_cod_GB_17-17"
