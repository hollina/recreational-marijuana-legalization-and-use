###################################################################################
# Clear working directory/RAM
rm(list=ls())

###################################################################################
# Load packages
if (!require("pacman")) {
  install.packages("pacman")
}
pacman::p_load(haven)

###################################################################################
# Read in the NSDUH data that came in SAS format
mySASData <- haven::read_sas("raw_data/nsduh/state_saes_final.sas7bdat")

###################################################################################
# Export in stata format 
haven::write_dta(mySASData,"temp/nsduh_panel_1999_2015.dta")
