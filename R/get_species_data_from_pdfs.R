library(magrittr)
#library(dplyr)
source(here::here("R","get_tables.R"))

# should really create a master df to store species, datatype, page number
# then just filter the df accordingly

############################################################
############ MACKEREL ######################################
############################################################

pdfName <- "2017_mackerel_GOM-GB-MA_SARC64-18-06"
CatchTables <- data.frame(type = c("Catch"),pages=c(74,75))
BiomassTables <- data.frame(type = c("Biomass"),pages=c(121,122))

newTable <- get_tables(pdfName,CatchTables)
outPath <- paste0(pdfName,"_Catch.RDS")
saveRDS(newTable,outPath)

newTable <- get_tables(pdfName,BiomassTables)
outPath <- here::here(paste0(pdfName,"_Biomass.RDS"))
saveRDS(newTable,outPath)

############################################################
############### HERRING ####################################
############################################################
pdfName <- "2018_herring_GOM-CC-MA_SARC65-18-11"
LandingsTables <- data.frame(type = c("Landings"),pages=c(353))
BiomassTables <- data.frame(type = c("Biomass"),pages=c(442))
DiscardTables <- data.frame(type = c("Discards"),pages=c(354))

newTable <- get_tables(pdfName,BiomassTables)
outPath <- paste0(pdfName,"_Biomass.RDS")
saveRDS(newTable,outPath)

newTable <- get_tables(pdfName,LandingsTables)
outPath <- paste0(pdfName,"_Landings.RDS")
saveRDS(newTable,outPath)

newTable <- get_tables(pdfName,DiscardTables)
outPath <- paste0(pdfName,"_Dicards.RDS")
saveRDS(newTable,outPath)



############################################################
############### GB COD #####################################
############################################################

pdfName <- "2019_COD_GB_OpAssess-SASINF"
CatchTables <- data.frame(type = c("Catch"),pages=c(2))
BiomassTables <- data.frame(type = c("Catch"),pages=c(10))

newTable <- get_tables(pdfName,CatchTables)
outPath <- paste0(pdfName,"_Catch.RDS")
saveRDS(newTable,outPath)

newTable <- get_tables(pdfName,BiomassTables)
# remove colums and concat
cNames <- c("YEAR","Fall","Fall.CV","Spring","CV")
part1 <- newTable %>% dplyr::select(cNames)
part2 <- newTable %>% dplyr::select(-c(cNames))
colnames(part2) <- cNames
newTable <- rbind(part1,part2)

outPath <- paste0(pdfName,"_Biomass.RDS")
saveRDS(newTable,outPath)
