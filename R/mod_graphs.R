#' Graphs UI Function
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
    # Beginning of mod_graphs UI
    shinyMobile::f7Card(
      # Main container for stacked divs
      htmltools::div(
        class = "stacked-container",
        # Survey Section + Tooltip div
        htmltools::div(
          class = "select-container",
          # f7Tooltip positioned to the left
          shinyMobile::f7Tooltip(
            tag = shinyMobile::f7Badge(
              "tip", 
              color = "black",
              class = "custom-badge"
            ),
            text = "This dropdown menu allows you to pick a thematic section of the 2023 Delta Residents Survey. Scroll down to see graphs for the survey questions in the selected section."
          ),
          # Survey Section Selection input with full width
          htmltools::div(
            class = "full-width-select",
            # Survey Section Selection input
            shinyMobile::f7Select(
              label = "Survey Section",
              inputId = shiny::NS(id, "selected_sections"),
              choices = unique(env_dat$params_graphs$block),
              style = list(
                description = NULL,
                media = shinyMobile::f7Icon("menu"),
                outline = FALSE
              )
            )
          )
        ),
        # Footer for accordion section
        htmltools::div(
          class = "accordion-container",
          # f7Tooltip positioned to the left
          shinyMobile::f7Tooltip(
            tag = shinyMobile::f7Badge(
              "tip", 
              color = "black",
              class = "custom-badge"
            ),
            text = "Plot options allow you to adjust the size of the font and overall plot height to accommodate various screen sizes."
          ),
          # Accordion container
          htmltools::div(
            class = "full-width-accordion",
            shinyMobile::f7Accordion(
              id = "graph_accordion",
              side = "left",
              shinyMobile::f7AccordionItem(
                title = "Plot Options",
                open = FALSE,
                shinyMobile::f7List(
                  shiny::div(
                    class = "padded-input",
                    shiny::uiOutput(ns("stepperUI"))
                  ),
                  shiny::div(
                    class = "padded-input",
                    shinyMobile::f7Stepper(
                      inputId = shiny::NS(id, "plotHeight"),
                      label = "Plot Height (px)",
                      min = 250,
                      max = 1000,
                      step = 75,
                      size = "small",
                      value = 475,
                      wraps = FALSE,
                      autorepeat = TRUE,
                      rounded = FALSE,
                      raised = FALSE,
                      manual = TRUE
                    )
                  )
                )  # END f7List
              )  # END accordion item
            )  # END accordion
          )  # END div (for full-width-accordion)
        )  # END div (for accordion-container)
      )  # END div (for stacked-container)
    ),  # END f7Card
    shiny::uiOutput(ns("graph_cards"))
  )  # END taglist
}

#' graphs Server Functions
#'
#' @noRd
mod_graphs_server <- function(id){
  shiny::moduleServer(id, function(input, output, session){
    
    # Modules.
    ns <- session$ns
    
    # font size stepper ----
    # Render the stepper UI dynamically based on browser width
    # (Note, this only occurs at start up. 
    # If you change browser size, you must refresh the page.)
    output$stepperUI <- shiny::renderUI({
      width <- shinybrowser::get_width()
      
      initial_value <- if (!is.null(width) && 
                           is.numeric(width) && 
                           width <= 768) 10 else 20
      
      # Create the f7Stepper with the determined initial value
      shinyMobile::f7Stepper(
        inputId = ns("font_size"),
        label = "Font Size",
        min = 5,
        max = 100,
        step = 5,
        size = "small",
        value = initial_value, # Set initial value based on screen size
        wraps = FALSE,
        autorepeat = TRUE,
        rounded = FALSE,
        raised = FALSE,
        manual = TRUE
      )
    })

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # rct_vars ----
    # returns list of necessary specifications for cdrs::plt...
    rct_preps <- shiny::reactive({
      if(length(input$selected_sections) == 1){
        # Using "graphs" tab in "shiny_parameters.xlsx",
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
        
        prep_ <- rct_preps()[[i]]
        
        caps_ <- prep_$captions
        
        title_ <- prep_$title
        
        # f7Card ----
        shinyMobile::f7Card(
          # Title.
          title = title_,
          # Subtitle (ie. survey question and pLabel).
          # if `pLabel` exists, display it as a HTML paragraph
          if(!is.na(prep_$pLabel[1])){
            graph_label(prep_$id, prep_$pLabel)
            },
          footer = shinyMobile::f7Accordion(
            side = "left",
            shinyMobile::f7AccordionItem(
              title = "Details",
              shinyMobile::f7Block(paste0(caps_, collapse = " "))
            )
          ),
          # footer = ,
          shiny::plotOutput(outputId = card_id),
          # TODO
          # This is just a clumsy workaround for the issue of changing plot image size which is an Advanced Option. The core problem is that if you enlarge the ggplot2 rendered image, it doesn't also adjust the height of the f7Card. This workaround anticipates the height of the card to be 10% taller. The issue is that with increasing heights, more whitespace is added below hte ggplot2 image. This is not the most elegant solution.
          height = input$plotHeight * 1.1
        )
      })
      
      do.call(shiny::tagList, card_list)
    })
    
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    observe({
      req(input$font_size)
      # go through each plt prep object...
      purrr::walk(1:length(rct_preps()), function(i) {
        # create an 'output' label
        # (Note, do not use `ns()` here.)
        card_id <- paste("plot", i, sep = "_")
        # extract the plt prep object for this iteration.
        prep_ <- rct_preps()[[i]]
        # remove the caption

        prep_$captions <- NULL
        
        prep_$title <- NULL
        
        prep_$title_size <- input$font_size
        
        # Generate the plot based on type
        plt_ <- switch(prep_$type,
                       "dichotomous" = cdrs::cdrs_plt_bar(prep_),
                       "categorical" = cdrs::cdrs_plt_pie(prep_),
                       "ordinal" = cdrs::cdrs_plt_stacked(prep_),
                       "diverging" = cdrs::cdrs_plt_stacked(prep_),
                       "numeric" = cdrs::cdrs_plt_hist(prep_),
                       NULL  # Default case if none match
        )
        
        height_ <- input$plotHeight
        
        # renderPlot ----
        # render the image and save it into output.
        if (!inherits(plt_, "NULL")) {
          output[[card_id]] <- 
            shiny::renderPlot(
            # custom size adjustment.
            # width = function() input$width,
            # height = function() input$height,
            {plt_}, 
            height = reactive({ height_ }))
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
