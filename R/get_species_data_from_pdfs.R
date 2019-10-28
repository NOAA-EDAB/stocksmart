library(magrittr)
source(here::here("R","get_tables.R"))

############ MACKEREL #################
pdfName <- "2017_mackerel_GOM-GB-MA_18-06"
CatchTables <- data.frame(type = c("Catch"),pages=c(74,75))
BiomassTables <- data.frame(type = c("Biomass"),pages=c(121,122))

newTable <- get_tables(pdfName,CatchTables)
outPath <- paste0(pdfName,"_Catch.RDS")
saveRDS(newTable,outPath)

newTable <- get_tables(pdfName,BiomassTables)
outPath <- here::here(paste0(pdfName,"_Biomass.RDS"))
saveRDS(newTable,outPath)


############### HERRING ################
species <- "Herring"
pdfName <- "2018_herring_GOM-CC-MA_18-11"
LandingsTables <- data.frame(type = c("Landings"),pages=c(353))
BiomassTables <- data.frame(type = c("Biomass"),pages=c(442))
DiscardTables <- data.frame(type = c("Discards"),pages=c(354))

newTable <- get_tables(pdfName,LandingsTables)
outPath <- paste0(pdfName,"_Landings.RDS")
saveRDS(newTable,outPath)

newTable <- get_tables(pdfName,BiomassTables)
outPath <- paste0(pdfName,"_Biomass.RDS")
saveRDS(newTable,outPath)

newTable <- get_tables(pdfName,DiscardTables)
outPath <- paste0(pdfName,"_Discard.RDS")
# manually add to this output:

saveRDS(newTable,outPath)




############### GB COD ################
pdfName <- "2017_cod_GB_17-17"
tables <- data.frame(type = c("Landings"),pages=c(1))

newTable <- get_tables(pdfName,tables)
# add row names