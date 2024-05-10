library(data.table)
library(magrittr)
library(readxl)

CODE_TABLES = list(
  "2022" = r"(C:\Users\aaron.weinstock\Downloads\naics_tables\codes\2-6 digit_2022_Codes.xlsx)",
  "2017" = r"(C:\Users\aaron.weinstock\Downloads\naics_tables\codes\2-6 digit_2017_Codes.xlsx)",
  "2012" = r"(C:\Users\aaron.weinstock\Downloads\naics_tables\codes\2-digit_2012_Codes.xls)",
  "2007" = r"(C:\Users\aaron.weinstock\Downloads\naics_tables\codes\naics07.xls)",
  "2002" = r"(C:\Users\aaron.weinstock\Downloads\naics_tables\codes\naics_2_6_02.txt)"
)

EQUIVALENCE_TABLES = list(

)

# 2-6 digit code files =========================================================

# 2022
nc2022 = CODE_TABLES$`2022` %>%
  readxl::read_xlsx() %>%
  .[, c(2,3)] %>%
  data.table::setDT() %>%
  data.table::setnames(
    old = names(.),
    new = c("code","description")
  ) %>%
  .[!is.na(code)]

# 2017
nc2017 = CODE_TABLES$`2017` %>%
  readxl::read_xlsx() %>%
  .[, c(2,3)] %>%
  data.table::setDT() %>%
  data.table::setnames(
    old = names(.),
    new = c("code","description")
  ) %>%
  .[!is.na(code)]

# 2012
nc2012 = CODE_TABLES$`2012` %>%
  readxl::read_xls() %>%
  .[, c(2,3)] %>%
  data.table::setDT() %>%
  data.table::setnames(
    old = names(.),
    new = c("code","description")
  ) %>%
  .[!is.na(code)]

# 2007
nc2007 = CODE_TABLES$`2007` %>%
  readxl::read_xls() %>%
  .[, c(2,3)] %>%
  data.table::setDT() %>%
  data.table::setnames(
    old = names(.),
    new = c("code","description")
  ) %>%
  .[!is.na(code)]

# 2002
nc2002 = CODE_TABLES$`2002` %>%
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
