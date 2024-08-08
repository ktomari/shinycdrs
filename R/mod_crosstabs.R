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
  ns <- shiny::NS(id)
  htmltools::tagList(
    shinyMobile::f7Block(
      htmltools::div(
        style = "display: flex; align-items: center;",
        htmltools::div(
          shinyMobile::f7Tooltip(
            tag = shinyMobile::f7Badge(
              "tip", 
              color = "black",
              class = "custom-badge"
            ),
            text = "Click the ellipsis (ie. the \"Variable Selector\") button to the right to begin. This opens a popup window which allows you to select two survey question responses you would like to compare. Begin by selecting the survey question. If applicable, select a response from the available set of radio buttons."
          )
        ),
        htmltools::div(
          style = "flex-grow: 1;",
          shinyMobile::f7Tooltip(
            tag = shinyMobile::f7Button(
              inputId = shiny::NS(id, "xt_options"),
              label = NULL,
              rounded = TRUE,
              outline = FALSE,
              fill = FALSE,
              tonal = TRUE,
              icon = shinyMobile::f7Icon("ellipsis")
            ),
            text = "Variable Selector"
          )
          
        )
      )
    ),
    shinyMobile::f7Card(
      gt::gt_output(shiny::NS(id, "table")),
      footer = htmltools::div(
        shiny::uiOutput(shiny::NS(id, "prompt_label")),
        class = "custom-text-output"
        )
    ),
    shinyMobile::f7Card(
      shinyMobile::f7Accordion(
        side = "left",
        shinyMobile::f7AccordionItem(
          title = "About This Table",
          open = FALSE,
          htmltools::tags$p(
            "This \"cross-tabulation table\" is used to compare two survey questions or, in some cases, different options from response items within a question, such as one of the several ways residents relate to the Delta. In technical terms, this table represents a two-way weighted cross-tabulation. Weighting allows us to correct for biases that may arise from the survey sampling process, such as the common survey issue of the overrepresentation of \"female\" respondents, so that we can report survey results that are representative of the sentiments of the full Delta population (with 95% confidence)."
          ),
          htmltools::tags$p(
            "The cells in the table display the percentage of survey respondents that fall into each intersection (or \"cross\") of the two categories. For example, a cell might show the percentage of \"male\" respondents \"feel attached to the natural environment of the Delta\". By presenting weighted frequencies, the crosstab tables indicate the estimated percentage of the TOTAL Delta population that fall into each intersection. For the same example, our results indicate that 22% of Delta residents are males that identify as attached to the natural environment of the Delta."
          ),
          htmltools::tags$p(
            "The sum of all percentages displayed in the body of the table equals 100% of the surveyed population, ensuring that all responses are accounted for. In contrast, the percentages in the bottom row, labeled \"Sum,\" indicate the total percentage of respondents in each column category, such as the total percentage of \"male\" respondents (48%) or \"female\" respondents (52%). The percentages in the far right column, labeled \"Sum\", indicate the total percentage of respondents in each row category, such as the total percentage of residents who feel attached to the natural environment (40%), or not (60%). This provides a quick overview of the distribution of responses across each category and helps identify trends or patterns that should be reflective of the Delta population at large."
          ),
          htmltools::tags$p(
            "The data comes from the 2023 California Delta Residents survey. For more information please visit the ",
            shinyMobile::f7Link(
              label = "project homepage",
              href = "https://ktomari.github.io/DeltaResidentsSurvey/"
            ),
            ", which includes links to the data and the open source code used in this web app."
          )
        )
      )
    )
  )
}

