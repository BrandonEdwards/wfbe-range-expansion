####### Script Information ########################
# Brandon P.M. Edwards & Allison D Binley
# White-fronted Bee-eater Range Expansion
# 01-create-map.R
# Created October 2022
# Last Updated October 2022

####### Import Libraries and External Files #######

library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(ggplot2)
library(ggpubr)
theme_set(theme_pubclean())

####### Read Data #################################

wfbe_range <- read_sf("data/range", layer = "data_0")

####### Main Code #################################

# Map of South Africa
za <- ne_countries(scale = "medium", returnclass = "sf", country = "South Africa")

# Get only the South African range of WFBE
za_range <- st_intersection(za, wfbe_range)

ggplot(data = za_range) +
  geom_sf(fill = "red") +
  geom_sf(data = za, fill = NA) +
  coord_sf(xlim = c(15, 35), ylim = c(-20, -37), expand = FALSE)

####### Output ####################################
