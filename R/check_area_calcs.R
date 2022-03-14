# Compare shapefile area estimates to sf estimates

library(sf)
library(magrittr)
dsn <- here::here("arcmap", "Bering_Sea_Spatial_Products_2022.gdb")
layers <- sf::st_layers(dsn)
area_crs <- 3338

for(ii in 1:length(layers)) {
  sel_layer <- sf::st_read(dsn = dsn, layer = layers$name[ii])
  sel_layer$sf_stratum_area_km2 <- sel_layer %>%
    sf::st_transform(crs = area_crs) %>%
    sf::st_area()
  assign(layers$name[ii], value = sel_layer)

}

(EBS_strata_Conner2019$Shape_Area - as.numeric(EBS_strata_Conner2019$sf_stratum_area_km2))/EBS_strata_Conner2019$Shape_Area
(EBS_strata_Conner2022$Shape_Area - as.numeric(EBS_strata_Conner2022$sf_stratum_area_km2))/EBS_strata_Conner2022$Shape_Area
(NBS_strata_Conner2022$Shape_Area - as.numeric(NBS_strata_Conner2022$sf_stratum_area_km2))/NBS_strata_Conner2022$Shape_Area
(NBS_strata_Conner2019$Shape_Area - as.numeric(NBS_strata_Conner2019$sf_stratum_area_km2))/NBS_strata_Conner2019$Shape_Area
