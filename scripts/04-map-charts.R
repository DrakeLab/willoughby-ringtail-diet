# load libraries 
library(tidyverse) # data wrangling

# load data
studies <- read.csv('data/studies.csv')
# filter to only included studies
studies$X <- NULL 
studies <- studies %>% 
  dplyr::filter(Inclusion_Status == "include")
# select out columns of interest
er_data <- select(studies, source_id, Latitude, Longitude, ecoregion_lvl1, er1_name, er1_color, Decade)

# add in ecoregions with no data 
er_data[nrow(er_data) + 1,] <- c("","","","","Marine West Coast Forest", "","")
er_data[nrow(er_data) + 1,] <- c("","","","","Tropical Wet Forests", "","")
er_data$er1_name <- as.factor(er_data$er1_name )
er_data <- er_data %>% dplyr::filter(Decade != "")

# plot histogram timeline by ecoregion
er_plot <- ggplot(er_data, aes(x = Decade)) +
  geom_histogram(stat = "count") +
  facet_wrap(~ er1_name, labeller = labeller(er1_name = label_wrap_gen(width = 25))) + 
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1)) + 
  ylab('Studies') +
  xlab('') # + 
#  theme(plot.title= element_text(hjust=.5), 
#        panel.background = element_rect(fill=unique(er_data$er1_color)))
er_plot