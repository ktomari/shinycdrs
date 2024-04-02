library(sf)
library(tidyverse)
library(tigris)

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

# Public data
path_ <- list.files(path = "data-raw",
                    pattern = "\\.zip",
                    full.names = T)

dat <- cdrs::cdrs_read(path_ = path_)

usethis::use_data(
  counties,
  dat,
  internal = T,
  overwrite = T)




