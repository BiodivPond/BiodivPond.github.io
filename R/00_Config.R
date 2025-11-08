#----------------------------------------------------------#
# Load packages -----
#----------------------------------------------------------#
packages <- c(
  "tidyverse",
  "broom",
  "janitor",
  "sf", 
  "sp", 
  "proj4", 
  "openxlsx",
  "fuzzyjoin", 
  "remotes",
  "ggtext",
  "vegan",
  "ggplot2",
  "ggrepel",
  "ggforce",
  "ggspatial",
  "rnaturalearth",
  "rnaturalearthdata",
  "MASS",
  "DHARMa",
  "patchwork",
  "sjPlot",
  "report"
)

# Standard package
for (pkg in packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

#----------------------------------------------------------#
# Load data -----
#----------------------------------------------------------#

# Europe polygons
europe <- rnaturalearth::ne_countries(
  continent = "Europe", 
  scale = "medium",   
  returnclass = "sf"
  ) %>%
  dplyr::filter(
    continent == "Europe"
  )

# --- Load all countries globally, not just Europe ---
world <- ne_countries(scale = "medium", returnclass = "sf")

# --- Select European + adjacent regions (Turkey + Caucasus) ---
countries_europe_extended <- c(
  "Ireland", "Spain", #"Portugal", #"France", 
  "United Kingdom", "Belgium", #"Netherlands",
  "Luxembourg", "Germany", "Switzerland", "Austria", "Czechia", "Poland", "Slovakia",
  "Hungary", "Slovenia", "Croatia", "Bosnia and Herzegovina", "Serbia", "Montenegro",
  "Kosovo", "North Macedonia", "Albania", "Greece", "Bulgaria", "Romania", "Moldova",
  "Ukraine", "Belarus", "Lithuania", "Latvia", "Estonia", "Norway", "Sweden", "Finland",
  "Denmark", "Iceland", "Italy", "Malta", "Turkey", "Georgia", "Armenia", "Azerbaijan",
  "Russia", "Morocco", "Algeria", "Tunisia", "Libya", "Egypt", "Republic of Serbia", "Israel"
)

europe_ext <- world %>% 
  filter(admin %in% countries_europe_extended)

# Major lakes and rivers for context
lakes  <- ne_download(scale = "large", type = "lakes", category = "physical", returnclass = "sf")
rivers <- ne_download(scale = "large", type = "rivers_lake_centerlines", category = "physical", returnclass = "sf")

# Major cities (optional context)
cities <- ne_download(scale = 10, type = "populated_places", category = "cultural", returnclass = "sf") %>%
  st_transform(crs = 4326) %>%
  filter(POP_MAX > 1000000)   # label only big cities

# Extract coordinates for city labels
cities_coords <- cities %>%
  dplyr::mutate(
    lon = st_coordinates(.)[, 1],
    lat = st_coordinates(.)[, 2]
  )

crs_europe <- 3035  # Lambert Azimuthal Equal Area
europe  <- st_transform(europe, crs_europe)
europe_ext  <- st_transform(europe_ext, crs_europe)
lakes   <- st_transform(lakes, crs_europe)
rivers  <- st_transform(rivers, crs_europe)
cities  <- st_transform(cities, crs_europe)
world  <- st_transform(world, crs_europe)
europe_bbox <- st_bbox(europe_ext)  # crs already 3035

target_countries <- c(
  "Croatia", "Bulgaria", "Czechia", "Portugal",
  "Finland", "Slovakia", "Netherlands", "Italy", "Belgium",
  "Denmark", "Sweden", "Israel"
  )

countries <-
  world %>%
  dplyr::filter(admin %in% target_countries) %>%
  dplyr::filter(
    continent == "Europe" | continent == "Asia"
  ) %>%
  sf::st_crop(
    .,
    europe_bbox
  )

target_bbox <-
  countries %>%
  sf::st_bbox() %>%
  sf::st_as_sfc() %>%        
  sf::st_buffer(150000) %>%
  sf::st_bbox()

target_bbox <- st_transform(target_bbox, crs_europe)

# Okabe-Ito colourblind-friendly palette (works for up to 8 categories)
okabe_ito <- setNames(
  c("#009E73", "#E69F00","#0072B2", "#D55E00"),
  c("F", "G", "W", "O")
)

