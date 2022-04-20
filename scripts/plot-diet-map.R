library(sf)
library(tidyverse)
library(mapbox)
library(plotly)

points_df <- read.csv("data/literature-data/diet-studies-traits.csv")

points_df <- select(points_df, Latitude, Longitude, method)
points_df <- dplyr::filter(points_df, Latitude != "")

poly_sf <- st_read("data/literature-data/IUCN_rangemap/data_0.shp") # downloaded March 18, 2021
points_sf <- st_as_sf(points_df, coords = c("Latitude", "Longitude"), crs = st_crs(poly_sf))
ggplot()  + geom_sf(data = poly_sf) + geom_sf(data = points_sf)


Sys.setenv('MAPBOX_TOKEN' = 'pk.eyJ1IjoidGllcm5leTYiLCJhIjoiY2s2Mmk0MDJsMGVyazNqcDJiNWhmaGY4aSJ9.cYf84slEtdgoQ5gkzxpVgQ')

p <- plot_mapbox() %>% add_sf(data = poly_sf, showlegend = F)
add_sf(p = p, data = points_sf, marker = list(color = "black", size = 9))


library(maps)
library(mapdata)
library(maptools)  #for shapefiles
library(scales)  #for transparency
pbassariscus <- st_read("data/literature-data/IUCN_rangemap/data_0.shp")   #layer of data for species range
samps <- read.csv("FieldSamples.csv")   #my data for sampling sites, contains a column of "lat" and a column of "lon" with GPS points in decimal degrees
map("worldHires","Mexico", col="gray95", fill=TRUE)
map("worldHires","usa", col="gray95", xlim=c(-90.762678,-122.711744), ylim=c(28.6228125,45.1895498), fill=TRUE, add=TRUE)  #add the adjacent parts of the US; can't forget my homeland
plot(pcontorta, add=TRUE, xlim=c(-140,-110),ylim=c(48,64), col=alpha("darkgreen", 0.6), border=FALSE)  #plot the species range
points(samps$lon, samps$lat, pch=19, col="red", cex=0.5)  #plot my sample sites

