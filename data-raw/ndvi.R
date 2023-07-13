# downloaded dataset from here https://geoserveis.icgc.cat/servei/catalunya/ndvi/wms?REQUEST=GetMap&SERVICE=WMS&VERSION=1.3.0&LAYERS=ndvi_2022&STYLES=&FORMAT=image/tiff&BGCOLOR=0xFFFFFF&TRANSPARENT=TRUE&CRS=EPSG:25831&BBOX=420826.2,4574282.1,435505.5,4591026.6&WIDTH=1020&HEIGHT=1163
ndvi <- stars::read_stars("data-raw/wms.tiff")
ndvi <- ndvi[,,,1] # get first layer
ndvi <- stars::st_transform_proj(ndvi, "EPSG:4326")



ndvi <- sf::st_crop(ndvi, sf::st_union(verdbcn::barris)) # crop

ndvi <- stars::st_apply(ndvi, 1, \(x) ((x-100)/100))


usethis::use_data(ndvi, overwrite = TRUE)


# avg ndvi by neighbourhood
barris_ndvi <- aggregate(ndvi, verdbcn::barris, FUN = mean) |>
  sf::st_as_sf() |>
  dplyr::rename("ndvi" = "V1")

usethis::use_data(barris_ndvi, overwrite = TRUE)
