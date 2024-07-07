#' graphs UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_graphs_ui <- function(id){
  ns <- shiny::NS(id)
 
  shiny::tagList(
    shinyMobile::f7Accordion(
      id = "graph_accordion",
      side = "left",
      shinyMobile::f7AccordionItem(
        title = "Survey Section Selection",
        open = TRUE,
        shinyMobile::f7Select(
          inputId = shiny::NS(id, "selected_sections"),
          label = NULL,
          choices = unique(env_dat$params_graphs$block),
          style = list(
            description = NULL,
            media = shinyMobile::f7Icon("menu"),
            outline = FALSE
          )
        )
      ),
      # TODO adjust, improve, and polish the Advanced Options
      shinyMobile::f7AccordionItem(
        title = "Advanced Options",
        open = FALSE
        # shiny::sliderInput(
        #   inputId = shiny::NS(id, "height"),
        #   label = "height",
        #   min = 100,
        #   max = 500,
        #   value = 250
        # ), 
        # shiny::sliderInput(
        #   inputId = shiny::NS(id, "width"),
        #   label = "width",
        #   min = 100,
        #   max = 500,
        #   value = 250
        # )
      )
    ),  # END accordion
    shiny::uiOutput(ns("graph_cards"))
  )  # END taglist
}

#' graphs Server Functions
#'
#' @noRd
mod_graphs_server <- function(id){
  shiny::moduleServer(id, function(input, output, session){
    ns <- session$ns

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # rct_vars ----
    # returns list of necessary specifications for cdrs::plt...
    rct_preps <- shiny::reactive({
      if(length(input$selected_sections) == 1){
        # Using "graphs" tab in "shiny_paramters.xlsx",
        # filter this section (from the summary report),
        # then, by question, split table into list of tables
        vars_ <- env_dat$params_graphs %>%
          dplyr::filter(block %in% input$selected_sections) %>%
          dplyr::group_split(short_title)
        
        preps_ <- mod_graph_prep(vars_)

        # return (list of cdrs plot preparation objects)
        preps_
      }
    })
    
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Output the card content
    output$graph_cards <- shiny::renderUI({
      # get list of tibbles 
      # (for each question in selected section)
      # preps_ <- lapply(rct_preps()

      card_list <- lapply(1:length(rct_preps()), function(i) {
        # create card id
        card_id <- ns(paste("plot", i, sep = "_"))
        
        title_ <- rct_preps()[[i]]$title
        
        shinyMobile::f7Card(
          title = title_,
          shiny::plotOutput(outputId = card_id)
        )
      })
      
      do.call(shiny::tagList, card_list)
    })
    
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    observe({
      # go through each plt prep object...
      purrr::walk(1:length(rct_preps()), function(i) {
        # create an 'output' label
        # (Note, do not use `ns()` here.)
        card_id <- paste("plot", i, sep = "_")
        # extract the plt prep object for this iteration.
        prep_ <- rct_preps()[[i]]
        # remove the caption
        prep_$caption <- NULL
        prep_$title <- NULL
        
        # Generate the plot based on type
        plt_ <- switch(prep_$type,
                       "dichotomous" = cdrs::cdrs_plt_bar(prep_),
                       "categorical" = cdrs::cdrs_plt_pie(prep_),
                       "ordinal" = cdrs::cdrs_plt_stacked(prep_),
                       "diverging" = cdrs::cdrs_plt_stacked(prep_),
                       NULL  # Default case if none match
        )
        
        # render the image and save it into output.
        if (!inherits(plt_, "NULL")) {
          output[[card_id]] <- 
            shiny::renderPlot(
            # custom size adjustment.
            # width = function() input$width,
            # height = function() input$height,
            {plt_})
        } else {
          message("Plot object is NULL for index: ", i)
        }
      })
    })
  
  })
}

## To be copied in the UI
# mod_graphs_ui("graphs_1")

## To be copied in the server
# mod_graphs_server("graphs_1")
