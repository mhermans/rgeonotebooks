library(sf)
library(leaflet)
library(BelgiumMaps.StatBel)

data("BE_ADMIN_REGION")
region <- st_as_sf(BE_ADMIN_REGION)
bxl <- region %>% filter(CD_RGN_REFNIS == "4000")

#will work with any polygon
samplepoints_sf <- st_sample(bxl, size = 2000, type = "random", crs = st_crs(4326))[1:500]
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
  st_join(measurements_bxl, join = st_contains)

#create a palette (many ways to do this step)
colors <- colorFactor(
  palette = c("green", "yellow", "red"),
  domain = v_poly$value)

#create the leaflet
leaflet(v_poly) %>% addTiles() %>%
  addPolygons(fillColor = colors(v_poly$value),
              fillOpacity = 0.7,
              weight = 1,
                popup = paste("<strong> some variable: </strong>",v_poly$some_variable))
  
library(mapview)
mapview(v_poly)
