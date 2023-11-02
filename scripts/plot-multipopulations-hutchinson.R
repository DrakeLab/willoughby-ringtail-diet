# manipulate Hutchinson Data 
library(tidyverse)

equalizeVectorLengths <- function(input_list) {
  # Find the maximum length among all vectors in the list
  max_length <- max(sapply(input_list, length))
  
  # Function to adjust vector lengths
  adjustLength <- function(vector) {
    if (length(vector) < max_length) {
      # If vector is shorter, pad with NA to match max_length
      return(c(vector, rep(NA, max_length - length(vector))))
    } else {
      # If vector is longer, truncate to max_length
      return(vector[1:max_length])
    }
  }
  
  # Apply the adjustLength function to each vector in the list
  equalized_list <- lapply(input_list, adjustLength)
  
  # Return the list with equalized vector lengths
  return(equalized_list)
}

# Make the diet item proportion equalized
load("Hutchinson-etal_2021/DADs_data.RData")
equalized_diet <- equalizeVectorLengths(diet)
equalized_diet <- as.data.frame(equalized_diet)

hutch_ds <- equalized_diet  %>% 
  pivot_longer(cols = 1:1167, 
               names_to = "DietID",
               values_to = "prop_diet",
               values_drop_na = TRUE)

load("Hutchinson-etal_2021/DADs_metadata.RData")
# determine which species have multiple populations 
species <- metadata %>% 
  group_by(FocalSpecies) %>% 
  summarise(n_pops = n())
count_multipops <- sum(species$n_pops > 1)
count_multipops / nrow(species)

count_multipops10 <- sum(species$n_pops > 9)
count_multipops10 / nrow(species)
# get the names of species with at least 10 pops 
multipop10_sp <- species$FocalSpecies[species$n_pops > 9] %>% droplevels()

# filter main dataset to just these multipop populations 
multipops10 <- dplyr::filter(hutch_ds, starts_with()
multipops10 <- hutch_ds[grepl(paste(multipop10_sp, collapse="|"), hutch_ds$DietID), ]

# extract only the species 

extract_name <- function(full_name) {
  parts <- unlist(strsplit(as.character(full_name), "_"))
  if (length(parts) >= 3) {
    return(paste(parts[1:2], collapse = "_"))
  } else {
    return(full_name)
  }
}

# Apply the function to create the new column
multipops10$FocalSpecies <- sapply(multipops10$DietID, extract_name)
# Need to make the rank value 
split_data <- split(multipops10, multipops10$DietID)

# Function to add a rank variable based on VariableB
add_rank_variable <- function(subset) {
  subset$rank <- rank(-subset$prop_diet, ties.method = "min")
  return(subset)
}

# Apply the function to each split subset
split_data_ranked <- lapply(split_data, add_rank_variable)

# Merge the split datasets back together
multipops10_wrank <- do.call(rbind, split_data_ranked)
rownames(multipops10_wrank) <- NULL

# Make study count variable 
multipops10_sc <- multipops10_wrank  %>% 
  group_by(DietID, FocalSpecies) %>% 
  summarise(n_dietitems = n())

# need to get a study count per species 
split_data2 <- split(multipops10_sc, multipops10_sc$FocalSpecies)

# Function to add a study count variable based on DietID
add_studycount_variable <- function(subset) {
  subset$study_count <- rank(-subset$n_dietitems, ties.method = "min")
  return(subset)
}

# Apply the function to each split subset
split_data2_counted <- lapply(split_data2, add_studycount_variable)
# Merge the split datasets back together
multipops10_sc <- do.call(rbind, split_data2_counted)
rownames(multipops10_sc) <- NULL
multipops10_sc$FocalSpecies <- NULL

# Merge the study count with rank and prop diet 
# Merge the split datasets back together
multipops10_wrank <- left_join(multipops10_wrank, multipops10_sc, by = "DietID")

ggplot(multipops10_wrank, aes(x = rank, prop_diet)) + 
  geom_point(size = 0.5, color = multipops10_wrank$study_count) + 
  facet_wrap(.~FocalSpecies, scales = "free")
  

                             
