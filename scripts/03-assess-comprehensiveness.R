# Assess comprehensiveness 
library(vegan)
diet_studies <- read.csv(file = "data/previous-diet-studies.csv", strip.white = T)  %>% mutate_all(na_if,"")
diet_items <- read.csv(file = "data/study-diet-interactions.csv", strip.white = T)  %>% mutate_all(na_if,"")
ss_diet <- read.csv(file = "data/sample_level_data/fragment-species-segment.csv")
taylor_diet <- read.csv(file = "data/sample_level_data/taylor-diet-items.csv", strip.white = T)



# Species Accumulation Plots 
## Species Accumulation of By Study at each Taxonomic Level 
### Loop each taxon class
taxa_levels <- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")

# make an empty data frame to fill 
obs <- data.frame()

# SAC at Phylum Level
  # create Adjacency List for study - diet items at that taxonomic level 
  dtl_pl <- select(diet_items, source_id, Phylum)
  dtl_pl <- dtl_pl %>% dplyr::filter(Phylum != "x") %>% unique()
  
  # create Adjacency Matrix for study - diet items at that taxonomic level 
  dtl_pl_m <- circlize::adjacencyList2Matrix(dtl_pl, square = FALSE)
  
  # Calculate Species Accumulation and Uncertainty Values 
  sac_rawplS <- vegan::poolaccum(dtl_pl_m)
  obsplS <- data.frame(summary(sac_rawplS)$S, check.names = FALSE)
  colnames(obsplS) <- c("N", "S", "lower2.5", "higher97.5", "std")
  obsplS$taxon_level <- "Phylum"
  obs <- rbind(obs, obsplS)
  
### plot in ggplot with Vegan 
sac_rawTU <-   dtl_pl_m %>%
  # Compute SAC
  vegan::poolaccum(.)

obsTU <- data.frame(summary(sac_rawTU)$S, check.names = FALSE)
colnames(obsTU ) <- c("N", "S", "lower2.5", "higher97.5", "std")

ggplot(data = obsTU, aes(x = N, y = S)) +
  geom_ribbon(aes(ymin = lower2.5,ymax = higher97.5),
              alpha = 0.5,
              colour = "gray70") +
  # Add observed richness line 
  geom_line() +
  xlim(0,40) + ylim(0,10) + 
  labs(x = "Studies conducted",
       y = "Observed phylum richness") + 
  theme_classic() + 
  theme( axis.text=element_text(size=12),
         axis.title=element_text(size=14,face="bold"))

# SAC at Class Level
# create Adjacency List for study - diet items at that taxonomic level 
dtl_cl <- select(diet_items, source_id, Class)
dtl_cl <- dtl_cl %>% dplyr::filter(Class != "x") %>% unique()

# create Adjacency Matrix for study - diet items at that taxonomic level 
dtl_cl_m <- circlize::adjacencyList2Matrix(dtl_cl, square = FALSE)

# Calculate Species Accumulation and Uncertainty Values 
sac_rawclS <- vegan::poolaccum(dtl_cl_m)
obsclS <- data.frame(summary(sac_rawclS)$S, check.names = FALSE)
colnames(obsclS) <- c("N", "S", "lower2.5", "higher97.5", "std")
obsclS$taxon_level <- "class"
obs <- rbind(obs, obsclS)

### plot in ggplot with Vegan 
sac_rawTU <-   dtl_cl_m %>%
  # Compute SAC
  vegan::poolaccum(.)

obsTU <- data.frame(summary(sac_rawTU)$S, check.names = FALSE)
colnames(obsTU ) <- c("N", "S", "lower2.5", "higher97.5", "std")

class_plot <- ggplot(data = obsTU, aes(x = N, y = S)) +
  geom_ribbon(aes(ymin = lower2.5,ymax = higher97.5),
              alpha = 0.5,
              colour = "gray70") +
  # Add observed richness line 
  geom_line() +
  xlim(0,40) + ylim(0,25) + 
  labs(x = "Studies conducted",
       y = "Observed class richness") + 
  theme_classic() + 
  theme( axis.text=element_text(size=12),
         axis.title=element_text(size=14,face="bold"))

# SAC at Order Level
# create Adjacency List for study - diet items at that taxonomic level 
dtl_ol <- select(diet_items, source_id, Order)
dtl_ol <- dtl_ol %>% dplyr::filter(Order != "x") %>% unique()

