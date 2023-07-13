

refugis <- httr2::request("https://opendata-ajuntament.barcelona.cat/data/api/action/datastore_search?resource_id=7ecae024-6cb2-427d-b2d0-e170500e2a38&limit=300") |>
  httr2::req_perform() |>
  httr2::resp_body_string() |>
  jsonlite::fromJSON()

refugis <- refugis$result$records

refugis <- sf::st_as_sf(refugis, coords = c(x = "geo_epgs_25831_x", y = "geo_epgs_25831_y"), crs = "EPSG:25831") # està al revés


refugis <- sf::st_transform(refugis[,c("name", "geometry")], crs = "EPSG:4326")
usethis::use_data(refugis, overwrite = TRUE)


refugis_barri <- sf::st_intersection(refugis, sf::st_make_valid(verdbcn::barris))

refugis_barri <- refugis_barri |>
  sf::st_drop_geometry() |>
  dplyr::summarise(refugis = n(), .by = name.1) |>
  rename("name" = "name.1")

barris_area_ombra <- verdbcn::barris_area_ombra |>
  dplyr::left_join(refugis_barri, by = "name") |>
  dplyr::mutate(refugis = ifelse(is.na(refugis), 0, refugis))

usethis::use_data(barris_area_ombra, overwrite = TRUE)
