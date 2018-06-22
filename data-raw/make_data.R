# The packages -----------------------------------------------------------------
library(readxl)   # read_excel()
library(stringr)  # str_trim(), str_to_title()
library(magrittr) # %>%, %<>%
library(mcutils)  # vn2latin(), fix_names()
library(devtools) # use_data()
library(dplyr)    # mutate_all(), funs(), replace()


## Reading the data from file --------------------------------------------------
tbvn_years <- Map(function(x) read_excel("data-raw/TB data.xlsx", x), 1:6)


## the English names of the variables ------------------------------------------
var_names <- c("quarter", "pos_afb_new", "pos_afb_relapse", "pos_afb_fail",
               "pos_afb_retreatment", "pos_afb_other", "neg_afb", "nptb",
               "neg_afb_nptb", "total")


## removes the first 3 rows and rename the columns -----------------------------
clean_df_column <- function(df) {
  df <- df[-c(1:3), ]
  names(df) <- var_names
  df
}


## removes rows with uninteresting information ---------------------------------
clean_remove_dirty_rows <- function(df,word) {
  df <- df[-grep(word, df$quarter), ]
  df[!is.na(df$quarter), ]
}


## removes "_" and trim white spaces -------------------------------------------
clean_trim <- function(df) {
  transform(df, quarter = str_trim(sub("_", "", quarter)))
}


## creates the province column -------------------------------------------------
create_province_column <- function(df) {
  sel <- grep("[0-9]", df$quarter, invert = TRUE)
  province <- rep(df$quarter[sel], each = 4)
  df <- df[-sel, ]
  df$province <- province
  df
}


## the function that puts together the 4 previous ones -------------------------
clean_all <- function(df) {
  df %>%
    clean_df_column %>%
    clean_remove_dirty_rows("Tổn|Total|Tồng|CHƯƠNG|Bộ") %>%
    clean_trim %>%
    create_province_column
}


## Applying the cleaning to the 6 slots ----------------------------------------
tbvn <- Map(clean_all, tbvn_years)


## Creating the "year" variable and putting all the years together -------------
year <- rep(2010:2015, sapply(tbvn, nrow))
tbvn <- do.call(rbind, tbvn)
tbvn$year <- year


## A few quick fixes -----------------------------------------------------------
tbvn[76, "nptb"] <- "42"
tbvn[207, "neg_afb_nptb"] <- "3"
tbvn[232, "neg_afb"] <- "111"


## Fixing decimal problem ------------------------------------------------------
for(i in 1:10) tbvn[, i] <- as.numeric(tbvn[, i])
sel <- tbvn$province == "TP Hồ Chí Minh"
for(i in c("pos_afb_new", "total")) tbvn[sel, i] <- round(1000 * tbvn[sel, i])
for(i in 1:10) tbvn[, i] <- as.integer(tbvn[, i])


## Selecting and reordering the variables --------------------------------------
tbvn <- tbvn[, c("province", "year", "quarter", "nptb", "neg_afb",
                 "neg_afb_nptb", "pos_afb_new", "pos_afb_relapse",
                 "pos_afb_fail", "pos_afb_retreatment", "pos_afb_other")]


## Converting provinces names to basic latin -----------------------------------
tbvn$province <- vn2latin(tbvn$province)


## Changing the names of some provinces ----------------------------------------
tbvn$province <- fix_names(tbvn$province)


## Capitalizing provinces names ------------------------------------------------
tbvn$province <- str_to_title(tbvn$province)


## Removing row numbers --------------------------------------------------------
row.names(tbvn) <- NULL

## Replacing missing values by zeros -------------------------------------------
tbvn %<>% mutate_all(funs(replace(., is.na(.), 0)))

## Saving to disk and cleaning -------------------------------------------------
#use_data(tbvn, overwrite = TRUE)
#rm(list = ls())
