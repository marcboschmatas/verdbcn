#' Barcelona neighbourhoods
#'
#' Polygon layer with Barcelona neighbourhoods (barris)
#'
#' @format ## `barris`
#' Simple feature collection with 73 features and 2 fields:
#' \describe{
#'   \item{osm_id}{openstreetmap item id}
#'   \item{name}{neighbourhood name}
#'   ...
#' }
#' @source Openstreetmap Collaborators
"barris"


#' Barcelona NDVI
#'
#' Raster with NDVI in Barcelona
#'
#' @format ## `ndvi`
#' stars object with 3 dimensions and 1 attribute

#' @source <https://geoserveis.icgc.cat/servei/catalunya/ndvi/wms?REQUEST=GetMap&SERVICE=WMS&VERSION=1.3.0&LAYERS=ndvi_color_2022&STYLES=&FORMAT=image/jpeg&BGCOLOR=0xFFFFFF&TRANSPARENT=TRUE&CRS=EPSG:25831&BBOX=420826.2,4574282.1,435505.5,4591026.6&WIDTH=510&HEIGHT=581>
"ndvi"


#' Avg NDVI by Barcelona neighbourhoods & number of climate shelters
#'
#' Polygon layer with Barcelona neighbourhoods (barris) and its average NDVI
#'
#' @format ## `barris_ndvi`
#' Simple feature collection with 73 features and 1 field:
#' \describe{
#'   \item{ndvi}{normalised difference vegetation index}
#'   ...
#' }
#' @source Openstreetmap Collaborators & ICGC
"barris_ndvi"

#' Number of climate shelters and tree shaded areas by Neighbourhood
#'
#' Polygon layer with Barcelona neighbourhoods (barris) and its total tree shaded area and climate shelters
#'
#' @format ## `barris_area_ombra`
#' Simple feature collection with 73 features and 2 field:
#' \describe{
#'   \item{area}{total area shaded by trees}
#'   \item{refugis}{number of climate shelters}
#'   ...
#' }
#' @source Openstreetmap Collaborators, ICGC & Ajuntament de Barcelona
"barris_area_ombra"

#' Convex hulls of trees less than 10 metres apart and NDVI > .4 over 100 sqm in surface
#'
#' Polygon layer with convex hulls of frondous tree clusters
#'
#' @format ## `hulls`
#' Simple feature collection with 858 features and 1 field:
#' \describe{
#'   \item{grup}{unique hull identifier}
#'   ...
#' }
#' @source Ajuntament de Barcelona & ICGC
"hulls"


#' Climate shelters in Barcelona
#'
#' POint layer with all shelters
#'
#' @format ## `refugis`
#' Simple feature collection with 219 features and 1 field:
#' \describe{
#'   \item{name}{shelter name}
#'   ...
#' }
#' @source <https://opendata-ajuntament.barcelona.cat/data/ca/dataset/xarxa-refugis-climatics>
"refugis"
