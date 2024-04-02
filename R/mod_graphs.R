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
  htmltools::tagList(
    shiny::selectInput(inputId = shiny::NS(id, "titles"),
                label = "Choose a variable",
                choices = unique(env_dat$params_graphs$short_title)),
    htmltools::div(shiny::plotOutput(shiny::NS(id, "plot1")),
        class = "custom-plot-output"),
    htmltools::div(shiny::uiOutput(shiny::NS(id, "prompt_label")),
        class = "custom-text-output")
  )
}

#' graphs Server Functions
#'
#' @noRd
mod_graphs_server <- function(id){
  shiny::moduleServer( id, function(input, output, session){
    ns <- session$ns

    # rct_vars ----
    rct_vars <- shiny::reactive({
      if(length(input$titles) >= 1){
        vars_ <- env_dat$params_graphs %>%
          dplyr::filter(short_title %in% input$titles) %>%
          dplyr::pull(Variable) %>%
          unique()

        # return
        vars_
      }
    })

    # output$prompt_label ----
    output$prompt_label <- shiny::renderUI({
      vars_ <- rct_vars()

      if(is.null(vars_)){
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

      if(nrow(out) == 0){
        return(NULL)
      }

      html_ <- out$output %>%
        unique() %>%
        paste0(collapse = "<br>")

      html_ <- paste0("Survey question prompt(s):<br>", html_)

      htmltools::HTML(html_)
    })

    # output$plot1 ----
    output$plot1 <- shiny::renderPlot({
      cols_ <- rct_vars()

      if(is.null(cols_)){
        return(NULL)
      }

      prep_ <- cdrs::cdrs_plt_prep(
        data_ = env_dat$dat$data,
        cols_ = cols_,
        dict_ = env_dat$dat$dict,
        txt_options = list(
          label_form = "short",
          title_form = "short",
          subtitle_ = F,
          caption_ = T
        )
      )

      if(prep_$type %in% "dichotomous"){
        plt <- cdrs::cdrs_plt_bar(prep_)
      } else if(prep_$type %in% "categorical"){
        plt <- cdrs::cdrs_plt_pie(prep_)
      } else if(prep_$type %in% c("ordinal", "diverging")){
        plt <- cdrs::cdrs_plt_stacked(prep_)
      } else {
        plt <- NULL
      }

      # return
      plt
    })
  })
}

## To be copied in the UI
# mod_graphs_ui("graphs_1")

## To be copied in the server
# mod_graphs_server("graphs_1")
