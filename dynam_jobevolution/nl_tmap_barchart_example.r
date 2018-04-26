library(tmap)
library(dplyr)
library(sf)
library(tidyr)
library(ggplot2)
library(tmaptools)

data(NLD_prov)
NLD_prov <- st_as_sf(NLD_prov)

origin_data <- NLD_prov %>% 
  st_set_geometry(NULL) %>% 
  mutate(FID= factor(1:n())) %>% 
  select(FID, origin_native, origin_west, origin_non_west) %>% 
  gather(key=origin, value=perc, origin_native, origin_west, origin_non_west, factor_key=TRUE)

origin_cols <- get_brewer_pal("Dark2", 3)

grobs <- lapply(split(origin_data, origin_data$FID), function(x) {
  ggplotGrob(ggplot(x, aes(x="", y=-perc, fill=origin)) +
               geom_bar(width=1, stat="identity") +
               scale_y_continuous(expand=c(0,0)) +
               scale_fill_manual(values=origin_cols) +
               theme_ps(plot.axes = FALSE))
})

names(grobs) <- NLD_prov$name

nl.bar <- tm_shape(NLD_prov) +
  tm_polygons() +
  tm_symbols(size="population", shape="name", 
             shapes=grobs, 
             sizes.legend=c(.5, 1,3)*1e6, 
             scale=1, 
             legend.shape.show = FALSE, 
             legend.size.is.portrait = TRUE, 
             shapes.legend = 22, 
             title.size = "Population",
             id = "name",
             popup.vars = c("population", "origin_native",
                            "origin_west", "origin_non_west")) +
  tm_add_legend(type="fill", 
                col=origin_cols, 
                labels=c("Native", "Western", "Non-western"), 
                title="Origin")

nl.bar

tmap_mode("view")
nl.bar
tmap_mode('plot')
