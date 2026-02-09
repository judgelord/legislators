#' @title Names of members of the US Congress
#' @description A dataset of the names of all members of each United States Congress, including presidents. The `pattern` column serves as a lookup table to match members of Congress to text supplied to [extractMemberName()].
#' @format A data frame with 51053 rows and 10 variables:
#' \describe{
#'   \item{\code{congress}}{double The Congress}
#'   \item{\code{chamber}}{character House or Senate}
#'   \item{\code{bioname}}{character voteview.com name formatted LAST, First}
#'   \item{\code{pattern}}{character Regular expression pattern for matching}
#'   \item{\code{icpsr}}{double ICPSR ID}
#'   \item{\code{state}}{double State code from voteview.com}
#'   \item{\code{state_abbrev}}{character State}
#'   \item{\code{district_code}}{double District}
#'   \item{\code{boiguide_id}}{character congress.gov Bioguid ID}
#'   \item{\code{first_name}}{character First Name}
#'   \item{\code{last_name}}{character Last Name}
#'}
#' @details DETAILS
"members"
