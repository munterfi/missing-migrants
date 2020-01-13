write_anim <- function(gplot, anim_file_name) {
  require(gganimate)
  anim_file_name %>%
    sprintf(mig$year %>% min(), mig$year %>% max()) %>% 
    anim_save(gplot, nframes = 150, width = 1600, height = 900)
}