clear all
version 16
set more off
cap log close

***SET WORKING DIRECTORY
cd "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata"

qui include "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do/paths.do"

***********************
*APPEND DATASETS 3,7,10
***********************

use "${apidata}/WBAPI_T3_premerge.dta"
merge 1:1 Year CC using "${apidata}/WBAPI_T7_premerge.dta", keep(match) nogen
merge 1:1 Year CC using "${apidata}/WBAPI_T10_premerge.dta", keep(match) nogen
merge 1:1 Year CC using "${apidata}/WBAPI_T13_premerge.dta", keep(match) nogen
merge 1:1 Year CC using "${apidata}/WBAPI_T20_premerge.dta", keep(match) nogen
merge 1:1 Year CC using "${apidata}/WBAPI_POP_premerge.dta", keep(match) nogen
merge 1:1 Year CC using "${apidata}/WBAPI_T12_premerge.dta", keep(match) nogen
merge 1:1 Year CC using "${apidata}/WBAPI_T14_premerge.dta", keep(match) nogen
merge 1:1 Year CC using "${apidata}/WBAPI_T11_premerge.dta", keep(match) nogen

sort CC
save "${apidata}/WBAPI_merged_raw.dta", replace


