load_data <- function(){
  # get zip file from /data dir.
  path_ <- list.files(path = app_sys("data"),
             pattern = "\\.zip$",
             full.names = T)[1]
  # read
  dat <- cdrs::cdrs_read(path_)

  # convert counties
  co <- counties %>%
    dplyr::select(COUNTYFP, NAME) %>%
    dplyr::rename("County" = "NAME") %>%
    sf::st_set_geometry(NULL)

  dat <- dat %>%
    dplyr::left_join(y = co,
                     by = c("geoid.county" = "COUNTYFP")) %>%
    dplyr::select(-geoid.county)

  # return
  dat
}

# load data (one time only)
data_ <- load_data()

# cross tabs variables
xt_vars <- {
  nm <- names(data_)
  out <- "County"
  out <- c(out, nm[stringr::str_detect(nm, "(^Q)|(\\_P$)")])
  # return
  out
}
