# Describe ringtail diet based on study review

## SET UP 
# load libraries
library(dplyr) # data wrangling 
library(ggplot2) # pretty plots
library(GGally) # network
library(geomnet) # network
library(ggnetwork) # network
library(igraph) # network

# add analysis functions 
'%notin%' <- function(x,y)!('%in%'(x,y))

# load data 
diet_studies <- read.csv(file = "data/previous-diet-studies.csv", strip.white = T)
# filter out iterative publishings 
diet_studies <- dplyr::filter(diet_studies, Inclusion_Status == "include")
diet_items <- read.csv(file = "data/study-diet-interactions.csv", strip.white = T)
# remove parasite occurrence 
diet_items <- diet_items %>% 
  dplyr::filter(ReportedScientificName != "Larvas parasitas") 
# remove diet items from excluded studies 
diet_items <- dplyr::filter(diet_items, source_id %in% diet_studies$source_id)

# create data.frames for study traits of interest
# ecoregion
ecor <- diet_studies %>% select(source_id, Ecoregion_Description)
# methods
method <- diet_studies %>% select(source_id, method.2)


# remove out items that are not taxonomically categorized
taxon_items <- dplyr::filter(diet_items, taxon_rank %notin% c("human-influenced", "inorganic", "", "lichen"))
# bump to next largest standard taxonomic rank (e.g., get rid of subs)
taxon_items$taxon_rank <- ifelse(taxon_items$taxon_rank == "subphylum", "phylum",
                                       ifelse(taxon_items$taxon_rank == "subclass", "class",
                                              ifelse(taxon_items$taxon_rank== "infraorder", "order",
                                                     ifelse(taxon_items$taxon_rank == "suborder", "order",
                                                            ifelse(taxon_items$taxon_rank== "subfamily", "family", 
                                                                   ifelse(taxon_items$taxon_rank == "superclass", "phylum",
                                                                          ifelse(taxon_items$taxon_rank== "superfamily", "order",
                                                                                         ifelse(taxon_items$taxon_rank == "subspecies", "species",
                                                                                                ifelse(taxon_items$taxon_rank == "", "unknown",
                                                                                                       taxon_items$taxon_rank)))))))))



### Calculate diet richness across studies 
# How many studies are there?  
nrow(diet_studies)

# How many diet-interactions? 
nrow(diet_items)

# How many unique taxonomic item identifications were made?
n_distinct(diet_items$ScientificName) - 1

# Plot temporal change of study types 

timeline <- diet_studies %>% 
  group_by(Decade, method.2) %>% 
  summarise(n_studies = n())
method_timeline <- ggplot(timeline, aes(x = Decade, y = n_studies , fill = method.2)) + 
  geom_bar(position="stack", stat="identity") + 
  xlab("Year") + ylab("study count") + 
  labs(fill = "method") +
  theme_classic() + 
  theme(axis.text.x=element_text(angle = 45, vjust = 0.5)) + 
  # set transparency
  theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )

method_timeline 

# count of study methods types 
View(table(diet_studies$method.2))
View(table(diet_studies$method))
# How many studies were expert curated? 
table(diet_studies$Identification_Method)

# What type of studies were expert curated? 
# language
table(diet_studies$Identification_Method, diet_studies$language)
table(diet_studies$Identification_Method, diet_studies$PublicationTypee)

# How many arthropods, animals, plants, and human-influenced items? 
View(diet_items %>% 
       group_by(Phylum) %>% 
       summarise(n_unique = n_distinct(ScientificName)))

# How does taxonomic specificity change by study type? 
# How many arthropods, animals, plants, and human-influenced items? 
main_groups <- taxon_items %>% 
       dplyr::filter(Phylum %in% c("Chordata", "Arthropoda", "Tracheophyta"))

# merge in methods 
main_groups <- left_join(main_groups, method, by = "source_id")
main_groups$taxon_rank <- factor(main_groups$taxon_rank, levels = c("kingdom", "phylum", "class", "order","family" , "genus", "species"))

# create a taxa group for phylum + with more specific classes for chordata 
main_groups$taxa_group <- ifelse(main_groups$Phylum %in% c("Arthropod")


group_taxon_ranks <- main_groups %>% 
       group_by(Phylum, Class, taxon_rank) %>% 
       summarise(n_unique = n_distinct(ScientificName),
                 n_identifications = n())

ggplot(group_taxon_ranks, aes(x = taxon_rank, y = n_identifications, fill = Class)) + 
  geom_bar(stat = "identity", position = "stack") + 
  theme_classic() + 
  facet_grid(~Phylum) +
  ylab("Identifications") + xlab("Taxonomic Rank of Identification") + 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))


