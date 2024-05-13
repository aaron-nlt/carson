# NAICS tables =================================================================

#' NAICS 2022 2-6 digit codes
#'
#' 2-6 digit industry codes and descriptions for NAICS 2022.
#'
#' @format ## `naics_2022`
#' A data frame with 2,125 rows and 2 columns:
#' \describe{
#'   \item{code}{2-6 digit 2022 NAICS code}
#'   \item{description}{Description of the industry}
#'   ...
#' }
#' @source <https://www.census.gov/naics/2022NAICS/2-6%20digit_2022_Codes.xlsx>
"naics_2022"

#' NAICS 2017 2-6 digit codes
#'
#' 2-6 digit industry codes and descriptions for NAICS 2017.
#'
#' @format ## `naics_2017`
#' A data frame with 2,196 rows and 2 columns:
#' \describe{
#'   \item{code}{2-6 digit 2017 NAICS code}
#'   \item{description}{Description of the industry}
#'   ...
#' }
#' @source <https://www.census.gov/naics/2017NAICS/2-6%20digit_2017_Codes.xlsx>
"naics_2017"

#' NAICS 2012 2-6 digit codes
#'
#' 2-6 digit industry codes and descriptions for NAICS 2012.
#'
#' @format ## `naics_2012`
#' A data frame with 2,209 rows and 2 columns:
#' \describe{
#'   \item{code}{2-6 digit 2012 NAICS code}
#'   \item{description}{Description of the industry}
#'   ...
#' }
#' @source <https://www.census.gov/naics/2012NAICS/2-digit_2012_Codes.xls>
"naics_2012"

#' NAICS 2007 2-6 digit codes
#'
#' 2-6 digit industry codes and descriptions for NAICS 2007.
#'
#' @format ## `naics_2007`
#' A data frame with 2,328 rows and 2 columns:
#' \describe{
#'   \item{code}{2-6 digit 2007 NAICS code}
#'   \item{description}{Description of the industry}
#'   ...
#' }
#' @source <https://www.census.gov/naics/reference_files_tools/2007/naics07.xls>
"naics_2007"

#' NAICS 2002 2-6 digit codes
#'
#' 2-6 digit industry codes and descriptions for NAICS 2002.
#'
#' @format ## `naics_2002`
#' A data frame with 2,341 rows and 2 columns:
#' \describe{
#'   \item{code}{2-6 digit 2002 NAICS code}
#'   \item{description}{Description of the industry}
#'   ...
#' }
#' @source <https://www.census.gov/naics/reference_files_tools/2002/naics_2_6_02.txt>
"naics_2002"

#' NAICS 1997-2022 6-digit code crosswalk
#'
#' Full crosswalk for 6-digit codes for all NAICS releases.
#'
#' @format ## `naics_xwalk`
#' A data frame with 1,615 rows and 6 columns:
#' \describe{
#'   \item{code_YYYY}{6-digit NAICS code in year YYYY}
#'   ...
#' }
#' @source Concordance tables available at <https://www.census.gov/naics/?48967>
"naics_xwalk"

# SOC tables ===================================================================

#' SOC 2018 codes
#'
#' Occupation codes and definitions for SOC 2018.
#'
#' @format ## `soc_2018`
#' A data frame with 1,447 rows and 4 columns:
#' \describe{
#'   \item{group}{Level of occupation (major, minor, broad, detailed)}
#'   \item{code}{2018 SOC code}
#'   \item{title}{Name of the occupation}
#'   \item{definition}{Description of the occupation}
#'   ...
#' }
#' @source <https://www.bls.gov/soc/2018/soc_2018_definitions.xlsx>
"soc_2018"

#' SOC 2010 codes
#'
#' Occupation codes and definitions for SOC 2010.
#'
#' @format ## `soc_2010`
#' A data frame with 840 rows and 3 columns:
#' \describe{
#'   \item{code}{2010 SOC code}
#'   \item{title}{Name of the occupation}
#'   \item{definition}{Description of the occupation}
#'   ...
#' }
#' @source <https://www.bls.gov/soc/soc_2010_definitions.xls>
"soc_2010"

#' SOC 2000 codes
#'
#' Occupation codes and definitions for SOC 2000.
#'
#' @format ## `soc_2000`
#' A data frame with 821 rows and 3 columns:
#' \describe{
#'   \item{code}{2000 SOC code}
#'   \item{title}{Name of the occupation}
#'   \item{definition}{Description of the occupation}
#'   ...
#' }
#' @source <https://www.bls.gov/soc/2000/soc-definitions-2000.xlsx>
"soc_2000"

#' SOC 2000-2018 code crosswalk
#'
#' Full crosswalk for codes for all SOC releases.
#'
#' @format ## `soc_xwalk`
#' A data frame with 920 rows and 3 columns:
#' \describe{
#'   \item{code_YYYY}{SOC code in year YYYY}
#'   ...
#' }
#' @source Crosswalk tables available at <https://www.bls.gov/soc>
"soc_xwalk"


