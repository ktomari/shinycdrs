#' graph module plotting preparation function
#' 
#' @param l list of tibbles. Each tibble contains a single question, but spans several rows due to each question. The tibble includes columns from 'shiny_parameters.xlsx'.
#' 
#' @return list
mod_graph_prep <- function(l){

  purrr::map(.x = l, .f = function(tb){
    # First obtain a subset of the data dictionary
    # for the question in tb, eg. Q1_*
    qids_ <- tb$Variable %>%
      unique()
    
    # retrieve params_labels for this qid.
    plabs_ <- env_dat$params_labels %>%
      dplyr::filter(Variable %in% qids_)
    
    # Determine weighting.
    params_g <- env_dat$params_graphs %>%
      dplyr::filter(Variable %in% qids_)
    
    if("Demographics" %in% params_g$block){
      set_wgt <- FALSE
    } else {
      set_wgt <- TRUE
    }
    
    # get prep object
    prep_ <- cdrs::cdrs_plt_prep(
      data_ = env_dat$dat$data,
      cols_ = qids_,
      dict_ = env_dat$dat$dict,
      is_weighted = set_wgt,
      txt_options = list(
        label_form = "short",
        title_form = "short",
        subtitle_ = F,
        caption_ = T
      )
    )

    if(nrow(plabs_) > 0){
      prep_$id <- plabs_$id %>%
        unique()
      
      prep_$pLabel <- plabs_$Label %>% 
        unique()
    } else {
      prep_$pLabel <- NA
    }
    
    # return
    prep_
  })
}

#' @title Collapse id and text label
#' 
#' @description
#' Using `paste0`, combine the id and lab, eg. "1. Do you..." and possibly combining multiple labels together, eg. "19a. Do you... & 19b. Do you..."
#' 
#' @param id character. Text-based id from the CDRS.
#' @param lab character. Question from CDRS.
#' @return shiny tag p object.
#' @noRd
graph_label <- function(id, lab){
  full_questions <- purrr::map2_chr(.x = id, 
                                    .y = lab, 
                                    .f = ~paste0(c(.x, .y), collapse = ". "))
  if(length(full_questions) > 1){
    full_questions <- lapply(full_questions, function(x) {
      shiny::tagList(x, shiny::tags$br())
    })
  } else {
    full_questions <- shiny::tagList(full_questions)
  }
  
  # return
  do.call(shiny::tags$p, full_questions)
}