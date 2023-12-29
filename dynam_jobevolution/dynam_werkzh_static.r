

bins <- c(0.0, 0.5, 1, 1.5, 2.0, 2.5)
pal <- colorBin("Greens", domain = provinces$werkzaamheidsgraad, bins = bins)
pal <- colorBin("Greens", domain = provinces$werkzaamheidsgraad)

provinces %>%
  mutate()

provinces <- provinces %>%
  mutate(netto_pct_round = paste0(round(netto_pct, 2), '%'))

tmap_mode("plot")

m.dyn.prov.stat <- tm_shape(provinces) +
  tm_polygons(col = 'werkzaamheidsgraad', palette="Greens") + 
  tm_text('netto_pct_round') +
  tm_layout(main.title = "Netto jobevolutie per provincie, 2015-2016 (%)", frame = FALSE)


save_tmap(m.dyn.prov.stat, here::here('dynam_jobevolution', 'dynam_werkz_map_statisch.png'))

names(dynam.prov)
