####### Script Information ########################
# Brandon P.M. Edwards & Allison D Binley
# White-fronted Bee-eater Range Expansion
# 01-create-map.R
# Created October 2022
# Last Updated October 2022

####### Import Libraries and External Files #######

library(sf)
sf_use_s2(FALSE)
library(rnaturalearth)
library(rnaturalearthdata)
library(ggplot2)
library(ggpubr)
library(viridis)
library(magrittr)
theme_set(theme_pubclean())

####### Read Data #################################

wfbe_range <- read_sf("data/range", layer = "data_0")
wfbe_ebird <- read.csv("data/wfbe-ebird.csv")

####### Main Code #################################

# Map of South Africa
za <- ne_countries(scale = "medium", returnclass = "sf", country = "South Africa")

# Get only the South African range of WFBE
za_range <- st_intersection(za, wfbe_range)

points <- data.frame(lat = wfbe_ebird$lat, lon = wfbe_ebird$lon) %>%
  st_as_sf(coords = c("lon", "lat"), crs = st_crs(za_range))

wfbe_ebird_nox <- wfbe_ebird[which(wfbe_ebird$abund != "X"), ]
wfbe_ebird_x <- wfbe_ebird[which(wfbe_ebird$abund == "X"), ]

wfbe_full <- ggplot(data = za_range) +
  geom_sf(fill = "red") +
  geom_sf(data = za, fill = NA) +
  coord_sf(xlim = c(15, 35), ylim = c(-20, -37), expand = FALSE) +
  geom_point(data = wfbe_ebird_nox, aes(x = lon, y = lat),
             size = 2*log(as.numeric(wfbe_ebird_nox$abund) + 1),
             color = "red", alpha = 0.7) +
  geom_point(data = wfbe_ebird_x, aes(x = lon, y = lat),
             size = 2, shape = 4) +
  geom_rect(aes(xmin = 17, xmax = 24, ymin = -35, ymax = -31), color = "black", fill = NA) +
  geom_rect(aes(xmin = 24, xmax = 31, ymin = -35, ymax = -31), color = "black", fill = NA) +

  NULL

wfbe_wc <- ggplot(data = za_range) +
  geom_sf(fill = "red") +
  geom_sf(data = za, fill = NA) +
  coord_sf(xlim = c(17, 24), ylim = c(-31, -35), expand = FALSE) +
  geom_point(data = wfbe_ebird_nox, aes(x = lon, y = lat),
             size = 4*log(as.numeric(wfbe_ebird_nox$abund) + 1),
             color = "red", alpha = 0.7) +
  geom_point(data = wfbe_ebird_x, aes(x = lon, y = lat),
             size = 4, shape = 4) +
  NULL

wfbe_ec <- ggplot(data = za_range) +
  geom_sf(fill = "red") +
  geom_sf(data = za, fill = NA) +
  coord_sf(xlim = c(24, 31), ylim = c(-31, -35), expand = FALSE) +
  geom_point(data = wfbe_ebird_nox, aes(x = lon, y = lat),
             size = 4*log(as.numeric(wfbe_ebird_nox$abund) + 1),
             color = "red", alpha = 0.7) +
  geom_point(data = wfbe_ebird_x, aes(x = lon, y = lat),
             size = 4, shape = 4) +
  NULL

blank <- ggplot() + theme_void()
####### Output ####################################

png(filename = "output/wfbe_range_full.png",
    width = 6, height = 6, units = "in", res = 300)
print(wfbe_full)
dev.off()

png(filename = "output/wfbe_range_wc.png",
    width = 6, height = 6, units = "in", res = 300)
print(wfbe_wc)
dev.off()

png(filename = "output/wfbe_range_ec.png",
    width = 6, height = 6, units = "in", res = 300)
print(wfbe_ec)
dev.off()

png(filename = "output/combined.png",
    width = 12, height = 12, units = "in", res = 300)
ggarrange(ggarrange(blank, wfbe_full, blank, ncol = 3, widths = c(1,2.5,1)),
          ggarrange(wfbe_wc, blank, wfbe_ec, ncol = 3, widths = c(2.5,1,2.5)),
          nrow = 2)
dev.off()
