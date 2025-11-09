map_partners <- 
  ggplot() +
  geom_sf(data = world, fill = "gray85", color = "white", size = 0.2) +
  geom_sf(data = countries, fill = "#103b60", color = "white", size = 0.2) +
  coord_sf(
    xlim = c(target_bbox["xmin"], target_bbox["xmax"]),
    ylim = c(target_bbox["ymin"], target_bbox["ymax"]),
    expand = FALSE
  ) +
  theme_void() +
  theme(
    # force white backgrounds so exported PNG is not transparent
    panel.background   = element_rect(fill = "white", color = NA),
    plot.background    = element_rect(fill = "white", color = NA),
    # remove all outer margins so the saved image hugs the bbox
    plot.margin        = unit(c(0, 0, 0, 0), "pt"),
    
    plot.title         = element_text(size = 16, face = "bold", hjust = 0.5),
    # Legend anchored inside the map near the right edge
    legend.position    = c(1, 0.55),
    legend.justification = c(1, 0.5),
    legend.background  = element_rect(fill = alpha("white", 1), color = NA),
    legend.key.size    = unit(1.5, "lines"),
    legend.text        = element_text(size = 20),
    legend.title       = element_text(size = 22, face = "bold")
  ) +
  guides(color = guide_legend(override.aes = list(size = 4.2, alpha = 1))) +
  labs(
    title = NULL,
    x = NULL,
    y = NULL
  )

# --- Save the European map: white background, no extra padding ----
ggsave(
  filename = "Outputs/Maps/Map_biodivpond_partners.png",
  plot = map_partners,
  width = 12, height = 12, dpi = 300,
  bg = "white"   # ensure PNG background is white (not transparent)
)

