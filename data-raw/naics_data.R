library(data.table)
library(magrittr)
library(readxl)
library(stringr)
library(usethis)

# This works for files downloaded from here effective 5/10/2024:
# https://www.census.gov/naics/?68967

# For code tables, follow the "Downloadable Files" link, and download all files
# labeled "2-6 digit {YEAR} Code Files"

# For equivalence tables, follow the "Concordances" link, and download all files
# labeled "{YEAR} NAICS to {YEAR+5} NAICS"

# Download them locally (excels can't be read from web, apparently), then add
# the files paths to the respective list  components. The script will then take
# care of the rest, provided that file formats haven't been changed since
# writing this script.

CODE_TABLES = list(
  "2022" = r"(C:\Users\aaron.weinstock\Downloads\naics_tables\codes\2-6 digit_2022_Codes.xlsx)",
  "2017" = r"(C:\Users\aaron.weinstock\Downloads\naics_tables\codes\2-6 digit_2017_Codes.xlsx)",
  "2012" = r"(C:\Users\aaron.weinstock\Downloads\naics_tables\codes\2-digit_2012_Codes.xls)",
  "2007" = r"(C:\Users\aaron.weinstock\Downloads\naics_tables\codes\naics07.xls)",
  "2002" = r"(C:\Users\aaron.weinstock\Downloads\naics_tables\codes\naics_2_6_02.txt)"
)

EQUIVALENCE_TABLES = list(
  "2017_2022" = r"(C:\Users\aaron.weinstock\Downloads\naics_tables\equivalence\2017_to_2022_NAICS.xlsx)",
  "2012_2017" = r"(C:\Users\aaron.weinstock\Downloads\naics_tables\equivalence\2012_to_2017_NAICS.xlsx)",
  "2007_2012" = r"(C:\Users\aaron.weinstock\Downloads\naics_tables\equivalence\2007_to_2012_NAICS.xls)",
  "2002_2007" = r"(C:\Users\aaron.weinstock\Downloads\naics_tables\equivalence\2002_to_2007_NAICS.xls)",
  "1997_2002" = r"(C:\Users\aaron.weinstock\Downloads\naics_tables\equivalence\1997_NAICS_to_2002_NAICS.xls)"
)

# 2-6 digit code files =========================================================

# 2022
naics_2022 = CODE_TABLES$`2022` %>%
  readxl::read_xlsx() %>%
  .[, c(2,3)] %>%
  data.table::setDT() %>%
  data.table::setnames(
    old = names(.),
    new = c("code","description")
  ) %>%
  .[!is.na(code)]

# 2017
naics_2017 = CODE_TABLES$`2017` %>%
  readxl::read_xlsx() %>%
  .[, c(2,3)] %>%
  data.table::setDT() %>%
  data.table::setnames(
    old = names(.),
    new = c("code","description")
  ) %>%
  .[!is.na(code)]

# 2012
naics_2012 = CODE_TABLES$`2012` %>%
  readxl::read_xls() %>%
  .[, c(2,3)] %>%
  data.table::setDT() %>%
  data.table::setnames(
    old = names(.),
    new = c("code","description")
  ) %>%
  .[!is.na(code)]

# 2007
naics_2007 = CODE_TABLES$`2007` %>%
  readxl::read_xls() %>%
  .[, c(2,3)] %>%
  data.table::setDT() %>%
  data.table::setnames(
    old = names(.),
    new = c("code","description")
  ) %>%
  .[!is.na(code)]

# 2002
naics_2002 = CODE_TABLES$`2002` %>%
  readLines() %>%
  .[5:length(.)] %>%
  data.table::data.table() %>%
  setnames(
    old = names(.),
    new = "line"
  ) %>%
  .[, code := stringr::str_extract(
    string = line,
    pattern = "^[0-9]{2,6}"
  )] %>%
  .[, description := stringr::str_replace_all(
    string = line,
    pattern = "^[0-9]{2,6}\\s{1,}",
    replacement = ""
  )] %>%
  .[, .(code, description)] %>%
  .[!is.na(code)]

# Equivalence tables ===========================================================

# 2017-2022
e2017_2022 = EQUIVALENCE_TABLES$`2017_2022` %>%
  readxl::read_xlsx() %>%
  .[3:nrow(.), c(1,3)] %>%
  data.table::setDT() %>%
  setnames(
    old = names(.),
    new = c("code_2017","code_2022")
  )

# 2012-2017
e2012_2017 = EQUIVALENCE_TABLES$`2012_2017` %>%
  readxl::read_xlsx() %>%
  .[3:nrow(.), c(1,3)] %>%
  data.table::setDT() %>%
  setnames(
    old = names(.),
    new = c("code_2012","code_2017")
  )

# 2007-2012
e2007_2012 = EQUIVALENCE_TABLES$`2007_2012` %>%
  readxl::read_xls() %>%
  .[3:nrow(.), c(1,3)] %>%
  data.table::setDT() %>%
  setnames(
    old = names(.),
    new = c("code_2007","code_2012")
  )

# 2002-2007
e2002_2007 = EQUIVALENCE_TABLES$`2002_2007` %>%
  readxl::read_xls() %>%
  .[3:nrow(.), c(1,3)] %>%
  data.table::setDT() %>%
  setnames(
    old = names(.),
    new = c("code_2002","code_2007")
  )

# 1997-2002
e1997_2002 = EQUIVALENCE_TABLES$`1997_2002` %>%
  readxl::read_xls(
    sheet = "Concordance 23 US NoD"
  ) %>%
  .[, c(1,3)] %>%
  data.table::setDT() %>%
  setnames(
    old = names(.),
    new = c("code_1997","code_2002")
  ) %>%
  .[!is.na(code_1997)] %>%
  .[, lapply(.SD, as.character)]

# Merge up to build complete table
naics_xwalk = e1997_2002 %>%
  data.table::merge.data.table(
    x = .,
    y = e2002_2007,
    by = "code_2002",
    all.x = TRUE,
    all.y = TRUE
  ) %>%
  data.table::merge.data.table(
    x = .,
    y = e2007_2012,
    by = "code_2007",
    all.x = TRUE,
    all.y = TRUE
  ) %>%
  data.table::merge.data.table(
    x = .,
    y = e2012_2017,
    by = "code_2012",
    all.x = TRUE,
    all.y = TRUE
  ) %>%
  data.table::merge.data.table(
    x = .,
    y = e2017_2022,
    by = "code_2017",
    all.x = TRUE,
    all.y = TRUE
  ) %>%
  .[, c(paste0("code_", seq(1997,2022,by=5))), with=FALSE] %>%
  data.table::setkey(NULL)

# Save data objects ============================================================

usethis::use_data(naics_2022)
usethis::use_data(naics_2017)
usethis::use_data(naics_2012)
usethis::use_data(naics_2007)
usethis::use_data(naics_2002)
usethis::use_data(naics_xwalk)

