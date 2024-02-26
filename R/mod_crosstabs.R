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
    selectizeInput(inputId = NS(id, "xtvars"),
                   label = "Choose two options:",
                   choices = xt_vars,
                   multiple = TRUE),
    # Placeholder for the DT table
    DT::DTOutput(NS(id, "table"))
  )
}

#' crosstabs Server Functions
#'
#' @noRd
mod_crosstabs_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    sub_dat <- reactive(data_[,input$xtvars])

    # Render the DT table
    output$table <- DT::renderDT({
      if(length(input$xtvars) >= 2){
        vars_ <- input$xtvars[c(1,2)]
        xt <- cdrs::cdrs_crosstab(data_ = data_,
                                  cols_ = vars_,
                                  set_fpc = T)

        DT::datatable(xt)
      }
    })
  })
}

## To be copied in the UI
# mod_crosstabs_ui("crosstabs_1")

## To be copied in the server
# mod_crosstabs_server("crosstabs_1")
