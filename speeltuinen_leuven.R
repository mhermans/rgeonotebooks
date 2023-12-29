# ########################### #
# Speeltuinen in Groot-Leuven #
# ########################### #

library(osmdata)
library(sf)
library(mapview)
library(dplyr)
library(leaflet)
library(leafpop)

q_leuven <- opq(bbox = 'Leuven, Belgium') %>% # set bounding box via name
  add_osm_feature(key = 'leisure', value = 'playground') %>% # get playgrounds
  osmdata_sf() # return as a sf-object
playgrounds <- q_leuven$osm_polygons

playgrounds %>%
  group_by(access) %>%
  tally()

names(playgrounds$geometry) <- NULL 

st_coordinates(playgrounds)

leaflet(playgrounds) %>%
  addTiles() %>%
  addMarkers()

mapview(playgrounds %>% filter(access != 'private'))

leuven_playgrounds %>% pull(osm_polygons())

leuven_recreation_ground <- opq(bbox = 'Leuven, Belgium') %>% # set bounding box via name
  add_osm_feature(key = 'landuse', value = 'recreation_ground') %>% # get playgrounds
  add_osm_feature(key = 'name') %>% # include the name
  osmdata_sf() # return as a sf-object

leuven_recreation <- bind_rows(
  leuven_playgrounds$osm_polygons,
  leuven_recreation_ground$osm_polygons)

mapview(leuven_recreation)
add_osm_feature(key = 'landuse', value = 'recreation_ground') %>%

add_osm_feature(key = 'landuse', value = 'recreation_ground') %>%
playgrounds <- leuven_playgrounds$osm_polygons

mapview(leuven_playgrounds$osm_polygons)
