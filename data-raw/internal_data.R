library(sf)
library(tidyverse)

counties <- tigris::counties(state = "06")

public_set_counties <- c(
  "013",
  "095",
  "067",
  "113",
  "077"
)

counties <- counties %>%
  filter(COUNTYFP %in% public_set_counties)

usethis::use_data(
  counties,
  internal = T,
  overwrite = T)
