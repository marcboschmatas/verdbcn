# locate green clusters - i.e. areas where trees have higher NDVI values
# process: download tree locations. Take NDVI values @ each tree location. Filter for trees @ locations with ndvi > .4
# Create neighbours network w/ a 10 metre cutoff distance. Filter those w/ at least 3 nbs. Generate convex hulls


arbrat_viari <- data.table::fread("https://opendata-ajuntament.barcelona.cat/data/dataset/27b3f8a7-e536-4eea-b025-ce094817b2bd/resource/bf69e08d-6925-48ed-a892-b2fd34d0d080/download")
head(arbrat_viari)

arbrat_parcs <- data.table::fread("https://opendata-ajuntament.barcelona.cat/data/dataset/99ce00b1-36ab-4e06-b1bc-c60c5f7a811d/resource/f45b340f-df68-40f4-bb8f-de88c5388216/download")


arbrat_zona <- data.table::fread("https://opendata-ajuntament.barcelona.cat/data/dataset/9b525e1d-13b8-48f1-abf6-f5cd03baa1dd/resource/e4ae73d6-e144-4880-9ab4-550f5b9c0bfe/download")


arbrat <- data.table::rbindlist(lapply(list(arbrat_viari, arbrat_parcs, arbrat_zona), \(x) x[,c("codi", "x_etrs89", "y_etrs89")]))

arbrat <- sf::st_transform(sf::st_as_sf(arbrat, coords = c(x = "x_etrs89", y = "y_etrs89"), crs = "EPSG:25831"), "EPSG:4326")

ndvi<- verdbcn::ndvi |> stars::st_warp(stars::st_as_stars(sf::st_bbox(verdbcn::barris)))
plot(ndvi)

arbrat_ndvi <- stars::st_extract(ndvi, arbrat)

arbrat_ndvi <- dplyr::rename(arbrat_ndvi, "ndvi" = "wms.tiff")
tmap::qtm(arbrat_ndvi,dots.col = "ndvi")


# create neighbours structure

arbrat_frondos <- arbrat_ndvi |>
  dplyr::filter(ndvi >= .4) |>
  sf::st_transform("EPSG:25831") |>
  dplyr::mutate(nbs = sfdep::st_dist_band(geometry, lower = 0, upper = 10),
                num_nbs = vapply(nbs, length, 0),
                first = purrr::map_dbl(nbs, \(x) x[[1]])) |>
  dplyr::filter(first != 0)

arbrat_frondos$nbs <- sfdep::st_dist_band(arbrat_frondos$geometry, lower = 0, upper = 10) # new neighbours
arbrat_xarxa <- igraph::graph_from_adj_list(adjlist = arbrat_frondos$nbs)



ids <- igraph::components(arbrat_xarxa)$membership # crear un vector amb el grup al qual pertany cada arbre


arbrat_frondos$grup <- as.character(ids)

hulls <- arbrat_frondos |>
  dplyr::filter(num_nbs >= 3) |>
  dplyr::group_by(grup) |>
  dplyr::summarise() |>
  sf::st_convex_hull()

hulls <- dplyr::filter(hulls, sf::st_geometry_type(geometry)=="POLYGON" & as.numeric(sf::st_area(geometry)) >= 100)
tmap::tmap_mode("view")


usethis::use_data(hulls, overwrite = TRUE)


# total hull area by neighbourhood

hulls_by_nh <- hulls |>
  sf::st_transform(4326) |>
  sf::st_intersection(verdbcn::barris) |>
  sf::st_make_valid() |>
  dplyr::mutate(area = as.numeric(sf::st_area(geometry))) |>
  sf::st_drop_geometry() |>
  dplyr::summarise(area = sum(area), .by = name)


barris_area_ombra <- verdbcn::barris |>
  dplyr::left_join(hulls_by_nh) |>
  dplyr::mutate(area = ifelse(is.na(area), 0, area))


usethis::use_data(barris_area_ombra)
