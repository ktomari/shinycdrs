library(sf)
# library(tidyverse)
library(dplyr)
library(tigris)
library(cdrs)

counties <- tigris::counties(state = "06", year = 2022)

public_set_counties <- c(
  "013",
  "095",
  "067",
  "113",
  "077"
)

counties <- counties |>
  dplyr::filter(COUNTYFP %in% public_set_counties)

# Public data
path_ <- list.files(path = "data-raw",
                    pattern = "^DRS",
                    full.names = T)

dat <- cdrs::cdrs_read(path_ = path_)

usethis::use_data(
  counties,
  dat,
  internal = T,
  overwrite = T)




