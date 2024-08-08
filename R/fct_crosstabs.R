#' resp_filter 
#'
#' @description Help create options for responses to display in the popup menu.
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
resp_filter <- function(
    selected_qid = NULL,
    other_selected_qid = NULL,
    selected_question = "Zone"
  ){
  
  # get full suite of response for this question.
  responses <- env_dat$params_crosstabs
  
  # Remove other_selected_qid from possible options
  if(!inherits(other_selected_qid, "NULL")){
    responses <- responses %>%
      dplyr::filter(Variable != other_selected_qid)
  }
  
  # Now filter choices down to the selected question
  responses <- responses %>%
    dplyr::filter(question == selected_question) %>%
    dplyr::select(Variable, full_response)
  
  # "Variables" like "Zone" should be NA
  if(NA %in% responses$full_response){
    return(NULL)
  }
  
  # Now we get all possible choices.
  choices_ <- as.list(responses$full_response)
  names(choices_) <- responses$Variable
  
  # Now we pick the default or "selected" qid
  if(inherits(selected_qid, "NULL")){
    # Nothing was selected prior,
    # so pick first one
    selected_ <- choices_[1]
  } else if(selected_qid %in% names(choices_)){
    # Something was selected prior.
    selected_ <- choices_[
      names(choices_) == selected_qid
    ]
  } else {
    # Whatever was selected prior doesn't matter.
    selected_ <- choices_[1]
  }
  
  # return
  list(
    choices = choices_,
    selected = selected_
  )
}

#' @title Filter the qid in question
#' 
#' @param question character
#' @param response character
#' @return character (qid)
#' @noRd
filter_params <- function(
    question_,
    response_
){
  # Input validation
  if(inherits(question_, "NULL")){
    return(NULL)
  }

  # first filter for "question"
  params <- env_dat$params_crosstabs %>%
    dplyr::filter(
      question == question_
    )
  
  # If there is an NA in responses, we return early
  # eg. Zone has no responses.
  if(NA %in% params$full_response){
    return(unique(params$Variable) )
  }
  
  # But if there are full responses, and response is null,
  # we return null
  if(inherits(response_, "NULL")){
    return(NULL)
  }
  
  # return qid
  params %>%
    dplyr::filter(full_response == response_) %>%
    dplyr::pull(Variable)
}

#' Sort variables vector
#' 
#' @param vars character
#' @return character
#' @noRd
sort_vars <- function(
    vars
){
  # Separate numbered and non-numbered elements
  numbered <- grep("^\\d{1,2}[[:alpha:]]*\\.", vars, value = TRUE)
  non_numbered <- grep("^\\d{1,2}[[:alpha:]]*\\.", vars, value = TRUE, invert = TRUE)
  
  # Extract the numeric part for sorting
  extract_num <- function(x) {
    sub("^([0-9]+).*", "\\1", x)
  }
  
  # Extract the alphabetical part for sorting
  extract_alpha <- function(x) {
    sub("^[0-9]+([a-z]?).*", "\\1", x)
  }
  
  # Sort numbered elements
  numbered_sorted <- numbered[order(as.numeric(sapply(numbered, extract_num)), sapply(numbered, extract_alpha))]
  
  # Sort non-numbered elements
  non_numbered_sorted <- sort(non_numbered)
  
  # Combine the sorted parts
  c(numbered_sorted, non_numbered_sorted)
}