# Most frequent diet items within each Phylum
freq_items <- diet_items %>% 
  group_by(Phylum, Order) %>% 
  summarise(n_TU = n_distinct(ScientificName))

# How many unique taxonomic ranks were found? 
sum_nontaxa <- diet_items %>% 
  dplyr::filter(taxon_rank %in% c("human-influenced", "inorganic", "lichen")) %>%
  group_by(taxon_rank) %>% 
  summarise(n_items_ided = n(),
            n_unique_items = n_distinct(ScientificName))
sum_taxa <- taxon_items %>% 
  group_by(taxon_rank) %>% 
  summarise(n_items_ided = n())

# how many unique kingdoms
king_ided <- unique(taxon_items$Kingdom)
king_ided <- king_ided[king_ided != "x"]
# how many unique phylums
phy_ided <- unique(taxon_items$Phylum)
phy_ided <- phy_ided[phy_ided != "x"]
# how many unique classes 
class_ided <- unique(taxon_items$Class)
class_ided <- class_ided[class_ided != "x"]
# how many unique orders 
ord_ided <- unique(taxon_items$Order)
ord_ided <- ord_ided[ord_ided != "x"]
# how many unique families
fam_ided <- unique(taxon_items$Family)
fam_ided <- fam_ided[fam_ided != "x"]
# how many unique genera
gen_ided <- unique(taxon_items$Genus)
gen_ided <- gen_ided[gen_ided != "x"]
# how many unique species
sp_ided <- unique(taxon_items$Species)
sp_ided <- sp_ided[sp_ided != "x"]

# bind all together 
taxon_ids <- data.frame(taxon_rank = c("kingdom", "phylum", "class", "order", "family","genus", "species"), 
                        n_unique_items = c(length(king_ided), length(phy_ided),length(class_ided), length(ord_ided), length(fam_ided), length(gen_ided), length(sp_ided)))
# bind to count of items
sum_diet <- full_join(sum_taxa, taxon_ids, by = "taxon_rank")
sum_diet <- rbind(sum_diet, sum_nontaxa)
sum_diet$taxon_rank <- factor(sum_diet$taxon_rank, levels = c("inorganic", "human-influenced", "lichen", "kingdom", "phylum", "class", "order","family" , "genus", "species"))



# plot frequency of identification 
ggplot(sum_diet, aes(x = taxon_rank, y = n_items_ided)) + 
  geom_bar(stat = "identity") + 
  theme_classic() + 
  geom_text(size = 4, position = position_stack(vjust = 0.5), aes(x=taxon_rank, label=n_items_ided), colour = "black") + 
  ylab("Unique Items Across All Studies") + xlab("Taxonomic Rank of Identification") + 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))

 ### Calculate diet taxonomic richness for each study

# count unique diet items (taxonomic + human influence + organic)
study_di_count <- diet_items %>% 
  group_by(source_id) %>% 
  summarise(n_unique_diet_items = n())

## count unique taxonomic ranks
# filter to species 
diet_sp <- filter(taxon_items, taxon_rank == "species")
## Count unique SPECIES identified per study
study_sp_count <- diet_sp %>% 
  group_by(source_id) %>% 
  summarise(n_species = n_distinct(Species))
## Count unique GENERA identified per study
diet_genus <- filter(taxon_items, taxon_rank %in% c("species", "genus"))
study_genus_count <- diet_genus %>% 
  group_by(source_id) %>% 
  summarise(n_genera = n_distinct(Genus)) 
## Count unique FAMILY identified per study
diet_fam <- filter(taxon_items, taxon_rank %in% c("species", "genus", "family"))
study_fam_count <- diet_fam %>% 
  group_by(source_id) %>% 
  summarise(n_fam = n_distinct(Family)) 
## Count unique ORDER identified per study
diet_order <- filter(taxon_items, taxon_rank %in% c("species", "genus", "family", "order"))
study_order_count <- diet_order %>% 
  group_by(source_id) %>% 
  summarise(n_order = n_distinct(Order))
