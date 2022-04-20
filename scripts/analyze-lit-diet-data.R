# Literature Diet Analyses
library(dplyr)
library(ggplot2)
library(GGally)
library(geomnet)
library(ggnetwork)
library(igraph)

'%notin%' <- function(x,y)!('%in%'(x,y))

# load data 
diet_studies <- read.csv(file = "data/previous-diet-studies.csv", strip.white = T)
diet_items <- read.csv(file = "data/diet-study-interactions.csv", strip.white = T)
# remove unrecognized items 
diet_items <- dplyr::filter(diet_items, taxon)

ss_diet <- read.csv(file = "data/sample_level_data/fragment-species-segment.csv")

# select only study and diet name columns 
# filter to species 
diet_sp <- filter(diet_items, taxon_rank == "species")
# count unique taxonomic ranks
## SPECIES 
study_sp_count <- diet_sp %>% 
  group_by(source_id) %>% 
  summarise(n_species = n_distinct(Species))
## GENERA
diet_genus <- filter(diet_items, taxon_rank %in% c("species", "genus"))
study_genus_count <- diet_genus %>% 
  group_by(source_id) %>% 
  summarise(n_genera = n_distinct(Genus)) 
## FAMILY 
diet_fam <- filter(diet_items, taxon_rank %in% c("species", "genus", "family"))
study_fam_count <- diet_fam %>% 
  group_by(source_id) %>% 
  summarise(n_fam = n_distinct(Family)) 

## ORDER 
diet_order <- filter(diet_items, taxon_rank %in% c("species", "genus", "family", "order"))
study_order_count <- diet_order %>% 
  group_by(source_id) %>% 
  summarise(n_order = n_distinct(Order))

# merge in study trait info 
diet_studies <- left_join(diet_studies, study_sp_count, by = "source_id")
diet_studies <- left_join(diet_studies, study_genus_count, by = "source_id")
diet_studies <- left_join(diet_studies, study_fam_count, by = "source_id" )
diet_studies <- left_join(diet_studies, study_order_count, by = "source_id")
diet_studies[is.na(diet_studies)==T] = 0 # mask empty cells


# sumarise at ecoregion levels 
ecor <- diet_studies %>% select(source_id, Ecoregion_Description)
diet_by_ecor <- left_join(diet_items, ecor, by = "source_id")
genus_ecor <- diet_by_ecor %>% select(Genus, Ecoregion_Description, Class)
genus_ecor <- genus_ecor %>% dplyr::filter(Genus != "x")
genus_ecor <- genus_ecor %>% dplyr::filter(Genus != "") %>% unique()

genus_ecor <- genus_ecor %>% group_by(Class, Ecoregion_Description) %>% summarise(n = n(Genus))
                                                                                    
ge_mat <- circlize::adjacencyList2Matrix(genus_ecor)


# filter to scat studies 
scat_studies <- filter(diet_studies, n_Scat %notin% c("n/a", "unclear", ""))
scat_studies <- filter(scat_studies, source_id %notin% c("Speir et al. 2021", 0))	
trad_lit <- scat_studies %>% select(n_Scat, n_genera)
names(trad_lit)[1] <- "Sites"
names(trad_lit)[2] <- "exact"

# plot genera richness by scat sample size 
plot(scat_studies$n_Scat, scat_studies$n_genera)




di_al <- select(diet_items, source_id, ReportedName)
di_al_m <- circlize::adjacencyList2Matrix(di_al, square = FALSE)
network <- graph_from_incidence_matrix(di_al_m )

# ds.net <- network(diet_items$edges[, 1:2], directed = FALSE)

# Species Accumulation Plots 
library(vegan)


## Species Accumulation of By Study at each Taxonomic Level 
### Loop each taxon class
taxa_levels <- c("Kingdom"), "Phylum", "Class", "Order", "Family", "Genus", "Species")

# make an empty data frame to fill 
obs <- data.frame()
for(t in taxa_levels){
# create Adjacency List for study - diet items at that taxonomic level 
  dtl_al <- select(diet_items, source_id, t)
  dtl_al[,t] <- ifelse(dtl_al[,t] == "x", "",  dtl_al[,t])
  dtl_al <- dtl_al %>% dplyr::filter(t != "x")
  dtl_al <- dtl_al %>% dplyr::filter(t != "") %>% unique()

# create Adjacency Matrix for study - diet items at that taxonomic level 
  dtl_al_m <- circlize::adjacencyList2Matrix(dtl_al, square = FALSE)
  
# Calculate Species Accumulation and Uncertainty Values 
  sac_rawTlS <- vegan::poolaccum(dtl_al_m)
  obsTlS <- data.frame(summary(sac_rawTlS)$S, check.names = FALSE)
  colnames(obsTlS) <- c("N", "S", "lower2.5", "higher97.5", "std")
  obsTlS$taxon_level <- t 
  obs <- rbind(obs, obsTlS)
}

### plot in ggplot with Vegan 

### plot in base R with Vegan 
gs_plot <- specaccum(dg_al_m , method = "exact", permutations = 100,
               conditioned =TRUE, gamma = "jack1",  w = NULL)
plot(gs_plot)

### plot in ggplot with Vegan 
sac_rawGS <- dg_al_m %>%
  # Compute SAC
  vegan::poolaccum(.)

obsGS <- data.frame(summary(sac_rawGS)$S, check.names = FALSE)
colnames(obsGS) <- c("N", "S", "lower2.5", "higher97.5", "std")

