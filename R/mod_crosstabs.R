#' crosstabs UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_crosstabs_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' crosstabs Server Functions
#'
#' @noRd 
mod_crosstabs_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_crosstabs_ui("crosstabs_1")
    
## To be copied in the server
# mod_crosstabs_server("crosstabs_1")
