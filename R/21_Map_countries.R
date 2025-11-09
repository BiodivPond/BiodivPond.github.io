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

# --- Compute bbox aspect ratio in a projected CRS (use 3035 if available) ---
# target_bbox must be an object created previously (an sfc or bbox). 

# If target_bbox is already an sfc use that, otherwise convert
if (inherits(target_bbox, "bbox")) {
  target_sfc <- st_as_sfc(target_bbox)
} else {
  target_sfc <- target_bbox
}

# Transform to a projected CRS for correct linear aspect (use LAEA 3035)
crs_for_aspect <- 3035
target_sfc_proj <- st_transform(target_sfc, crs_for_aspect)
bb <- st_bbox(target_sfc_proj)

# aspect = height / width (y/x)
aspect_ratio <- as.numeric((bb["ymax"] - bb["ymin"]) / (bb["xmax"] - bb["xmin"]))

# Choose target pixel width (or height) for final image
# Pick a reasonable width (e.g. 3000 px) and compute height from aspect ratio:
out_width_px <- 3000L
out_height_px <- max(1L, round(out_width_px * aspect_ratio))

# --- Save with exact pixel dimensions and white background ----
# 'units = "px"' works with ggsave (ggplot2 >= 3.3.0). We also set bg="white".
ggsave(
  filename = "Outputs/Maps/Map_biodivpond_partners.png",
  plot = map_partners,
  width = out_width_px,
  height = out_height_px,
  units = "px",
  dpi = 300,
  bg = "white"
)

