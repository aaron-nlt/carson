library(data.table)
library(magrittr)
library(stringr)

#' Convert NAICS codes between years/releases
#'
#' @details
#' This function matches NAICS codes in a "from_year" to corresponding codes
#' in a "to_year". The from and to years are matched to releases of NAICS based
#' on the most current NAICS release during each year. New NAICS have been
#' published every 5 years from 1997 to 2022, so setting from_year = 2006 and
#' to_year = 2011 will, for example, convert 2002 NAICS to 2007 NAICS. All
#' codes to convert must be present in the NAICS release corresponding to the
#' from year. Any codes that are not found in the from-year release will be
#' identified in a warning before return.
#'
#' @param codes A character vector of NAICS codes to be converted. All codes
#' must be valid NAICS codes (2 and 6 digits) present in the release
#' corresponding to `from_year` (see below).
#' @param from_year The year/release to convert from.
#' @param to_year The year/release to convert to.
#'
#' @returns A data.table with 3 columns:
#' * "code_\{from\}": the code in the release corresponding to `from_year`. This
#' will be a value given in `codes`.
#' * "code_\{to\}": a possible value of "code_\{from\}" in the release
#' corresponding to `to_year`. There may be more than one "code_\{to\}" for each
#' "code_\{from\}", if "code_\{from\}" maps to multiple codes in the to-year
#' release.
#' * "N": the number of 6-digit NAICS codes that fall under the umbrella of the
#' match. This can be used to make a rough estimate of how often the conversion
#' manifests. This is especially useful when one "code_\{from\}" matches to
#' multiple entries in "code_\{to\}".
#'
#' @export
#'
#' @examples
#' # Convert 3 codes from 2002 to 2022
#' convert_naics(c("32","451","926140"), 2002, 2022)
#' # Because of release schedule, the following is equivalent to the above
#' convert_naics(c("32","451","926140"), 2005, 2024)
convert_naics = function(codes, from_year, to_year){
  # Check format of code: must be 2-6 digit numeric
  if(is.numeric(codes)){
    codes = as.character(codes)
  }
  codes = unique(codes)
  if(!all(stringr::str_detect(codes, "^[0-9]{2,6}$"))){
    stop(
      "all `codes` must be 2-6 digit numbers"
    )
  }
  # Check the from/to years: must be >1997, <current year
  cy = as.integer(format(Sys.Date(), "%Y"))
  if(from_year < 1997 | from_year > cy){
    stop(
      "`from_year` must be between 1997 (release of NAICS) and the current year"
    )
  }
  if(to_year < 1997 | from_year > cy){
    stop(
      "`to_year` must be between 1997 (release of NAICS) and the current year"
    )
  }
  # Round off years for conversion. Throw an error if they map to the same year
  releases = seq(1997, cy, by=5)
  xwalk_cols = c(
    releases[max(which(from_year >= releases))],
    releases[max(which(to_year >= releases))]
  ) %>%
    paste0("code_", .)
  if(xwalk_cols[1] == xwalk_cols[2]){
    stop(
      paste0(
        from_year, " and ", to_year, "correspond to the same NAICS release"
      )
    )
  }
  # Convert by looping over codes with the same number of digits. The
  # "conversion" is a simple identification of unique rows in the xwalk.
  nd = nchar(codes)
  xwalk = naics_xwalk %>%
    data.table::setDT() %>%
    .[, xwalk_cols, with=FALSE]
  converted = lapply(unique(nd), function(n){
    codes_n = codes[nd == n]
    xwalk %>%
      data.table::copy() %>%
      .[, lapply(.SD, stringr::str_sub, start=1, end=n)] %>%
      .[get(xwalk_cols[1]) %in% codes_n] %>%
      .[, .N, by=xwalk_cols]
  }) %>%
    data.table::rbindlist()
  # Warn about any missing codes before returning
  missing_codes = codes[!codes %in% converted[[xwalk_cols[1]]]]
  if(length(missing_codes) > 0){
    warning(
      paste0(
        "The following codes are not present in the NAICS ", xwalk_cols[1],
        "release:", paste(missing_codes, collapse=", ")
      )
    )
  }
  return(converted)
}
