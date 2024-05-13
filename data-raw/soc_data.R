library(data.table)
library(magrittr)
library(readxl)
library(stringr)
library(usethis)

# This works for files downloaded from here effective 5/13/2024
# https://www.bls.gov/soc/

# For code tables, follow the link for each SOC release, and download
# the "SOC Definitions" excel file.

# For the equivalence tables, follow the link for each SOC release, then
# follow the crosswalks link, and download the "Crosswalk" excel file. The
# 2010-2018 xwalk is under the 2018 release, and the 2010-2000 xwalk is under
# the 2010 release.

# Download them locally (excels can't be read from web, apparently), then add
# the files paths to the respective list  components. The script will then take
# care of the rest, provided that file formats haven't been changed since
# writing this script.

CODE_TABLES = list(
  "2018" = r"(C:\Users\aaron.weinstock\Downloads\soc_tables\codes\soc_2018_definitions.xlsx)",
  "2010" = r"(C:\Users\aaron.weinstock\Downloads\soc_tables\codes\soc_2010_definitions.xls)",
  "2000" = r"(C:\Users\aaron.weinstock\Downloads\soc_tables\codes\soc-definitions-2000.xlsx)"
)

EQUIVALENCE_TABLES = list(
  "2010_2018" = r"(C:\Users\aaron.weinstock\Downloads\soc_tables\equivalence\soc_2010_to_2018_crosswalk.xlsx)",
  "2000_2010" = r"(C:\Users\aaron.weinstock\Downloads\soc_tables\equivalence\soc_2000_to_2010_crosswalk.xls)"
)

# Code files ===================================================================

# 2018
soc_2018 = CODE_TABLES$`2018` %>%
  readxl::read_xlsx() %>%
  data.table::setDT() %>%
  .[8:nrow(.),] %>%
  data.table::setnames(
    old = names(.),
    new = c("group","code","title","definition")
  )

# 2010
soc_2010 = CODE_TABLES$`2010` %>%
  readxl::read_xls() %>%
  data.table::setDT() %>%
  .[7:nrow(.),] %>%
  data.table::setnames(
    old = names(.),
    new = c("code","title","definition")
  )

# 2000
soc_2000 = CODE_TABLES$`2000` %>%
  readxl::read_xlsx() %>%
  data.table::setDT() %>%
  .[7:nrow(.),] %>%
  data.table::setnames(
    old = names(.),
    new = c("code","title","definition")
  )

# Equivalence tables ===========================================================

# 2010-2018
e2010_2018 = EQUIVALENCE_TABLES$`2010_2018` %>%
  readxl::read_xlsx() %>%
  data.table::setDT() %>%
  .[9:nrow(.), c(1,3)] %>%
  data.table::setnames(
    old = names(.),
    new = c("code_2010","code_2018")
  )

# 2000-2010
e2000_2010 = EQUIVALENCE_TABLES$`2000_2010` %>%
  readxl::read_xls() %>%
  data.table::setDT() %>%
  .[8:nrow(.), c(1,3)] %>%
  data.table::setnames(
    old = names(.),
    new = c("code_2000","code_2010")
  )

# Merge up to build complete table
soc_xwalk = e2000_2010 %>%
  data.table::merge.data.table(
    x = .,
    y = e2010_2018,
    all.x = TRUE,
    all.y = TRUE,
    by = "code_2010"
  ) %>%
  .[, .(code_2000, code_2010, code_2018)] %>%
  data.table::setkey(NULL)

# Save data objects ============================================================

usethis::use_data(soc_2018)
usethis::use_data(soc_2010)
usethis::use_data(soc_2000)
usethis::use_data(soc_xwalk)
