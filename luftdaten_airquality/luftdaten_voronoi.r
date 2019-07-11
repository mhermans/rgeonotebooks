library(leaflet)
library(sf)
library(dplyr)
library(BelgiumMaps.StatBel)

data("BE_ADMIN_REGION")
region <- st_as_sf(BE_ADMIN_REGION)
bxl <- region %>% filter(CD_RGN_REFNIS == "4000")

#will work with any polygon
samplepoints_sf <- st_sample(bxl, size = 2000, type = "random", crs = st_crs(4326))[1:50]
# although coordinates are longitude/latitude, st_intersects assumes that they are planar

#create an sf-object like your example
bw_sf <- st_sf("some_variable" = sample(1:50, 500, replace = TRUE), geometry = samplepoints_sf)

#create the voronoi diagram, "some_variable" gets lost.
v <- bw_sf %>% 
  st_union() %>%
  st_voronoi() %>%
  st_collection_extract()

#do a spatial join with the original bw_sf data frame to get the data back
v_poly <- st_cast(v) %>% 
  st_intersection(bxl) %>%
  st_sf() %>%
  st_join(bw_sf, join = st_contains)

#create a palette (many ways to do this step)
colors <- colorFactor(
  palette = c("green", "yellow", "red"),
  domain = v_poly$some_variable)
  
#create the leaflet
leaflet(v_poly) %>% addTiles() %>%
  # addCircleMarkers() %>%
  addPolygons(fillColor = colors(v_poly$some_variable),
              fillOpacity = 0.7,
              weight = 1,
              popup = paste("<strong> some variable: </strong>",v_poly$some_variable))


sensor_data <- fromJSON('http://api.luftdaten.info/static/v1/data.json', flatten = TRUE) %>%
  as_tibble() %>%
  clean_names()

measurements_data <- sensor_data %>%
  unnest() %>%
  distinct(location_id, sensor_id, value_type, .keep_all = TRUE) 

measurements_data %>%
  filter(sensor_id == 8993) %>%
  glimpse()

measurements_data %>%
  group_by(value_type) %>%
  tally()

https://stackoverflow.com/a/55236074/125085

library(ggplot2)
ggplot(measurements_data %>% filter(value_type == 'temperature')) +
  geom_density(aes(x = value))

measurements_data %>%
  select(location_latitude, location_longitude)
 
library(sf)
measurements_data <- st_as_sf(
  measurements_data, coords = c("location_longitude", "location_latitude"), 
  crs = 4326, agr = "constant")


library(tmap)
qtm(x)
ggplot(x) + 
  geom_sf()
# leaflet(x) %>%
#   addMarkers()

measurements_data %>%
  filter()

measurements_data$in_bxl <- (st_within(measurements_data, bxl) == 1)

qtm(measurements_bxl)
measurements_bxl <- measurements_data %>%
  filter(lengths(st_within(measurements_data, bxl)) == 1)

measurements_bxl <- st_join(measurements_data, bxl)
st_bbox(bxl)
st_bbox(measurements_bxl)
st_bbox(bxl_voronoi)

bxl_voronoi <- measurements_bxl  %>% 
  st_union() %>%
  st_voronoi() %>%
  st_collection_extract()

leaflet(bxl_voronoi) %>%
  addTiles() %>%
  addPolygons() %>%
  addPolygons(data = bxl, color = 'grey')

st_sf(bxl_voronoi)


#do a spatial join with the original bw_sf data frame to get the data back
bxl_voronoi_poly <- st_cast(st_buffer(bxl_voronoi, 0)) %>% 
  st_intersection(bxl) %>%
  st_sf() %>%
  st_join(measurements_bxl, join = st_contains)

#create a palette (many ways to do this step)
colors <- colorFactor(
  palette = c("green", "yellow", "red"),
  domain = bxl_voronoi_poly$value)

#create the leaflet
leaflet(bxl_voronoi_poly) %>% addTiles() %>%
  addPolygons(fillColor = colors(bxl_voronoi_poly$value),
              fillOpacity = 0.7,
              weight = 1,
              popup = paste("<strong> some variable: </strong>",v_poly$some_variable))

library(mapview)
mapview(v_poly)
