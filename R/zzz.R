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

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # 2. We want to use the cdrs enrich_dict function to add `prompt_lab`
  # which will be used later.
  dat1$dict <- cdrs:::enrich_dict(dat1$dict)

  # Now, lets add dat1 back into env_dat
  env_dat$dat <- dat1

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
  
  # 3.3 labels (for plots)
  env_dat$params_labels <- readxl::read_xlsx(
    system.file("extdata",
                "shiny_parameters.xlsx",
                package = "shinycdrs"),
    sheet = "labels",
    col_types = c("text", "text", "text", "text")
  ) %>%
    tidyr::fill(id, Label, .direction = "down")
  
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # 4. Load the welcome page text.

  # Load Welcome page
  home <- readxl::read_xlsx(
    system.file("extdata",
                "shiny_parameters.xlsx",
                package = "shinycdrs"),
    sheet = "welcome",
    col_types = c(
      block = "text",
      accordion_title = "logical",
      parent_tag = "text",
      cell_tag = "text",
      text = "text",
      attributes = "text"
    )
  ) 
  
  home_l <- home %>%
    dplyr::group_split(block)
  
  home_l <- purrr::map(
    .x = home_l,
    .f = function(tb){
      # We need to first split the tb into two.
      html_ <- tb %>%
        dplyr::filter(accordion_title == FALSE)
      
      title_ <- tb %>%
        dplyr::filter(accordion_title == TRUE)
      
      # Second, let's create html
      html_ <- purrr::map_chr(
        .x = 1:nrow(html_),
        .f = function(i){
          
          ct <- html_$cell_tag[i]
          atts <- html_$attributes[i]
          
          # Create main tag
          if (!is.na(html_$text[i])) {
            # eg. p, a, h2, etc.
            item <- paste0("<", ct, " {atts}>", 
                           html_$text[i], 
                           "</", ct, ">")
          } else {
            # eg. img
            item <- paste0("<", ct, " {atts}>")
          }
          
          # Add or remove attributes
          if(!is.na(atts)){
            item <- stringr::str_glue(item)
          } else {
            item <- stringr::str_remove(item, "\\s\\{atts\\}")
          }
          
          # Finally add parent tag (eg. unordereedd)
          if(!is.na(html_$parent_tag[i])){
            if(stringr::str_detect(html_$parent_tag[i], "^\\/")){
              # this is an end tag, so append it.
              item <- paste0(
                item,
                "<",
                html_$parent_tag[i],
                ">"
              )
            } else {
              # this is a starting tag, so prepend it.
              item <- paste0(
                "<",
                html_$parent_tag[i],
                ">",
                item
              )
            }
          }
          
          # return
          item
        }) |>
        # flatten this vector into a single string
        paste0()
      
      # Third, we convert this into an html chunk.
      html_ <- htmltools::HTML(html_)
      
      # Finally, we'll get the title of the AccordionItem
      title_ <- title_ %>%
        dplyr::pull(text)
      
      # return
      list(
        title = title_,
        html = html_
      )
    })

  
  # now we'll create a list of inputs for shinyMobile::AccordionItem()
  env_dat$home <- purrr::map(
    .x = seq_along(home_l), 
    .f = function(i) {
      l <- home_l[[i]]
                                       
    list(
      title = l$title,
      l$html,
      open = (i == 1) # Open the first item only
    )
  })


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # 5. Add cross tabs selectizeInput options
  env_dat$xt_vars <- {
    nm <- names(dat$data)
    out <- "County"
    out <- c(out, nm[stringr::str_detect(nm, "(^Q)|(\\_P$)")])
    # return
    out
  }

}
