# zzz.R

# This script is used for executing code during the package loading process.
# Specifically, it defines the `.onLoad()` function, which R automatically
# calls when the package is loaded. This mechanism is ideal for performing
# initial setup tasks, such as loading necessary data into custom environments,
# setting options, or performing checks to ensure the package environment is
# correctly configured before use.

# The `.onLoad()` function below demonstrates how to load data into `env_dat`
# and perform any one-time initialization or data manipulation tasks required
# for the shinycdrs package to function correctly.

.onLoad <- function(libname, pkgname) {

  # Temporary files...
  co <- counties
  dat1 <- dat

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Additional one-time setup tasks
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # 1. In this section we first manipulate the core data to include County
  # names instead of US Tiger FP codes.
  # convert counties
  co <- co %>%
    dplyr::select("COUNTYFP", "NAME") %>%
    dplyr::rename("County" = "NAME") %>%
    sf::st_set_geometry(NULL)

  dat1$data <- dat1$data %>%
    dplyr::left_join(y = co,
                     by = c("geoid.county" = "COUNTYFP")) %>%
    dplyr::select(-"geoid.county") %>%
    dplyr::mutate(County = forcats::as_factor("County"))

  # 2. We want to use the cdrs enrich_dict function to add `prompt_lab`
  # which will be used later.
  dat1$dict <- cdrs:::enrich_dict(dat1$dict)

  # Now, lets add dat1 back into env_dat
  env_dat$dat <- dat1

  # 3. Here we load parameters (eg. options for selectizeInput funs) for
  # 3.1 graphs
  env_dat$params_graphs <- readxl::read_xlsx(
    system.file("extdata",
                "shiny_parameters.xlsx",
                package = "shinycdrs"),
    sheet = "graphs",
    col_types = c("text", "text", "logical", "text")
  ) %>%
    dplyr::filter(listed == TRUE)

  # 3.2 crosstabs
  env_dat$params_crosstabs <- readxl::read_xlsx(
    system.file("extdata",
                "shiny_parameters.xlsx",
                package = "shinycdrs"),
    sheet = "crosstabs",
    col_types = c("text", "text", "logical")
  ) %>%
    dplyr::filter(listed == TRUE)

  # 4. Load the welcome page text.

  # Load Welcome page
  env_dat$welcome_html <- readLines(
    con = system.file("extdata",
                      "welcome.html",
                      package = "shinycdrs")
  )

  # 5. Add cross tabs selectizeInput options
  env_dat$xt_vars <- {
    nm <- names(dat$data)
    out <- "County"
    out <- c(out, nm[stringr::str_detect(nm, "(^Q)|(\\_P$)")])
    # return
    out
  }

}
