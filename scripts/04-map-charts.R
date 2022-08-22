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
er_data[nrow(er_data) + 1,] <- c(NA,NA,NA,NA,"Marine West Coast Forest","#7c7c7c",NA)
er_data[nrow(er_data) + 1,] <- c(NA,NA,NA,NA,"Tropical Wet Forests","#7c7c7c",NA)
er_data$er1_name <- as.factor(er_data$er1_name )

# plot histogram timeline by ecoregion
er_plot <- ggplot(er_data, aes(x = as.numeric(Decade), group = er1_name)) + 
  # plot rectangle first because elements will be stacked 
  geom_rect(
    aes(xmin=-Inf, xmax=Inf,
                 ymin=0, ymax=4),    # size of plot area
                 fill=er_data$er1_color) + # outside aes so colors are read as their identity and not assigned
  geom_histogram() + # count of studies by decade
  facet_wrap(~ er1_name, labeller = labeller(er1_name = label_wrap_gen(width = 25)), scales = 'free') + # each ecoregion gets own plot
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1)) + # rotate x axis tick labels
  theme_classic() + # minimal graph elements
  scale_x_continuous(limits=c(1920,2025)) + scale_y_continuous(limits=c(0,4)) + # make sure x axis on all facet rows
  ylab('Studies') +
  xlab('')
 
#  theme(plot.title= element_text(hjust=.5), 
#        panel.background = element_rect(fill=unique(er_data$er1_color)))
pdf(file = "figures/map.pdf", height = 7, width = 15) #default is inches
print(er_plot)
dev.off() 
