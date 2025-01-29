# coarsen Bering prediction grid for index model computation

library(akgfmaps)

# Load Jason's csv output for comparison
arcmap_ebs <- read.csv(file = here::here("data", "VAST_raster_EBS_2022.csv"), stringsAsFactors = FALSE)
arcmap_nbs <- read.csv(file = here::here("data", "VAST_raster_NBS_2022.csv"), stringsAsFactors = FALSE)

# Load survey area polygon
bs <- akgfmaps::get_base_layers("ebs", set.crs = "EPSG:3338")

ggplot() +
  geom_sf(data = bs$survey.area,
          fill = NA,
          mapping = aes(color = "Survey area"))

# create a coarsened grid using the raster package
resolution_original <- 3704
resolution <- resolution_original * 6 # define what factor to coarsen by

r <- raster::raster(as(bs$survey.area, "Spatial"), resolution = resolution)
rr <- raster::rasterize(as(bs$survey.area, "Spatial"), r, getCover = TRUE)

grid <- as.data.frame(raster::rasterToPoints(rr))
grid$area <- grid$layer * resolution * resolution
grid <- dplyr::filter(grid, area > 0) |>
  dplyr::select(-layer) |>
  dplyr::rename(X = x, Y = y)
grid$area_km2 <- grid$area/1e6
grid <- dplyr::select(grid, -area)

ggplot(grid, aes(X, Y, colour = area_km2)) +
  geom_tile(width = 2, height = 2, fill = NA) +
  scale_colour_viridis_c(direction = -1) +
  geom_point(size = 0.5) +
  coord_fixed()

nrow(grid) # check N cells

## Check for differences in total stratum area in KM
diff <- sum(grid$area_km2) - (sum(arcmap_ebs$Area_KM2) + sum(arcmap_nbs$Area_KM2))
diff # -17.64967 new grid is a little bigger in area, maybe due to islands?
diff/sum(grid$area_km2)*100 # but this is only -0.00255% difference

# In summary, this is an acceptable approach
