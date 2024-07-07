#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  
  # Call module server functions
  # mod_crosstabs_server("crosstabs_1")
  mod_graphs_server("graphs_1")
}

