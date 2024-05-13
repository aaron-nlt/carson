library(data.table)
library(magrittr)
library(stringr)

#' Convert SOC codes between years/releases
#'
#' @details
#' This function matches SOC codes in a "from_year" to corresponding codes in a
#' "to_year". The from and to years are matched to releases of SIC based on the
#' most current NAICS release during each year. New SOC have been published
#' published in 2000, 2010, and 2018, so setting from_year = 2005 and
#' to_year = 2015 will, for example, convert 2000 SOC to 2010 SOC. All codes to
#' convert must be present in the SOC release corresponding to the from year.
#' Any codes that are not found in the from-year release will be identified in a
#' warning before return.
#'
#' Note that you may search by higher levels of aggregation in the SOC codes by
#' entering codes with the appropriate number of trailing 0s (e.g. "11-0000"
#' for all management occupations in 2018).
#'
#' @param codes A character vector of SOC codes to be converted. All codes must
#' be valid SOC codes (format DD-DDDD) present in the release corresponding to
#' `from_year` (see below).
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
#' * "N": the number of SOC codes that fall under the umbrella of the match.
#' This can be used to make a rough estimate of how often the conversion
#' manifests. This is especially useful when one "code_\{from\}" matches to
#' multiple entries in "code_\{to\}".
#'
#' @export
#'
#' @examples
#' # Convert 3 codes from 2002 to 2022
#' convert_soc(c("11-0000","25-9041"), 2010, 2018)
#' # Because of release schedule, the following is equivalent to the above
#' convert_soc(c("11-0000","25-9041"), 2014, 2024)
convert_soc = function(codes, from_year, to_year){
  # Check format of code: must be 6 digits with a hyphen after 2
  codes = unique(codes)
  if(!all(stringr::str_detect(codes, "^[0-9]{2}-[0-9]{4}$"))){
    stop(
      "all `codes` must be formatted as DD-DDDD"
    )
  }
  # Check the from/to years: must be >2000, <current year
  cy = as.integer(format(Sys.Date(), "%Y"))
  if(from_year < 2000 | from_year > cy){
    stop(
      "`from_year` must be between 2000 (release of SOC) and the current year"
    )
  }
  if(to_year < 2000 | from_year > cy){
    stop(
      "`to_year` must be between 2000 (release of SOC) and the current year"
    )
  }
  # Round off years for conversion. Throw an error if they map to the same year
  releases = c(2000, 2010, 2018)
  xwalk_cols = c(
    releases[max(which(from_year >= releases))],
    releases[max(which(to_year >= releases))]
  ) %>%
    paste0("code_", .)
  if(xwalk_cols[1] == xwalk_cols[2]){
    stop(
      paste0(
        from_year, " and ", to_year, "correspond to the same SOC release"
      )
    )
  }
  # Convert by looping over codes with the same number of digits. The
  # "conversion" is a simple identification of unique rows in the xwalk.
  nz = stringr::str_extract(
    string = codes,
    pattern = "-?0+$"
  ) %>%
    nchar()
  nz[is.na(nz)] = 0
  nd = nchar(codes) - nz
  xwalk = soc_xwalk %>%
    data.table::setDT() %>%
    .[, xwalk_cols, with=FALSE]
  converted = lapply(unique(nd), function(n){
    codes_n = codes[nd == n]
    fill = ifelse(
      test = n == 2,
      yes = "-0000",
      no = paste(rep("0", 7-n), collapse="")
    )
    xwalk %>%
      data.table::copy() %>%
      .[, lapply(.SD, function(x){
        stringr::str_sub(
          string = x,
          start = 1,
          end = n
        ) %>%
          paste0(., fill)
      })] %>%
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