## Count unique Phylum identified per study
diet_phy <- filter(taxon_items, taxon_rank %in% c("species", "genus", "family", "order", "phylum"))
study_phy_count <- diet_order %>% 
  group_by(source_id) %>% 
  summarise(n_phylum = n_distinct(Phylum))

# merge in study trait info for count of taxonomic richness 
diet_studies <- left_join(diet_studies, study_di_count, by = "source_id")
diet_studies <- left_join(diet_studies, study_sp_count, by = "source_id")
diet_studies <- left_join(diet_studies, study_genus_count, by = "source_id")
diet_studies <- left_join(diet_studies, study_fam_count, by = "source_id" )
diet_studies <- left_join(diet_studies, study_order_count, by = "source_id")
diet_studies <- left_join(diet_studies, study_phy_count, by = "source_id")

diet_studies[is.na(diet_studies)==T] = 0 # mask empty cells
write.csv(diet_studies, file = "data/diet_studies_processed.csv")


## summarise count of different taxonomic units per phylum for each study
# filter to scat studies 
tissue_studies <- filter(diet_studies, method.2 %in% c("combination", "scat", "organ"))
tissue_items <- diet_items %>% 
  dplyr::filter(source_id %in% tissue_studies$source_id)
phy_TU_count <- tissue_items %>% 
  group_by(source_id, Phylum) %>% 
  summarise(n_taxonomic_units = n()) %>% 
  dplyr::filter(Phylum != "x")



# bring in study count of taxonomic units
phy_TU_count <- left_join(phy_TU_count, study_di_count, by = "source_id")
phy_TU_count$prop_diet <- phy_TU_count$n_taxonomic_units / phy_TU_count$n_unique_diet_items

phy_TU_count <- left_join(phy_TU_count, ecor, by = "source_id")
reorder(phy_TU_count$source_id)
# plot bar plot of each study facetted by ecoregion 
ggplot(phy_TU_count, aes(x = reorder(source_id, n_taxonomic_units), y = prop_diet, fill = Phylum, label = n_taxonomic_units)) + 
  geom_bar(stat = "identity") + 
  scale_fill_manual(values = c("#118AB2", "#74FBD7", "#FFD166", "#EF476F", "#024F3B", "#073B4C", "#06EFB1")) + 
  ggforce::facet_row(.~factor(Ecoregion_Description), scales = "free_x", space = "free") +
  theme_classic() + 
  theme(axis.text.x = element_blank()) + 
  xlab("Diet Study") + ylab("Proportion of Unique Diet Items Identified") + 
  geom_text(size = 4, position = position_stack(vjust = 0.5),colour = "white")
# sumarise at ecoregion levels 
ecor <- diet_studies %>% select(source_id, Ecoregion_Description)
diet_by_ecor <- left_join(diet_items, ecor, by = "source_id")
genus_ecor <- diet_by_ecor %>% select(Genus, Ecoregion_Description, Class)
genus_ecor <- genus_ecor %>% dplyr::filter(Genus != "x")
genus_ecor <- genus_ecor %>% dplyr::filter(Genus != "") %>% unique()

genus_ecor <- genus_ecor %>% 
  group_by(Class, Ecoregion_Description) %>% 
  summarise(n = n_distinct(Genus))
                                                                                    
ge_mat <- circlize::adjacencyList2Matrix(genus_ecor)


	
trad_lit <- scat_studies %>% select(n_Scat, n_genera)
names(trad_lit)[1] <- "Sites"
names(trad_lit)[2] <- "exact"

scat_studies <- dplyr::filter(diet_studies, method.2 == "scat") 

# plot genera richness by scat sample size 
ggplot(scat_studies) + 
  geom_point(aes(x = as.numeric(n_Scat), y = log(n_genera) ,colour = Ecoregion_Description), size = 5) + 
  geom_smooth(aes(x = as.numeric(n_Scat), y = log(n_genera)), method="lm") + 
  labs(x = "Scat Segments",
       y = "Observed genera richness (log)") + 
  theme_classic()

scat_lm <- lm(n_genera ~ as.numeric(n_Scat), data = scat_studies)
summary(scat_lm)





di_al <- select(diet_items, source_id, ReportedName)
di_al_m <- circlize::adjacencyList2Matrix(di_al, square = FALSE)
network <- graph_from_incidence_matrix(di_al_m )

# ds.net <- network(diet_items$edges[, 1:2], directed = FALSE)
				 
## CALCULATE OMNIVORY 
				 



