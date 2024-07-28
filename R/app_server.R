#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # # Read the HTML file content
  # htmlFile <- file.path("inst", "app", "www", "homepage.html")
  # htmlContent <- readLines(htmlFile, warn = FALSE)
  # 
  # # Render the HTML content
  # output$home_html <- renderUI({
  #   HTML(paste(htmlContent, collapse = "\n"))
  # })
  
  # Call module server functions
  # mod_crosstabs_server("crosstabs_1")
  mod_graphs_server("graphs_1")
}

