clear all
version 16
cap log c _all
set more off

*set WD
cd "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata"

***INCLUDE PATHS AND GLOBALS
include "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do/paths.do"
*SETUP: COMMENT IN AND RUN TO SSC INSTALL PACKAGES REQUIRED
*run "${do}/setup.do"

**GET DATA FROM WORLD BANK API
run "${do}/data_get.do"

**MERGE DATA
run "${do}/data_merge.do"

**CLEAN DATA
run "${do}/data_cleaning.do"

**PREAPRE DATA FOR DESCRIPTIVE ANALYSIS
run "${do}/data_prep.do"

***PRODUCE GRAPHS FOR CHAPER 1
run "${do}/plots_ch1.do"

**PRODUCE FIGURES FOR CHAPTER 2
run "${do}/plots_ch2.do"

**PRODUCE FIGURES FOR CHAPTER 3
run "${do}/plots_ch3.do"

**PRODUCE FIGURES FOR CHAPTER 4
run "${do}/plots_ch4.do"
