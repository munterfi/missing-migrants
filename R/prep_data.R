prep_data <- function(file_path) {
  require(data.table)
  require(sf)
  file_path %>%
    fread() %>%
    # Split coords
    .[, c("lat", "lng") := tstrsplit(`Location Coordinates`, ", ", fixed = TRUE)] %>%
    # Replace NAs
    .[, lapply(.SD, function(x) {ifelse(is.na(x), 0, x)})] %>%
    # Sum per year and region
    .[,
      .(
        n = sum(`Number Dead` + `Minimum Estimated Number of Missing`),
        lng = mean(as.numeric(lng)),
        lat = mean(as.numeric(lat))
      ),
      by = .(year = `Reported Year`, region = `Region of Incident`)] %>%
    # Remove 2020
    .[year < 2020] %>%
    # Simple feature
    st_as_sf(coords = c("lng", "lat")) %>%
    st_set_crs(4326)
}