#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )
  
  tags$head(
    favicon(ext = "png"),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "shinycdrs"
    ),
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
    # Link to custom CSS file
    tags$link(rel = "stylesheet", 
              type = "text/css", 
              href = "www/custom.css")
  )
}

#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinybrowser
#' @noRd
app_ui <- function(request) {
  shiny::tagList(
    # Add resources (ie. where custom.css and images are located, inst/app/www)
    golem_add_external_resources(),
    # shinybrowser is used here to get information about the user's device.
    shinybrowser::detect(),
    # begin shinyMobile page
    shinyMobile::f7Page(
      options = list(
        dark = FALSE  # Set the default theme to light
      ),
      # Add Google Font in the header
      tags$head(
        tags$link(
          href = "https://fonts.googleapis.com/css2?family=Roboto+Slab:wght@400&family=Montserrat:wght@500;800&display=swap",
          rel = "stylesheet"
        )
      ),
      # Layout
      shinyMobile::f7TabLayout(
        # Layout Navbar
        navbar = shinyMobile::f7Navbar(
          title = "California Delta Residents Survey Data Explorer",
          hairline = TRUE,
          leftPanel = FALSE,
          rightPanel = FALSE
        ),  # END navbar
        # Tabs
        shinyMobile::f7Tabs(
          animated = TRUE,
          # Tab 1: Home
          shinyMobile::f7Tab(
            title = "Home",
            tabName = "home",
            icon = shinyMobile::f7Icon("house"),
            shinyMobile::f7Accordion(
              id = "home_accordion",
              side = "left",
              # Content, derived from env_dat$home in zzz.R
              purrr::map(.x = env_dat$home,
                         .f = ~do.call(shinyMobile::f7AccordionItem,
                                       .x)
              )
            )
            
          ),
          # Tab 2: Graphs
          shinyMobile::f7Tab(
            title = "Graphs",
            tabName = "graphs",
            icon = shinyMobile::f7Icon("chart_bar_alt_fill"),
            mod_graphs_ui("graphs_1")
          ),
          # Tab 3: Tables
          shinyMobile::f7Tab(
            title = "Cross Tables",
            tabName = "tables",
            icon = shinyMobile::f7Icon("table"),
            mod_crosstabs_ui("crosstabs_1")
          )
        )  # END tabs
      )  # END tab layout
    )  # END page
  )  # END tagList
}


