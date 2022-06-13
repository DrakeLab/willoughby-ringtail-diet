# Specificity of Ringtail Diet Studies 

# load library
library(tidyverse)
library(viridis)

# load data 
diet_studies <- read.csv(file = "data/diet_studies_processed.csv", strip.white = TRUE)

# bring in study level traits of interest
study_traits <- dplyr::select(diet_studies, source_id, method.2, n_diet_items)
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