# create Adjacency Matrix for study - diet items at that taxonomic level 
dtl_ol_m <- circlize::adjacencyList2Matrix(dtl_ol, square = FALSE)

# Calculate Species Accumulation and Uncertainty Values 
sac_rawolS <- vegan::poolaccum(dtl_ol_m)
obsolS <- data.frame(summary(sac_rawolS)$S, check.names = FALSE)
colnames(obsolS) <- c("N", "S", "lower2.5", "higher97.5", "std")
obsolS$taxon_level <- "order"
obs <- rbind(obs, obsolS)

### plot in ggplot with Vegan 
sac_rawTU <-   dtl_ol_m %>%
  # Compute SAC
  vegan::poolaccum(.)

obsTU <- data.frame(summary(sac_rawTU)$S, check.names = FALSE)
colnames(obsTU ) <- c("N", "S", "lower2.5", "higher97.5", "std")

class_plot <- ggplot(data = obsTU, aes(x = N, y = S)) +
  geom_ribbon(aes(ymin = lower2.5,ymax = higher97.5),
              alpha = 0.5,
              colour = "gray70") +
  # Add observed richness line 
  geom_line() +
  xlim(0,40) + ylim(0,25) + 
  labs(x = "Studies conducted",
       y = "Observed order richness") + 
  theme_classic() + 
  theme( axis.text=element_text(size=12),
         axis.title=element_text(size=14,face="bold"))

# SAC at Family Level
dtl_fl <- select(diet_items, source_id, Family)
dtl_fl <- dtl_fl %>% dplyr::filter(Family != "x") %>% unique()

# create Adjacency Matrix for study - diet items at that taxonomic level 
dtl_fl_m <- circlize::adjacencyList2Matrix(dtl_fl, square = FALSE)

# Calculate Species Accumulation and Uncertainty Values 
sac_rawflS <- vegan::poolaccum(dtl_fl_m)
obsflS <- data.frame(summary(sac_rawflS)$S, check.names = FALSE)
colnames(obsflS) <- c("N", "S", "lower2.5", "higher97.5", "std")
obsflS$taxon_level <- "family"
obs <- rbind(obs, obsflS)

### plot in ggplot with Vegan 
sac_rawTU <-   dtl_fl_m %>%
  # Compute SAC
  vegan::poolaccum(.)

obsTU <- data.frame(summary(sac_rawTU)$S, check.names = FALSE)
colnames(obsTU ) <- c("N", "S", "lower2.5", "higher97.5", "std")

family_plot <- ggplot(data = obsTU, aes(x = N, y = S)) +
  geom_ribbon(aes(ymin = lower2.5,ymax = higher97.5),
              alpha = 0.5,
              colour = "gray70") +
  # Add observed richness line 
  geom_line() +
  xlim(0,40) + ylim(0,205) + 
  labs(x = "Studies conducted",
       y = "Observed family richness") + 
  theme_classic() + 
  theme( axis.text=element_text(size=12),
         axis.title=element_text(size=14,face="bold"))

# SAC at Genus Level
dtl_gl <- select(diet_items, source_id, Genus)
dtl_gl <- dtl_gl %>% dplyr::filter(Genus != "x") %>% unique()

# create Adjacency Matrix for study - diet items at that taxonomic level 
dtl_gl_m <- circlize::adjacencyList2Matrix(dtl_gl, square = FALSE)

# Calculate Species Accumulation and Uncertainty Values 
sac_rawglS <- vegan::poolaccum(dtl_gl_m)
obsglS <- data.frame(summary(sac_rawglS)$S, check.names = FALSE)
colnames(obsglS) <- c("N", "S", "lower2.5", "higher97.5", "std")
obsglS$taxon_level <- "genus"
obs <- rbind(obs, obsglS)

### plot in ggplot with Vegan 
sac_rawTU <-   dtl_gl_m %>%
  # Compute SAC
  vegan::poolaccum(.)

obsTU <- data.frame(summary(sac_rawTU)$S, check.names = FALSE)
colnames(obsTU ) <- c("N", "S", "lower2.5", "higher97.5", "std")

genus_plot <- ggplot(data = obsTU, aes(x = N, y = S)) +
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
mol_data <- read.csv(file = "data/sample_level_data/mol_data_merge.csv")

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