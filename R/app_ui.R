#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  # begin shinyMobile page
  shinyMobile::f7Page(
    options = list(
      dark = FALSE  # Set the default theme to light
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
        shinyMobile::f7Tab(
          title = "Home",
          tabName = "home",
          icon = shinyMobile::f7Icon("house"),
          shinyMobile::f7Block(
            # htmlOutput("home_html")
            shiny::includeHTML("inst/app/www/homepage.html")
          )
        ),
        shinyMobile::f7Tab(
          title = "Graphs",
          tabName = "graphs",
          icon = shinyMobile::f7Icon("chart_bar_alt_fill"),
          mod_graphs_ui("graphs_1")
        )
      )  # END tabs
    )  # END tab layout
  )  # END page
  
}

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
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
