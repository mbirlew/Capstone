library(tidyverse)   # loading ggplot2 and dplyr

library(sf)                # Simple Features for GIS

library(rnaturalearth)     # package with detailed information about country &
library(rnaturalearthdata) # state/province borders, and geographical features
#devtools::install_github('ropensci/rnaturalearthhires')
library(rnaturalearthhires) # Hi-Resolution Natural Earth

#devtools::install_github("UrbanInstitute/urbnthemes")
#devtools::install_github("UrbanInstitute/urbnmapr")
library(urbnmapr)
library(urbnthemes)

library(leaflet)

# first projection 'Patterson' map
world_map <- 
  ne_countries(scale = 'large',returnclass = 'sf') %>%  # tibble containing country shapes
  ggplot() + 
  geom_sf(fill='grey') +
  ggtitle("World map", subtitle = paste0("(", length(unique(world_map$data$name)), " countries)")) +
  theme(panel.grid.major = element_line(color = gray(.5), linetype = 'dashed', linewidth = 0.5),
        panel.background = element_rect(fill = 'aliceblue'))
world_map

# second projection 'Mollwiede' map
Mollwiede <- world_map +
  coord_sf(crs = '+proj=moll') +      # change the projection to Mollweide
  labs(title='Mollweide Projection')
Mollwiede

# third projection 'Robinson' map
#Robinson <- world_map +
 # coord_sf(crs = '+proj=robin') +    # change the projection to Robinson
  # labs(title='Robinson Projection')
#Robinson

# import main data set scrapped from census bureau
library(readxl)
UCB_final <- read_excel("~/Documents/Capstone/UCB_final.xlsx")

# change char M and K to appropriate digits
UCB_data <- UCB_final
UCB_data$population <- str_replace_all(UCB_data$population, 'M', '00000')
UCB_data$population <- str_replace_all(UCB_data$population, 'K', '00')
UCB_data$population <- str_replace_all(UCB_data$population, '[.]', '')
#UCB_data$population<-gsub(".",",",as.character(UCB_final$population))

# change char to number
UCB_data$population <- as.numeric(as.character(UCB_data$population))
UCB_data$people_sqmi <- as.numeric(as.character(UCB_data$people_sqmi))
UCB_data$males_per_100females <- as.numeric(as.character(UCB_data$males_per_100females))
UCB_data$children_per_women <- as.numeric(as.character(UCB_data$children_per_women))

# try mapping data
ggplot(data = world_map) +
  geom_sf(aes(fill = UCB_data$population)) +
  scale_fill_viridis_c(option = "plasma", trans = "sqrt")

