# From http://leafletjs.com/examples/choropleth/us-states.js
states <- geojsonio::geojson_read(
  "https://raw.githubusercontent.com/rstudio/leaflet/gh-pages/json/us-states.geojson",
  what = "sp")

bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
pal <- colorBin("YlOrRd", domain = states$density, bins = bins)

labels <- sprintf(
  "<strong>%s</strong><br/>%g people / mi<sup>2</sup>",
  states$name, states$density
) %>% lapply(htmltools::HTML)

leaflet(states) %>%
  setView(-96, 37.8, 4) %>%
  addProviderTiles("MapBox", options = providerTileOptions(
    id = "mapbox.light",
    accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN'))) %>%
  addPolygons(
    fillColor = ~pal(density),
    weight = 2,
    opacity = 1,
    color = "white",
    dashArray = "3",
    fillOpacity = 0.7,
    highlight = highlightOptions(
      weight = 5,
      color = "#666",
      dashArray = "",
      fillOpacity = 0.7,
      bringToFront = TRUE),
    label = labels,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "15px",
      direction = "auto")) %>%
  addLegend(pal = pal, values = ~density, opacity = 0.7, title = NULL,
            position = "bottomright")


# BE versie

bins <- c(0.0, 0.5, 1, 1.5, 2.0, 2.5)
pal <- colorBin("Greens", domain = provinces$netto_pct, bins = bins)

library(glue)

provinces <- provinces %>%
  mutate(popup_lbl = str_glue("<h3>{province_lbl}</h3><br /><b>Jobtoename: </b>{netto_pct}"))

labels <- sprintf(
  "<strong>%s</strong><br/>Jobtoename: %1.2f%%<br/>Jobafname: %1.2f%%<br/>Netto evolutie: %1.2f%%<br/>",
  provinces$province_lbl, provinces$bruto_toename_pct*100, provinces$bruto_afname_pct*100, provinces$netto_pct
) %>% lapply(htmltools::HTML)

map_title <- tags$div(
  HTML('<b>Netto jobevolutie per provincie, 2015-2016 (<a href="https://dynamresearch.be/">dynaM</a>)</b>')
)  

m.dynam.prov <- leaflet(provinces) %>%
  # setView(-96, 37.8, 4) %>%
  addPolygons(
    fillColor = ~pal(netto_pct),
    weight = 2,
    opacity = 1,
    color = "white",
    dashArray = "3",
    fillOpacity = 0.7,
    highlight = highlightOptions(
      weight = 5,
      color = "#666",
      dashArray = "",
      fillOpacity = 0.7,
      bringToFront = TRUE),
    label = labels,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "15px",
      direction = "auto")) %>%
  addLegend(
    title = 'Jobevolutie (%)',
    pal = pal, values = ~netto_pct, opacity = 0.7,
            position = "topright") %>%
  addControl(map_title, position = "bottomleft")

library(htmlwidgets)
library(here)

saveWidget(
  m.dynam.prov, file = here::here('dynam_jobevolution', 'dynam_netto_map_selfcontained.html'), 
  selfcontained = TRUE,
  background = 'white')

saveWidget(
  m.dynam.prov, file = here::here('dynam_jobevolution', 'dynam_netto_map_notselfcontained.html'), 
  selfcontained = FALSE,
  background = 'white')
