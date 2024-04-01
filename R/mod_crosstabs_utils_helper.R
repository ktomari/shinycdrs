#' Creates a simple {gt} table for crosstabs.
#'
#' @param data_ is the DRS dataset.
#' @param cols_ is a character vector, length 2, of variable names, eg. Q1_0.
#' @return object of class gt_tbl
gt_crosstab <- function(
    data_,
    cols_
){
  stopifnot(inherits(data_, "data.frame"))
  stopifnot(length(cols_) == 2)

  labs <- cdrs:::plt_labels() %>%
    dplyr::filter(Variable %in% cols_)

  dat <- cdrs::cdrs_subset(data_, cols_)

  # Key Column ----
  # get name of primary column
  key_nm <- labs %>%
    dplyr::filter(Variable %in% cols_[1])

  # either name primary column by the label or the short_title.
  if(nrow(key_nm) == 0){
    # In the case of "County" there is no label in plt_labels().
    key_nm <- cols_[1]
  } else if(is.na(key_nm$label[1])){
    key_nm <- key_nm$short_title[1]
  } else {
    key_nm <- key_nm$label[1]
  }

  # By Column ----
  # get the new name for by_col
  by_col_nm <- labs %>%
    dplyr::filter(Variable %in% cols_[2])

  # either name by_col by the label or the short_title.
  if(nrow(by_col_nm) == 0){
    # In the case of "County" there is no label in plt_labels().
    by_col_nm <- cols_[2]
  } else if(is.na(by_col_nm$label[1])){
    by_col_nm <- by_col_nm$short_title[1]
  } else {
    by_col_nm <- by_col_nm$label[1]
  }

  dat <- cdrs:::remove_angle_brackets(dat, cols_)


  # create complex survey design object
  design_ <- cdrs::cdrs_design(dat)

  # get proportions
  tbl <- survey::svytable(
    formula = as.formula(paste0("~ ",
                                cols_[1],
                                " + ",
                                cols_[2])),
    design = design_
  )

  props_ <- prop.table(tbl) %>%
    as.data.frame()

  # pivot proportions table
  props_ <- props_ %>%
    tidyr::pivot_wider(names_from = names(props_)[2],
                       values_from = Freq)

  names(props_)[1] <- key_nm

  # create gt() object
  gt_ <- props_ %>%
    # dplyr::mutate(Total = "100%") %>%
    dplyr::mutate(
      dplyr::across(
        .cols = tidyselect::where(is.numeric),
        .fns = ~paste0(round(.x * 100, digits = 1), "%")
      )
    ) %>%
    gt::gt() %>%
    gt::tab_spanner(
      label = by_col_nm,
      columns = names(props_)[2:ncol(props_)]
    )

  # return
  gt_
}
