#' Vietnamese TB data
#'
#' A dataset containing the quarterly TB incidence by province in Vietnam from
#' 2010 to 2015.
#'
#' The provinces' definition used is before the merging of the provinces of Ha
#' Tay and Ha Noi. Note also that we consider the TB hospital separately. Unless
#' explictly specified otherwise, TB cases are pulmonary ones. Finally, note that
#' the columns 4 to 11 are exclusive, meaning that one case cannot below to
#' different columns at the same time.
#'
#' @format A data frame with 1,560 rows and 11 variables:
#' \itemize{
#'    \item \code{year}: year of case
#'    \item \code{quarter}: quarter of case
#'    \item \code{province}: province name
#'    \item \code{pos_afb_new}: AFB-positive corresponding to a new infection
#'    \item \code{pos_afb_relapse}: AFB-positive corresponding to a relapse
#'    \item \code{pos_afb_fail}: AFB-positive corresponding to a treatment failure
#'    \item \code{pos_afb_retreatment}: AFB-positive corresponding to a retreatment
#'    \item \code{pos_afb_other}: AFB-positive corresponding to other cases that the 4 listed above
#'    \item \code{neg_afb}: AFB-negative
#'    \item \code{nptb}: non-pulmonary tuberculosis
#'    \item \code{neg_afb_nptb}: AFB-negative corresponding to non-pulmonary tuberculosis
#' }
#' @source National TB Programme of Vietnam.
"tbvn"