ggplot(data = obsGS, aes(x = N, y = S)) +
  geom_ribbon(aes(ymin = lower2.5,ymax = higher97.5),
              alpha = 0.5,
              colour = "gray70") +
  # Add observed richness line 
  geom_line() +
  xlim(0,40) + ylim(0,300) + 
  labs(x = "Studies conducted",
       y = "Observed genera richness") + 
  theme_classic() + 
  theme( axis.text=element_text(size=12),
         axis.title=element_text(size=14,face="bold"))

# Species Accumulation of By Study Type 

# Species Accumulation of By Ecoregion


# Species Accumulation of Traditional Scat Analysis from ZNP Samples 
ss_diet <- read.csv(file = "data/fragment-species-segment.csv") # a vector with unique names of segments
ss_adj_l <- ss_diet %>% select(Segment_ID, Genus) %>% unique()
scat_segments <- unique(ss_adj_l$Segment_ID)
spaccum = list() # a list to store the results of the species accumulation curve
slope = list() # a list to store the slopes
names(ss_adj_l)


ss_adj_l$Genus <- ifelse(ss_adj_l$Genus == "n/a", "", ss_adj_l$Genus)
ss_adj_l <- ss_adj_l %>% dplyr::filter(Genus != "n/a")
ss_adj_l <- ss_adj_l %>% dplyr::filter(Genus != "")
ss_adj_m <- circlize::adjacencyList2Matrix(ss_adj_l)
ss_adj_l$method <- "traditional"

x <- specaccum(ss_adj_m, method = "exact", permutations = 100,
          conditioned =TRUE, gamma = "jack1",  w = NULL)
plot(x)
plot(scat_studies$n_Scat, scat_studies$n_genera, add = TRUE)


# load in molecular data 
mol_data <- read.csv(file = "data/molecular-data/mol_data_merge.csv")

# remove parasite sequences 
nd_data <- mol_data %>% dplyr::filter(mol_data$TestId != "18S")
nd_cols <- nd_data %>% select(ARW_sample_id, Genus) %>% unique()

nd_cols <- nd_cols %>% dplyr::filter(Genus != "")
nd_adj_m <- circlize::adjacencyList2Matrix(nd_cols)
nd_cols$method <- "metagenomic"
names(nd_cols)[1] <- "Segment_ID"

library(BiodiversityR) # also loads vegan


g_in_s <- rbind(ss_adj_l, nd_cols)
g_in_s$present = 1
g_in_s_mat <- g_in_s %>% 
  pivot_wider(names_from = Genus, 
              values_from = present)
g_in_s_mat[is.na(g_in_s_mat)==T] = 0 # mask empty cells

sac_rawT <- g_in_s_mat %>%
  filter(method == "traditional")
  # Remove site decsription variables 
sac_rawT <- sac_rawT[,3:61] %>%
  # Compute SAC
  vegan::poolaccum(.)

obsT <- data.frame(summary(sac_rawT)$S, check.names = FALSE)
colnames(obsT) <- c("N", "S", "lower2.5", "higher97.5", "std")
obsT$method <- "traditional"

sac_rawM <- g_in_s_mat %>%
  filter(method == "metagenomic")
# Remove site decsription variables 
sac_rawM <- sac_rawM[,3:61] %>%
  # Compute SAC
  vegan::poolaccum(.)
obsM <- data.frame(summary(sac_rawM)$S, check.names = FALSE)
colnames(obsM) <- c("N", "S", "lower2.5", "higher97.5", "std")
obsM$method <- "metagenomic"

obs <- rbind(obsT, obsM)

ggplot(data =obs, aes(x = N,
                       y = S, group = method, colour = method)) +
  geom_ribbon(aes(ymin = lower2.5,ymax = higher97.5),
              alpha = 0.5,
              colour = "gray70") +
  # Add observed richness line 
  geom_line() +
  xlim(0,50) + ylim(0,50) + 
  labs(x = "Scat analyzed",
       y = "Observed genera richness") + 
  theme_classic() + 
  theme( axis.text=element_text(size=12),
         axis.title=element_text(size=14,face="bold"))
  geom_point(trad_lit)



m_accum <- specaccum(nd_adj_m, method = "exact", permutations = 100,
                          conditioned =TRUE, gamma = "jack1",  w = NULL)

plot(m_accum)
plot(x, add = TRUE, col = 2) #col is COLOUR setting, so change it to something else if you want
plot(curve_rubble, add = TRUE, col = 3)
plot(curve_sand, add = TRUE, col = 4)

ggplot(m_accum) + geom_line()

plot(x, ylim = c(0, 50), xlim = c(0,1000))
plot(m_accum, add = TRUE, col = 2)
plot(trad_lit, add = TRUE)



plotgg1 <- ggplot(data=m_accum, aes(x = Sites, y = Richness, ymax = UPR, ymin = LWR)) + 
  scale_x_continuous(expand=c(0, 1), sec.axis = dup_axis(labels=NULL, name=NULL)) +
  scale_y_continuous(sec.axis = dup_axis(labels=NULL, name=NULL)) +
  geom_line(aes(colour=Grouping), size=2) +
  geom_point(data=subset(accum.long1, labelit==TRUE), 
             aes(colour=Grouping, shape=Grouping), size=5) +
  geom_ribbon(aes(colour=Grouping), alpha=0.2, show.legend=FALSE) + 
  BioR.theme +
  scale_colour_npg() +
  labs(x = "Trees", y = "Loci", colour = "Population", shape = "Population")

