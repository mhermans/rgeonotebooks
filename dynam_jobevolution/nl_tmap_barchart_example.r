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
  tm_symbols(
    #size="population", 
    shape="name", 
             shapes=grobs, 
             #sizes.legend=c(.5, 1,3)*1e6, 
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




dynam.prov.l <- dynam.prov %>%
  select(province_lbl, netto_pct, bruto_afname_pct, bruto_toename_pct) %>%
  gather(key = 'eenheid', value = 'percentage', netto_pct, bruto_afname_pct, bruto_toename_pct)

antw <- dynam.prov.l %>% filter(province_lbl == 'Antwerpen')

p.antw <- ggplot(antw, aes(x = eenheid, y = eenheid, fill=percentage)) + 
  geom_bar(stat='identity') + 
  theme_void() +
  theme(
    #plot.axes = FALSE, 
    legend.position = 'none',
    panel.background = element_rect(fill = "transparent"), # bg of the panel
    plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
    panel.grid.major = element_blank(), # get rid of major grid
    panel.grid.minor = element_blank(), # get rid of minor grid
    legend.background = element_rect(fill = "transparent"), # get rid of legend bg
    legend.box.background = element_rect(fill = "transparent") # get rid of legend panel bg
    )

grobs <- rep(ggplotGrob(p.antw), 11)

grobs <- list()
grobs[[1]] <- ggplotGrob(p.antw)
grobs[[2]] <- ggplotGrob(p.antw)
grobs[[3]] <- ggplotGrob(p.antw)
grobs[[4]] <- ggplotGrob(p.antw)
grobs[[5]] <- ggplotGrob(p.antw)
grobs[[6]] <- ggplotGrob(p.antw)
grobs[[7]] <- ggplotGrob(p.antw)
grobs[[8]] <- ggplotGrob(p.antw)
grobs[[9]] <- ggplotGrob(p.antw)
grobs[[10]] <- ggplotGrob(p.antw)
grobs[[11]] <- ggplotGrob(p.antw)

grobs <- lapply(split(dynam.prov, dynam.prov$province_lbl), function(x) {
  ggplotGrob(ggplot(x, aes(x="", y=-netto_pct, fill=province_lbl)) +
               geom_bar(width=1, stat="identity") +
               scale_y_continuous(expand=c(0,0)) +
               # scale_fill_manual(values=~province_lbl) +
               theme_ps(plot.axes = FALSE))
})

names(grobs) <- NLD_prov$name

m.dyn.prov <- tm_shape(provinces)
m.dyn.prov <- m.dyn.prov + tm_polygons(col = "netto_pct")

m.dyn.prov +
  tm_add_legend(
    type = 'text',
    title = 'aaa',
    # legend.format = list(legend.position = c(0,0)),
    labels = c('Jobtoename', 'Jobafname', 'Netto evolutie'), col = c('red', 'green', 'purple'))



# tm_symbols(
#   #size="population", 
#   shape="province_lbl", 
#   shapes=grobs, 
#   #sizes.legend=c(.5, 1,3)*1e6, 
#   scale=1, 
#   legend.shape.show = FALSE, 
#   legend.size.is.portrait = TRUE, 
#   shapes.legend = 22, 
#   title.size = "Population",
#   id = "province_lbl"
#   #popup.vars = c("population", "origin_native",
#   #               "origin_west", "origin_non_west")
#   ) +


library(leaflet)

nl.bar + tm_add_legend(
  title = 'aaa',
  labels = c('Jobtoename', 'Jobafname', 'Netto evolutie'), col = c('red', 'green', 'purple'))




nl.bar


nl.bar

tmap_mode("view")
nl.bar
tmap_mode('plot')


