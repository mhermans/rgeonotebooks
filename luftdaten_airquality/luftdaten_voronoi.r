library(leaflet)
library(sf)
library(dplyr)
library(BelgiumMaps.StatBel)

data("BE_ADMIN_REGION")
region <- st_as_sf(BE_ADMIN_REGION)
bxl <- region %>% filter(CD_RGN_REFNIS == "4000")

sensor_data <- fromJSON('http://api.luftdaten.info/static/v1/data.json', flatten = TRUE) %>%
  as_tibble() %>%
  clean_names()

measurements_data <- sensor_data %>%
  unnest() %>%
  distinct(location_id, sensor_id, value_type, .keep_all = TRUE) %>%
  mutate(value = as.numeric(value))

measurements_data <- st_as_sf(
  measurements_data, coords = c("location_longitude", "location_latitude"), 
  crs = 4326, agr = "constant")


# measurements_data %>%
#   filter(sensor_id == 8993) %>%
#   glimpse()
# 
# measurements_data %>%
#   group_by(value_type) %>%
#   tally()

# https://stackoverflow.com/a/55236074/125085

# library(ggplot2)
# ggplot(measurements_data %>% filter(value_type == 'temperature')) +
#   geom_density(aes(x = value))

bxl_measurements <- measurements_data %>%
  filter(lengths(st_within(measurements_data, bxl)) == 1) %>%
  filter(value_type == 'P1')

# bxl_measurments <- st_join(measurements_data, bxl)

bxl_voronoi <- bxl_measurements  %>% 
  st_union() %>%
  st_voronoi() %>%
  st_collection_extract()


leaflet(bxl_voronoi) %>%
  addTiles() %>%
  addPolygons() %>%
  addPolygons(data = bxl, color = 'grey')

st_sf(bxl_voronoi)

Evaluation error: TopologyException: Input geom 0 is invalid: Self-intersection at or near point ...

#do a spatial join with the original bw_sf data frame to get the data back
bxl_voronoi_poly <- st_cast(st_buffer(bxl_voronoi, 0)) %>% 
  st_intersection(bxl) %>%
  st_sf() %>%
  st_join(bxl_measurements, join = st_contains)

#create a palette (many ways to do this step)
colors <- colorNumeric(
  palette = 'Reds',
  reverse = FALSE,
  domain = bxl_voronoi_poly$value)

bxl_voronoi_poly <- bxl_voronoi_poly %>%
  mutate(popup_html = glue('<strong>Sensor ID</strong>: {sensor_id}<br/>
                           <strong>Location ID</strong>: {location_id}<br/>
                           <strong>Timestamp</strong>: {timestamp}<br/>
                           <strong>PM10-value</strong>: {value} µg/m3<br/>'))

#create the leaflet
leaflet(bxl_voronoi_poly) %>% 
  addProviderTiles('Stamen.Toner') %>%
  addPolygons(fillColor = colors(bxl_voronoi_poly$value),
              fillOpacity = 0.7, color = 'grey',
              weight = 1,
              popup = ~popup_html)

