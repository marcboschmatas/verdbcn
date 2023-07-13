#' @title make_map
#' @description makes a plot to be shown in app
#' @param base a base layer
#' @param layer layer or layers to be plotted upon base
#' @importFrom tmap tm_shape
#' @importFrom tmap tm_raster
#' @importFrom tmap tm_layout
#' @importFrom stars geom_stars
#' @importFrom stars st_warp
#' @importFrom stars st_as_stars
#' @importFrom sf st_bbox
#' @importFrom dplyr case_when
#' @importFrom tmap tm_markers
#' @importFrom tmap tm_add_legend
#' @returns a map
#' @export

make_map <- function(base = "índex de vegetació total", layers = NA){
  if(base == "índex de vegetació total"){
    p <- tmap::tm_shape(stars::st_warp(verdbcn::ndvi, stars::st_as_stars(sf::st_bbox(verdbcn::barris)))) +
      tmap::tm_raster(col = "wms.tiff",
                      alpha = .7,
                      palette = c("red", "orange", "yellow", "green", "green4"), midpoint = .4,
                      breaks = c(-1, 0, .2, .4, .6, .8),
                      title = "Índex de vegetació",
                      labels = c("Cobertes artificials o aigua", "Sòl nu o vegetació morta", "Vegetació poc vigorosa", "Vegetació vigorosa", "Vegetació molt vigorosa"))
  }
  else if(base == "índex de vegetació per barris"){
    p <- tmap::tm_shape(sf::st_make_valid(verdbcn::barris_ndvi)) +
      tmap::tm_polygons(col = "ndvi",
                        alpha = .7,
                        palette = c("red", "orange", "yellow", "green", "green4"), midpoint = .4,
                        breaks = c(-1, 0, .2, .4, .6, .8),
                        title = "Índex de vegetació mitjà",
                        labels = c("Cobertes artificials o aigua", "Sòl nu o vegetació morta", "Vegetació poc vigorosa", "Vegetació vigorosa", "Vegetació molt vigorosa"))
  }
  else if(base == "refugis climàtics per barri"){
    p <- tmap::tm_shape(sf::st_make_valid(verdbcn::barris_area_ombra)) +
      tmap::tm_polygons(col = "refugis",
                        alpha = .7,
                        palette = c("red", "orange", "yellow", "green", "green4"), midpoint = .4,
                        style = "quantile",
                        title = "Refugis climàtics")

  }
  else if(base == "verd i refugis per barri"){
    b <- verdbcn::barris_area_ombra
    b$ndvi <- verdbcn::barris_ndvi$ndvi
    b$vb <- dplyr::case_when(b$refugis >= 4 & b$ndvi > .24 ~ "molts refugis, molt verd",
                             b$refugis >= 4 & b$ndvi <= .24 ~ "molts refugis, poc verd",
                             b$refugis < 4 & b$ndvi > .24 ~ "pocs refugis, molt verd",
                             b$refugis < 4 & b$ndvi <= .24 ~ "pocs refugis, poc verd")
    p <- tmap::tm_shape(sf::st_make_valid(b)) +
      tmap::tm_polygons(col = "vb",
                        palette = c("green4", "aquamarine", "yellow", "red"),
                        title = "")
  }
  if(layers == "refugis climàtics"){
    p <- p +
      tmap::tm_shape(verdbcn::refugis) +
      tmap::tm_markers(size = .5)
  }
  else if(layers == "ombra d'arbres"){
    p <- p +
      tmap::tm_shape(verdbcn::hulls) +
      tmap::tm_polygons(col = "gray30",border.col = "gray1") +
      tmap::tm_add_legend(type = "fill", labels = "ombra d'arbres", col = "gray30", border.col = "gray1")
  }
  else if(sort(layers) == "ombra i refugis"){
  p <- p +
    tmap::tm_shape(verdbcn::hulls) +
    tmap::tm_polygons(col = "gray30",border.col = "gray1") +

    tmap::tm_shape(verdbcn::refugis) +
    tmap::tm_markers(size = .5) +
    tmap::tm_add_legend(type = "fill", labels = "ombra d'arbres", col = "gray30", border.col = "gray1")
  }
  return(p +tmap::tm_layout(fontfamily = "Roboto light"))
}






