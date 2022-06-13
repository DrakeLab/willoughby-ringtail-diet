# Taxonomic Integrations

# load libraries 
library(tidyverse)
library(rgbif)

# Match verbatim names with GBIF taxonomy
## load full literature database 
int_db <- read.csv(file = "data/diet-study-interactions.csv", strip.white = TRUE, na.strings=c("", "NA")) # downloaded 02 March 2022
lit_names <- c(int_db$ReportedScientificName,int_db$ReportedCommonName) %>% 
  unique() %>% as.data.frame()
lit_names <- lit_names %>% dplyr::filter(. != "n/a")  # remove nontaxa fillers 

# get gbif name lookup 

verbatim_taxon_names <- lit_names$.

# make empty dataframe to append output to
gbif_match <- data.frame((matrix(ncol = 23, nrow = 0)))
gbif_fields <- c("ReportedName","usageKey","acceptedUsageKey","scientificName","canonicalName","rank","status","confidence","matchType","kingdom","phylum","order","family","genus","species","kingdomKey","phylumKey","classKey","orderKey","familyKey", "genusKey","speciesKey","synonym","class")
colnames(gbif_match ) <- gbif_fields 
# loop all names through for the gbif matching 
for(i in verbatim_taxon_names){
  gbif_name <- name_backbone(i,curlopts = list(verbose = TRUE))
  gbif_match <- plyr::rbind.fill(gbif_name, gbif_match)                
}
# flag these columns as gbif-interpretted 
colnames(gbif_match) <- paste(colnames(gbif_match), "gbif", sep = "_")

# merge in with taxon sheet 
taxon_interpret_db <- full_join(lit_names, gbif_match, by = c("." = "canonicalName"))
write.csv(taxon_interpret_db, file = "data/exp_lit/taxon_interpretation.csv")

# Load for Taylor data sheet 
taylor_data <- read.csv(file = "data/sample_level_data/taylor-diet-items.csv", strip.white = T)

tTU_names <- unique(taylor_data$HarmonizedScientificName)
tTU_names <- tTU_names[tTU_names != ""]

# make empty dataframe to append output to
gbif_tmatch <- data.frame((matrix(ncol = 24, nrow = 0)))
colnames(gbif_tmatch) <- gbif_fields 
# loop all names through for the gbif matching 
for(i in tTU_names){
  v_name <- data.frame("Harmonized Scientific Name" = c(i))
  gbif_name <- name_backbone(i,curlopts = list(verbose = TRUE))
  gbif_name <- cbind(v_name, gbif_name)
  gbif_tmatch <- plyr::rbind.fill(gbif_name, gbif_tmatch)                
}

gbif_tmatch$taxon_authority <- "GBIF"
# this file will be manually updated for names unrecognized 

write.csv(gbif_tmatch, file = "data/sample_level_data/taylor_taxon_names.csv")

