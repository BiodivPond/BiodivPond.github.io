# Map of Europe ----
## 2025 ----
map_partners <- 
  ggplot() +
  geom_sf(data = world, fill = "gray98", color = "gray70", size = 0.3) +
  #geom_sf(data = countries, fill = "blue", color = "gray70", size = 0.3) +
  coord_sf(
    xlim = c(target_bbox["xmin"], target_bbox["xmax"]),
    ylim = c(target_bbox["ymin"], target_bbox["ymax"]),
    expand = FALSE
  ) +
  theme_minimal(base_family = "Roboto") +
  theme(
    panel.background  = element_rect(fill = "#EAF2F8", color = NA),
    panel.grid.major  = element_line(color = "white"),
    plot.title        = element_text(size = 16, face = "bold", hjust = 0.5),
    # Legend anchored inside the map near the right edge
    legend.position   = c(1, 0.55),      # inside, vertical middle
    legend.justification = c(1, 0.5),      # right-middle of legend box aligns at x=0.95
    legend.background = element_rect(fill = alpha("white", 1), color = NA),
    legend.key.size   = unit(1.5, "lines"),  # ×2
    legend.text       = element_text(size = 20),  # ×2
    legend.title      = element_text(size = 22, face = "bold")  # ×2
  ) +
  guides(color = guide_legend(override.aes = list(size = 4.2, alpha = 1))) +
  labs(
    title = NULL,
    x = NULL,
    y = NULL
  )

# --- Save the European map ---
ggsave(
  filename = "Outputs/Maps/Map_biodivpond_partners.png",
  plot = map_partners,
  width = 12, height = 8, dpi = 300
)

