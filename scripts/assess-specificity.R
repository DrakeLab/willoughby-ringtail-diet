# Specificity of Ringtail Diet Studies 

# load library
library(tidyverse)
library(viridis)

# load data 
prev_studies <- read.csv(file = "data/previous-diet-studies.csv", strip.white = TRUE)
int  <- read.csv(file = "data/study-diet-interactions.csv")

# create diet item count per study 
d_sum <- int %>% 
  group_by(source_id) %>% 
  summarise(n_diet_items = n())

# merge with diet sheet
prev_studies <- left_join(prev_studies, d_sum, by = "source_id")
# make source levels order by Pub Year 
prev_studies$source_id <- fct_reorder(prev_studies$source_id,prev_studies$PublicationYear)

# summarise studies 
# bump to next largest standard taxonomic rank (e.g., get rid of subs)
int$taxon_specificity <- ifelse(int$taxon_rank == "human-influenced", "inorganic", 
                                ifelse(int$taxon_rank == "subphylum", "phylum",
                                       ifelse(int$taxon_rank == "subclass", "class",
                                              ifelse(int$taxon_rank == "infraorder", "order",
                                                     ifelse(int$taxon_rank == "suborder", "order",
                                                     ifelse(int$taxon_rank == "subfamily", "family", 
                                                            ifelse(int$taxon_rank == "superclass", "species",
                                                                   ifelse(int$taxon_rank == "superfamily", "order",
                                                                          ifelse( int$taxon_rank == "superclass", "phylum",
                                                                                  ifelse(int$taxon_rank == "subspecies", "species",
                                                                                         ifelse(int$taxon_rank == "", "unknown",
                                                                                  int$taxon_rank)))))))))))

# assign as factor and reorder
int$taxon_specificity <- factor(int$taxon_specificity, levels = c("inorganic", "unknown", "kingdom", "phylum", "class", "order", "family", "genus", "species"))
# select columns of interest
study_spec <- dplyr::select(int, source_id, interaction_id, taxon_specificity)
study_spec$source_id <- factor(study_spec$source_id, levels = levels(prev_studies$source_id))

# transform to get count of diet items by taxon specificity 
study_spec_w <- study_spec %>% 
  pivot_wider(names_from = "taxon_specificity", 
              values_from = "interaction_id", 
              values_fn = list(interaction_id = length))
# fill nas with zero
study_spec_w[is.na(study_spec_w)] <- 0 

# bring in study level traits of interest
study_traits <- dplyr::select(prev_studies, source_id, method.2, n_diet_items)
study_spec_w <- left_join(study_spec_w, study_traits, by = "source_id")
study_spec_w <- study_spec_w[, c(1, 11, 12,2:10)]

study_spec_l <- study_spec_w %>% 
  pivot_longer(cols = 4:12,
               names_to = "taxonomic rank", 
               values_to = "diet item count")

# calculate study percentage 
study_spec_l$percent_identified <- study_spec_l$`diet item count`/ study_spec_l$n_diet_items

study_spec_l$`taxonomic rank` <- factor(study_spec_l$`taxonomic rank`, levels = c("inorganic", "unknown", "kingdom", "phylum", "class", "order", "family", "genus", "species"))

# plot a boxplot of diet item identification facetted by method 
ggplot(study_spec_l, aes(x = `taxonomic rank`, y = `diet item count`, group = `taxonomic rank`)) + 
  geom_boxplot(aes(fill=`taxonomic rank`)) + 
  facet_grid(method.2 ~ ., scales = "free")

# plot a boxplot of diet item percentage facetted by method 
ggplot(study_spec_l, aes(x = `taxonomic rank`, y = percent_identified , group = `taxonomic rank`)) + 
  geom_boxplot(aes(fill=`taxonomic rank`)) + 
  scale_fill_manual(values = c("#808080","#FF0000", rev(viridis(7)))) +
  geom_point(aes(x = `taxonomic rank`, y = percent_identified)) + 
  facet_grid(method.2 ~ .) + 
  theme_classic()  

# summarise to method type 
methods <- study_spec_l %>% 
  group_by(method.2, `taxonomic rank`) %>% 
  summarise(n_studies = n_distinct(source_id), 
            n_unique_items = sum(`diet item count`), 
            mean_percentage_ided = mean(percent_identified), 
            sd_percentage_ided = sd(percent_identified))

# plot bar plot 
ggplot(study_spec_l, aes(x = source_id, y = percent_identified, fill = `taxonomic rank`)) + 
  geom_bar(stat = "identity") + 
  scale_fill_manual(values = c("#808080","#FF0000", rev(viridis(7)))) + 
  ggforce::facet_row(.~factor(method.2, levels=c('observation','organ','scat','combination')), scales = "free_x", space = "free") +
  theme_classic() + 
  theme(axis.text.x = element_blank()) + 
  xlab("Diet Study") + ylab("Diet Items Identified (%)")
  




# summarise taxon specificty by study type 


