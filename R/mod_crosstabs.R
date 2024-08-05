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
    shinyMobile::f7Card(
      div(
        class = "selection-label",
        "Select two options:"  # Standalone label text
      ),
      shinyMobile::f7SmartSelect(
        inputId = shiny::NS(id, "xtvars"),
        label = NULL,
        choices = unique(env_dat$params_crosstabs$short_title),
        selected = c("1. General Relation to the Delta - Resident",
                     "Zone"),
        multiple = TRUE,
        maxLength = 2,
        searchbar = TRUE,
        openIn = "sheet"
      )
    ),
    # Placeholder for the DT table
    shinyMobile::f7Card(
      # htmltools::div(
      gt::gt_output(shiny::NS(id, "table")),
        # class = "custom-gt-output"),
      footer = htmltools::div(
        shiny::uiOutput(shiny::NS(id, "prompt_label")),
        class = "custom-text-output")
    ),
    shinyMobile::f7Accordion(
      side = "left",
      shinyMobile::f7AccordionItem(
        title = "About This Table",
        open = FALSE,
        htmltools::HTML(
          paste0('<p>This "cross-tabulation table" is used to compare two survey questions or, in some cases, different options from survey variables, such as one of the several ways residents relate to the Delta. In technical terms, this table represents a two-way weighted cross-tabulation. Weighting allows us to correct for biases that may arise from the survey sampling process, such as the common survey issue of the overrepresentation of "female" respondents.</p>',
          '<p>The cells in the table display both the count and the percentage of the overall population that falls into each intersection (or "cross") of the two categories. For example, a cell might show the number and percentage of "male" respondents who identify as Delta residents. The sum of all percentages displayed in the body of the table equals 100% of the surveyed population, ensuring that all responses are accounted for.</p>',
          '<p>In contrast, the percentages in the bottom row, labeled "Sum," indicate the total percentage of respondents in each column category, such as the total number of "male" respondents. This provides a quick overview of the distribution of responses across each category and helps identify trends or patterns within the survey data.</p>',
          '<p>The data comes from the 2023 California Delta Residents survey. For more information please visit the <a href="https://ktomari.github.io/DeltaResidentsSurvey/">project homepage</a>, which includes links to the data and the open source code used in this web app.</p>'
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

    # rct_vars ----
    rct_vars <- reactive({
      if(length(input$xtvars) == 2){
      vars_ <- env_dat$params_crosstabs %>%
        dplyr::filter(short_title %in% input$xtvars) %>%
        dplyr::pull(Variable) %>%
        unique()

      # return
      vars_
      }
    })

    # output$prompt_label ----
    output$prompt_label <- shiny::renderUI({
      vars_ <- rct_vars()

      if(length(vars_) != 2){
        return(NULL)
      }

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

    # output$table ----
    # Render the DT table DT::renderDT
    output$table <- gt::render_gt({
        vars_ <- rct_vars()

        if(length(vars_) != 2){
          return(NULL)
        }

        prep_ <- cdrs::cdrs_gt_prep(
          data_ = env_dat$dat$data,
          col1 = vars_[1],
          col2 = vars_[2],
          dict_ = env_dat$dat$dict,
          add_labs = TRUE,
          add_title = TRUE,
          label_threshold = 20
        )
        
        gt_ <- cdrs::cdrs_gt_simple(
          prep_
        )

        # return
        gt_
    })
  })
}

## To be copied in the UI
# mod_crosstabs_ui("crosstabs_1")

## To be copied in the server
# mod_crosstabs_server("crosstabs_1")
