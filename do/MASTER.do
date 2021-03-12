clear all
version 16
cap log c _all
set more off

*set WD
cd "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata"

***INCLUDE PATHS AND GLOBALS
include "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do/paths.do"
*SETUP
run "${do}/setup.do"

**GET DATA FROM WORLD BANK API
run "${do}/data_get.do"

**MERGE DATA
run "${do}/data_merge.do"

**CLEAN DATA
run "${do}/data_cleaning.do"

**PREAPRE DATA FOR DESCRIPTIVE ANALYSIS
run "${do}/data_prep.do"

**PRODUCE BASIC PLOTS FOR ALL VARS
run "${do}/plots_basic.do"

***PRODUCE GRAPHS FOR CHAPER 1
run "${do}/plots_ch1.do"

**PRODUCE FIGURES FOR CHAPTER 2
run "${do}/plots_ch2.do"
