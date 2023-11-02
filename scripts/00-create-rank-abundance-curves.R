# Plot diet abundance-rank for ringtails 
library(tidyverse)
`%notin%` <- Negate(`%in%`) 

# load data 
int_db <- read.csv(file = "data/raw/interactions.csv") # study-interaction data 
taxa <- read.csv(file = "data/raw/taxonomy.csv") # taxonomy

# if no population id, use source id 
int_db$pop_id <- ifelse(int_db$pop_id == "", int_db$source_id, int_db$pop_id)
# select only columns of interest (not using count, only proportional data)
int_db <- int_db[, c(1,3,6,15,9:14)]
int_db$method <- ifelse(int_db$method == "scat-dna", "scat", int_db$method) # modify scat-dna sub category into main category

# traverse data to long format 
int_db_l <- int_db %>% 
  pivot_longer(cols = c(5:10),
               names_to = "metric", 
               values_to = "value")
# make an indicator for a unique metric 
int_db_l$pop_id_um <- paste(int_db_l$pop_id, int_db_l$method, int_db_l$metric, sep = "_")

# remove non-existent data 
int_db_l <- int_db_l %>% 
  dplyr::filter(value %notin% c("not provided", "n/a", "-", ""))
int_db_l <- int_db_l %>% 
  dplyr::filter(is.na(value)== FALSE)

# change trace amounts to 0.0001 
int_db_l$value <- ifelse(int_db_l$value %in% c("small quantity", "tr", "trace"), 0.0001, int_db_l$value)
int_db_l$value <- as.numeric(int_db_l$value)

# split data by this pop_id_um metric
pop_split <- split(int_db_l, int_db_l$pop_id_um)

# Function to add a rank variable based on VariableB
add_rank_variable <- function(subset) {
  subset$rank <- rank(-subset$value, ties.method = "min")
  return(subset)
}

# Apply the function to each split subset
int_db_lranked <- lapply(pop_split, add_rank_variable)
pops_diet_ranked <- do.call(rbind, int_db_lranked) # Merge the split datasets back together
rownames(pops_diet_ranked) <- NULL
pops_diet_ranked$popid_rank <- paste(pops_diet_ranked$pop_id_um, pops_diet_ranked$rank, sep = "_")
pops_diet_ranked <- pops_diet_ranked[order(pops_diet_ranked[["rank"]]), ] # order by rank 

# merge in taxonomy so we can color by Phylum
pops_diet_ranked <- left_join(pops_diet_ranked, taxa, by = "HarmonizedScientificName")

# Apply the function to each split subset
value_rank_model1 <- lapply(metric_split1, nb_fit1)
# pops_diet_ranked1  <- rbind(metric_split1$`Castellanos Morales et al. 2008_scat_count`, metric_split1$`Calderón Vega 2002b_scat_count`, metric_split1$`Calderón Vega 2002a_scat_count`) 
pops_diet_ranked1 <- do.call(rbind, value_rank_model1) # Merge the subsplit datasets 

# Calculate out the sp50 (CDF = 50)

# plot it out
ggplot(pops_diet_ranked, aes(x = rank, y = value, fill = Phylum)) +
  facet_wrap(~pop_id_um, scales = "free") + 
  geom_bar(stat = "identity", position="dodge") + 
  theme_classic()
  geom_point(aes(color = "Observed Data"), size = 3) +
  geom_line(aes(x = rank, y = predicted/sum(predicted), color = "Negative Binomial Fit"), size = 1) +
  scale_color_manual(values = c("Observed Data" = "red", "Negative Binomial Fit" = "blue")) +
  labs(
    x = "rank",
    y = "proportion of diet"
  )  + 
  theme_minimal()


# Frequency of Occurrence: fit a negative binomial for FO data only 

# Relative Frequency of Occurrence: fit a negative binomial for RF data only 
# filter to relative FO data
metric_split <-pops_diet_ranked %>% dplyr::filter(metric == "percent_relativeFO")
# subsplit the relativeFO by the populations
metric_splitRFO <- split(metric_split , metric_split$pop_id_um)

# Proportional Data = percent_relativeFO
# Apply fit to one dataset using glm and binomial 
nb_fit_RFO <- function(subsubset){
  nb_fit <- glm(value/100 ~ rank, data = subsubset, family = "binomial")
  nb_fit$predicted <- predict(nb_fit, type = "response")
  return(nb_fit$predicted)
}

# Apply the function to each split subset
value_rank_model_RFO <- lapply(metric_splitRFO, nb_fit_RFO)
pops_diet_ranked_RFO <- do.call(rbind, value_rank_model_RFO) # Merge the subsplit datasets back together
pops_diet_ranked_RFO_list <- circlize::adjacencyMatrix2List(pops_diet_ranked_RFO) # matrix to asc table 
rownames(pops_diet_ranked_RFO_list) <- NULL
pops_diet_ranked_RFO_list$popid_rank <- paste(pops_diet_ranked_RFO_list$from, pops_diet_ranked_RFO_list$to, sep = "_")
colnames(pops_diet_ranked_RFO_list)[colnames(pops_diet_ranked_RFO_list) == 'value'] <- 'predicted'
pops_diet_ranked_RFO_list$from <- NULL
pops_diet_ranked_RFO_list$to <- NULL



# merge predicted values to the raw data 
pops_diet_ranked <- left_join(pops_diet_ranked, pops_diet_ranked_RFO_list, by = "popid_rank")
pops_diet_RFO <- pops_diet_ranked[pops_diet_ranked$metric == "percent_relativeFO",]
# plot it out
ggplot(pops_diet_RFO, aes(x = rank, y = value/100)) +
  facet_wrap(~pop_id_um, scales = "free") + 
  geom_point(aes(color = "Observed Data"), size = 3) +
  geom_line(aes(x = rank, y = predicted, color = "Negative Binomial Fit"), size = 1) +
  scale_color_manual(values = c("Observed Data" = "red", "Negative Binomial Fit" = "blue")) +
  labs(
    x = "rank",
    y = "proportion of diet"
  )  + 
  theme_minimal()

# calculate out the sp50 

# Merge the split datasets back together
pops_diet_ranked <- do.call(rbind, int_db_lranked)
rownames(pops_diet_ranked) <- NULL


# calculate out sp50 

ggplot(pops_diet_ranked, aes(x = rank, value,  color = factor(pop_id_um))) + 
  geom_point(size = 0.5) + 
  facet_wrap(.~metric, scales = "free") + 
  theme_classic()