#' crosstabs Server Functions
#'
#' @noRd
mod_crosstabs_server <- function(id){
  shiny::moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # rV: selected QIDs ----
    # Reactive value to store selected items
    selected_qid1 <- shiny::reactiveVal(NULL)
    selected_qid2 <- shiny::reactiveVal(NULL)
    on_startup <- shiny::reactiveVal(TRUE)
    
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # oE: popup ----
    observeEvent(input$xt_options, {
      shinyMobile::f7Popup(
        id = ns("xt_popup"),
        fullsize = F,
        closeOnEscape = TRUE,
        swipeToClose = FALSE,
        page = TRUE,
        shinyMobile::f7Block(
          htmltools::tags$p(
            "Please select two variables and any corresponding response levels."
          )
        ),
        shinyMobile::f7Card(
          shinyMobile::f7Select(
            inputId = ns("q1"),
            label = "Select Variable 1",
            choices = sort_vars(unique(env_dat$params_crosstabs$question)),
            selected = "Zone"
          ),
          shiny::uiOutput(ns("q1_response_selection"))
        ),
        shinyMobile::f7Card(
          shinyMobile::f7Select(
            inputId = ns("q2"),
            label = "Select Variable 2",
            choices = sort_vars(unique(env_dat$params_crosstabs$question)),
            selected = "1. General Relation to the Delta"
          ),
          shiny::uiOutput(ns("q2_response_selection"))
        ) 
      )
    })
    
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # oE: q1 ----
    shiny::observeEvent(list(input$q1, input$q1_radio), {
      # Filter out radio selection which is a full_response
      qid <- filter_params(
        question_ = input$q1,
        response_ = input$q1_radio
      )
      
      if(length(qid) != 1){
        qid <- NULL
      }
      
      selected_qid1(qid)
    })
    
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # oE: q2 ----
    shiny::observeEvent(list(input$q2, input$q2_radio), {
      # Filter out radio selection which is a full_response
      qid <- filter_params(
        question_ = input$q2,
        response_ = input$q2_radio
      )
      
      if(length(qid) != 1){
        qid <- NULL
      }
      
      selected_qid2(qid)
    })
    
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # q1 resp ----
    output$q1_response_selection <- shiny::renderUI({
      shiny::req(input$q1)  # Ensure there is a selection
      
      l <- resp_filter(
        selected_qid = selected_qid1(),
        other_selected_qid = selected_qid2(),
        selected_question = input$q1
      )
      
      if(!inherits(l, "list")){
        return(NULL)
      }
      
      if(length(l$selected) == 0 |
         length(l$choices) == 0){
        return(NULL)
      }
      
      shinyMobile::f7Radio(
        inputId = ns("q1_radio"),
        label = paste("Responses for", input$q1),
        choices = l$choices,
        selected = l$selected
      )
    })
    
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # q2 resp ----
    output$q2_response_selection <- shiny::renderUI({
      shiny::req(input$q2)  # Ensure there is a selection
      
      l <- resp_filter(
        selected_qid = selected_qid2(),
        other_selected_qid = selected_qid1(),
        selected_question = input$q2
      )
      
      if(!inherits(l, "list")){
        return(NULL)
      }
      
      if(length(l$selected) == 0 |
         length(l$choices) == 0){
        return(NULL)
      }
      
      shinyMobile::f7Radio(
        inputId = ns("q2_radio"),
        label = paste("Responses for", input$q2),
        choices = l$choices,
        selected = l$selected
      )
      })

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # output$prompt_label ----
    output$prompt_label <- shiny::renderUI({
      c1 <- selected_qid1()
      c2 <- selected_qid2()
      
      if(inherits(c1, "NULL") & 
         inherits(c2, "NULL")){
        c1 <- "Zone"
        c2 <- "Q1_1"
      }
      
      vars_ <- c(c1, c2)

      out <- env_dat$dat$dict %>%
        dplyr::filter(Variable %in% vars_) %>%
        tidyr::nest(.by = Variable,
                    .key = "nested") %>%
        dplyr::mutate(output = purrr::map(nested, function(tb){
          if("prompt_lab" %in% tb$name){
            return(tb$value[tb$name == "prompt_lab"])
          } else if("Label" %in% tb$name){
            return(tb$value[tb$name == "Label"])
          } else {
            return("")
          }
        })) %>%
        dplyr::select(Variable, output) %>%
        dplyr::filter(output != "")

      out <- out$output %>%
        unique() %>%
        paste0(collapse = '</li><li>')

      out <- paste0(
        "<b>Full survey questions:</b><br>",
        "<ul>",
        "<li>",
        out,
        "</li>",
        "</ul>"
      )

      # RETURN
      htmltools::HTML(out)
    })
    
    observe({
      if(on_startup()){
        selected_qid1("Zone")
        selected_qid2("Q1_1")
        on_startup(FALSE)
      }
    })

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # output$table ----
    output$table <- gt::render_gt({
      
      c1 <- selected_qid1()
      c2 <- selected_qid2()
      
      if(inherits(c1, "NULL") | 
         inherits(c2, "NULL")) {
        # These values are NULL, and 
        # startup already happened,
        # so return NULL
        return(NULL)
        
      } else if(length(c1) == 0 |
                length(c2) == 0){
        # If for some reason character() was passed to 
        # either c1 or c2, we can't do anything with it
        # so return NULL
        return(NULL)
      }
      
      # Let's automatically decide between a tall or wide table.
      width <- shinybrowser::get_width()
      
      order_by_ <- if (!is.null(width) && 
                           is.numeric(width) && 
                           width <= 768) "tall" else "rank"

      prep_ <- cdrs::cdrs_gt_prep(
        data_ = env_dat$dat$data,
        col1 = c1,
        col2 = c2,
        dict_ = env_dat$dat$dict,
        add_labs = TRUE,
        add_title = TRUE,
        order_by = order_by_,
        label_threshold = 20
      )
        
        gt_ <- cdrs::cdrs_gt_simple(
          prep_
        )

        # return
        gt_
    })
  })  # part of server module
}  # part of server module

## To be copied in the UI
# mod_crosstabs_ui("crosstabs_1")

## To be copied in the server
# mod_crosstabs_server("crosstabs_1")
