clear all
version 16
set more off
cap log close

***SET WORKING DIRECTORY
cd "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata"

qui include "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do/paths.do"

***********************
*APPEND DATASETS 13,20
***********************

use "${apidata}/WBAPI_cleaned_renamed.dta", clear
merge 1:1 Year CC using "${apidata}/WBAPI_T13_premerge.dta", keep(match) nogen
merge 1:1 Year CC using "${apidata}/WBAPI_T20_premerge.dta", keep(match) nogen

sort CC
save "${apidata}/WBAPI_merged_raw_updated.dta", replace

foreach oldvar of varlist gc_ast_totl_cn - ny_gnp {
	notes `oldvar' : `oldvar'
}

rename (gc_ast_totl_cn - ny_gnp) v#, addnumber(448)

format Year %ty

la val v* .
des
save "${apidata}/WBAPI_updated_cleaned_renamed.dta", replace
