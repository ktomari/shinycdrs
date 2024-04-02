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
    htmltools::HTML("<p>This page allows you to examine the proportion of survey respondents that fall into various categories that appear in the survey questions. In other words, this page performs a two-way (weighted) cross tabulation. The cells in each table below represent the percent of the overall population that fall into the cross of the two categories (ie. that cell).</p>"),
    shiny::selectizeInput(inputId = shiny::NS(id, "xtvars"),
                   label = "Choose two options:",
                   choices = unique(env_dat$params_crosstabs$short_title),
                   multiple = TRUE,
                   width = "50%",
                   options = list(maxItems = 2)
                   ),
    # Placeholder for the DT table
    htmltools::div(
      gt::gt_output(shiny::NS(id, "table")),
                   class = "custom-gt-output"),
    htmltools::div(
      shiny::uiOutput(shiny::NS(id, "prompt_label")),
                   class = "custom-text-output")
    # htmlOutput(NS(id, 'table'))
    # DT::DTOutput(NS(id, "table"))
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
      if(length(input$xtvars) >= 2){
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

      # # TODO
      # return(NULL)

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

      # return
      if(nrow(out) > 1){
        prompts_ <- out$output %>%
          unique() %>%
          paste0(collapse = '\", <br>\"')

        html_ <- stringr::str_glue(
          "Crosstabulation for {vars_[1]} and {vars_[2]}. The prompt(s) for these were: <br>\"{prompts_}\"."
        )
      } else if(nrow(out) == 1){
        # lets figure out which variable has a prompt
        no_prompt_var <- vars_[vars_ != out$Variable]
        html_ <- stringr::str_glue(
          "Crosstabulation for {vars_[1]} and {vars_[2]}. The prompt for {out$Variable} was <br>\"{out$output}\"."
        )
      } else {
        html_ <- stringr::str_glue(
          "Crosstabulation for {vars_[1]} and {vars_[2]}."
        )
      }

      # RETURN
      htmltools::HTML(html_)
    })

    # output$table ----
    # Render the DT table DT::renderDT
    output$table <- gt::render_gt({
        vars_ <- rct_vars()

        if(length(vars_) != 2){
          return(NULL)
        }

        gt_ <- gt_crosstab(
          data_ = env_dat$dat$data,
          cols_ = vars_
        )

        # xt <- cdrs::cdrs_crosstab(data_ = dat$data,
        #                           cols_ = vars_,
        #                           set_fpc = T) %>%
        #   dplyr::select(!matches(stringr::regex("se",
        #                                         ignore_case = T)))

        # DT::datatable(xt,
        #               options = list(paging = FALSE,
        #                              searching = FALSE),
        #               class = "display compact")

        # table <- knitr::kable(x = xt, format = "html") %>%
        #   kableExtra::kable_styling(bootstrap_options = c("striped", "hover"),
        #                 full_width = F) %>%
        #   kableExtra::column_spec(1, bold = T) # Example customization
        #
        # # Return the table as HTML to be rendered in the UI
        # HTML(table)

        # return
        gt_
    })
  })
}

## To be copied in the UI
# mod_crosstabs_ui("crosstabs_1")

## To be copied in the server
# mod_crosstabs_server("crosstabs_1")
