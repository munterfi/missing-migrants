# ------------------------------------------------------------------------------
# Visualization of IOM's Missing Migrants Project data (2014-2019).
# Download: https://missingmigrants.iom.int/downloads
# 2020-01-08, info@munterfinger.ch
# ------------------------------------------------------------------------------

# Pkgs: Uncomment if needed
# install.packages("data.table")
# install.packages("ggplot2")
# install.packages("gganimate")
# install.packages("maps")
# install.packages("sf")

# Funcs
source("R/prep_data.R") 
source("R/anim_plot.R")
source("R/write_anim.R") 

# Read & preprocess
mig <- prep_data("data/MissingMigrants-Global-2020-01-08T14-05-32.csv")

# Create map
title <- 
  'Migration {frame_time}: Dead and missing persons'
subtitle <- 
  "Displayed is the geographic centroid of the incidents per region and year."
caption <- 
  "© munterfinger.ch, author: @munterfi1, data: missingmigrants.iom.int"
gplot <- anim_plot(mig,title, subtitle, caption)

# Save animation
gplot %>% write_anim("docs/migration_%s_%s.gif")
