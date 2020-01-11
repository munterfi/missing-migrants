anim_plot <- function(mig, title, subtitle, caption) {
  require(ggplot2)
  require(gganimate)
  require(maps)
  legend <- data.frame(
    x = rep(187.5, 5),
    y = c(40.5, 45, 52.5, 64, 80),
    n = c(10, 100, 1000, 2000, 6000)
  )
  gplot <-
    ggplot(mig) +
    # Basemap
    geom_polygon(data = map_data("world"),
                 aes(x=long, y = lat, group = group),
                 fill="grey", alpha=0.3) +
    # Points and text
    geom_sf(aes(size = 10*n, group = region),
            alpha = 0.6, shape = 16, color = "Red", show.legend = FALSE) +
    geom_text(data = mig %>% cbind(mig %>% st_coordinates()) %>% as.data.frame(),
              aes(x = X, y = Y, label = region, size = n, group = region),
              color = "black", hjust = 1, vjust = 0, show.legend = TRUE) +
    # Caption
    geom_text(aes(x = 195, y = -80.5, label = caption),
              size = 7, fontface = "italic", color = "darkgrey",
              hjust = 1, show.legend = FALSE) +
    # Legend
    geom_point(data = legend,
               aes(x = x, y = y, size = 10*n),
               color = "red", alpha = 0.6) +
    geom_text(data = legend,
              aes(x = x, y = y, label = n, size = n),
              hjust = 1, vjust = 0) +
    # Style plot
    labs(title = title, subtitle = subtitle, x = '', y = '') +
    scale_size(range = c(3, 32)) +
    guides(size = FALSE) +
    theme_classic() + 
    theme(
      plot.title = element_text(color = "red", size = 32, face = "bold"),
      plot.subtitle = element_text(color = "black", size = 24)
    ) +
    # Animate
    transition_time(year) +
    ease_aes('linear')
  gplot
}