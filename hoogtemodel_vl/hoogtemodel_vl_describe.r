# Verkenning digitaal hoogtemodel Vlaanderen

DSM = digital surface model => oppervlaktte
DTM = digtal terrain model => surface + wat er op staat => interessanter 

DTM resulutie: 1m, 5m, 25m, 100m

library(zip)
# library(curl)
# library(urltools)
# urltools::url_parse(dtm_100m_source_url)

options(stringsAsFactors = FALSE)
library(raster)

dtm_100m_source_url <- 'https://downloadagiv.blob.core.windows.net/dhm-vlaanderen-ii-dtm-raster-100m/DHMVIIDTMRAS100m.zip'
temp_path <- tempfile(pattern = 'DHMVIIDTMRAS100m', fileext = '.zip')
download.file(dtm_100m_source_url, temp_path)
zip::unzip(temp_path, exdir = here::here('DHMVIIDTMRAS100m'))

dhm_100m <- raster(here::here('DHMVIIDTMRAS100m/GeoTIFF/DHMVIIDTMRAS100m.tif'))

plot(dhm_100m)

install.packages('rayshader')
library(rayshader)

dhm_100m_matrix <- raster_to_matrix(dhm_100m)

dhm_100m_matrix %>%
  sphere_shade(texture = "imhof2") %>%
  # plot_3d(windowsize = c(1200,1200), theta=40,  phi=50, zoom=0.4,  fov=90)
  plot_3d(dhm_100m_matrix, zscale = 10, fov = 0, theta = 135, zoom = 0.75, phi = 45, windowsize = c(1000, 800))
  # plot_map()



https://rstudio-pubs-static.s3.amazonaws.com/592662_db3756e6e2674d1c92dc0752b08d2677.html

https://overheid.vlaanderen.be/informatie-vlaanderen/producten-diensten/digitaal-hoogtemodel-dhmv


Importeer geotiff https://inbo.github.io/tutorials/tutorials/spatial_standards_raster/ 
  

Toepassingen
* slopes straten: https://github.com/ITSLeeds/slopes 

3D-print model van maken?
* https://www.tylermw.com/3d-printing-rayshader/
* https://edutechwiki.unige.ch/en/3D_printing_of_digital_elevation_models
* https://blog.prusaprinters.org/how-to-print-maps-terrains-and-landscapes-on-a-3d-printer_29117/
* meest recente/robuste optie om STL te maken:  https://github.com/ChHarding/TouchTerrain_for_CAGEO