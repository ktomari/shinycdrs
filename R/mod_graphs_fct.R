#' graph module plotting preparation function
#' 
#' @param l list of tibbles. Each tibble contains a single question, but spans several rows due to each question. The tibble includes columns from 'shiny_parameters.xlsx'.
#' 
#' @return list
mod_graph_prep <- function(l){
  purrr::map(.x = l, .f = function(tb){
    # First obtain a subset of the data dictionary
    # for the question in tb, eg. Q1_*
    qids_ <- tb$Variable
    
    prep_ <- cdrs::cdrs_plt_prep(
      data_ = env_dat$dat$data,
      cols_ = qids_,
      dict_ = env_dat$dat$dict,
      is_weighted = TRUE,  # TODO make conditional
      txt_options = list(
        label_form = "short",
        title_form = "short",
        subtitle_ = F,
        caption_ = T
      )
    )
    
    # return
    prep_
  })
}