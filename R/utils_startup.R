#' @importFrom magrittr %>%
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

  dat$data <- dat$data %>%
    dplyr::left_join(y = co,
                     by = c("geoid.county" = "COUNTYFP")) %>%
    dplyr::select(-geoid.county) %>%
    dplyr::mutate(County = forcats::as_factor(County))

  # return
  dat
}

# load data (one time only)
dat <- load_data()

dat$dict <- cdrs:::enrich_dict(dat$dict)

# Load parameters
# graphs
params_graphs <- readxl::read_xlsx(
  system.file("extdata",
              "shiny_parameters.xlsx",
              package = "shinycdrs"),
  sheet = "graphs",
  col_types = c("text", "text", "logical")
) %>%
  dplyr::filter(listed == TRUE)

# crosstabs
params_crosstabs <- readxl::read_xlsx(
  system.file("extdata",
              "shiny_parameters.xlsx",
              package = "shinycdrs"),
  sheet = "crosstabs",
  col_types = c("text", "text", "logical")
) %>%
  dplyr::filter(listed == TRUE)

# Load Welcome page
welcome_html <- readLines(
  con = system.file("extdata",
                    "welcome.html",
                    package = "shinycdrs")
)


# cross tabs variables
xt_vars <- {
  nm <- names(dat$data)
  out <- "County"
  out <- c(out, nm[stringr::str_detect(nm, "(^Q)|(\\_P$)")])
  # return
  out
}


