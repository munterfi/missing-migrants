prep_data <- function(file_path) {
  require(data.table)
  require(sf)
  file_path %>%
    fread() %>%
    # Split coords
    .[, c("lat", "lng") := tstrsplit(`Location Coordinates`, ", ", fixed = TRUE)] %>%
    # Replace NAs
    .[, lapply(.SD, function(x) {ifelse(is.na(x), 0, x)})] %>%
    # Add n and define region, year
    .[,
      c("n", "region", "year") := .(
        `Number Dead` + `Minimum Estimated Number of Missing`,
        `Region of Incident`,
        # ifelse(`UNSD Geographical Grouping` %in% c("", "Uncategorized"),
        #        `Region of Incident`, `UNSD Geographical Grouping`),
        `Reported Year`)] %>%
    # Remove current year
    .[year < max(year)] %>%
    # Get all combinations
    setkey(year, region) %>% 
    .[CJ(year, region, unique = TRUE)] %>% 
    # Sum per year and region
    .[,
      .(
        n = sum(n),
        lng = sum(as.numeric(lng) * n) / sum(n),
        lat = sum(as.numeric(lat) * n) / sum(n)
      ),
      by = .(year = year, region = region)] %>%
    # Fill missing lng/lat
    .[, c("n", "lng", "lat") := .(
      ifelse(is.na(n), 0, n),
      na.approx(lng, rule = 2, na.rm = FALSE),
      na.approx(lat, rule = 2, na.rm = FALSE)
      ),
      region] %>% 
    # Special case: "Central Asia" only one year, interpolation fails...
    .[region == "Central Asia",
      c("lng", "lat") := .(
        mean(lng, na.rm = TRUE),
        mean(lat, na.rm = TRUE)
       )
      ] %>% 
    # Simple feature
    st_as_sf(coords = c("lng", "lat")) %>%
    st_set_crs(4326)
}