## code to prepare `barris` dataset goes here

barris <- osmdata::opq("Barcelona") |>
  osmdata::add_osm_feature("admin_level", "10") |>
  osmdata::osmdata_sf()
barris <- barris$osm_multipolygons
barris <- barris[!is.na(as.numeric(barris$ref)),]
barris <- barris[,c("osm_id", "name", "geometry")]
usethis::use_data(barris, overwrite = TRUE)
