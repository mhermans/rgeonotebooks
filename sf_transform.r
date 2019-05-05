# compare areas 

library(osmdata)
library(leaflet)
library(tmap)
library(mapview)

# https://www.openstreetmap.org/way/26434944
# https://www.openstreetmap.org/way/8611804

resp <- opq_osm_id(type = "way", id = 8611804) %>%
  opq_string() %>%
  osmdata_sf()
leuven <- resp$osm_polygons

resp <- opq_osm_id(type = "way", id = 26434944) %>%
  opq_string() %>%
  osmdata_sf()
shunbronn <- resp$osm_polygons

g_shunbronn <- st_geometry(shunbronn)
g_leuven <- st_geometry(leuven)

g_leuven <- ( g_leuven - st_centroid(g_leuven) )
g_shunbronn <- ( g_shunbronn - st_centroid(g_shunbronn) )

st_crs(g_leuven) = st_crs(leuven)
st_crs(g_shunbronn) = st_crs(shunbronn)

tm_shape(g_shunbronn) +
  tm_borders() +
  tm_fill(col = '#77dd77', alpha = .2) +
  tm_shape(g_leuven) +
  tm_borders() +
  tm_fill(col = '#228b22', alpha = .5) +
  tm_layout(frame = FALSE)
