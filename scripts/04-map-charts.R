# load libraries 
library(tidyverse) # data wrangling
library(gridExtra) # arranging multiple plots in one 

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
p.list = lapply(sort(unique(er_data$er1_name)), function(i) {
  er_subset <- er_data[er_data$er1_name==i,]
  ggplot(er_subset, aes(x = as.numeric(Decade), group = er1_name)) + 
    # plot rectangle first because elements will be stacked 
    geom_rect(
      aes(xmin=-Inf, xmax=Inf,
          ymin=0, ymax=4),    # size of plot area
      fill=unique(er_subset$er1_color)) + # outside aes so colors are read as their identity and not assigned
    geom_histogram() + # count of studies by decade
    facet_wrap(~ er1_name, labeller = labeller(er1_name = label_wrap_gen(width = 25)), scales = 'free') + # each ecoregion gets own plot
    theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1)) + # rotate x axis tick labels
    theme_classic() + # minimal graph elements
    scale_x_continuous(limits=c(1920,2025)) + scale_y_continuous(limits=c(0,4)) + # make sure x axis on all facet rows
    ylab('Studies') +
    xlab('')
}
)
  
# save output plot
pdf(file = "figures/map.pdf", height = 8.5, width = 11) #default is inches
grid.arrange(p.list[[1]],
             p.list[[2]],
             p.list[[3]],
             p.list[[4]],
             p.list[[5]],
             p.list[[6]],
             p.list[[7]],
             p.list[[8]],
             p.list[[9]],
             p.list[[10]],
             layout_matrix = matrix(c(3, NA, NA, 2, 
                                      6, NA, NA, 1, 
                                      4,NA, NA, 9,
                                      7, 5, 8, 10), 
                                    byrow = TRUE, ncol = 4))

dev.off() 

