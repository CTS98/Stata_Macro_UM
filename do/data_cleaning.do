***SET WORKING DIRECTORY
cd "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/"

include "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do/paths.do"

use "${apidata}/WBAPI_merged_raw.dta", clear
des
*BEGIN DATA CLEANING

**ORDER VARS LIKE PREVIOUS ANALYSIS STRUCTURE (PER COUNTRY,EXCEL DATA)
order bg_gsr_nfsv_gd_zs - sp_pop_65up_to_zs

order CC Year, first

foreach oldvar of varlist bg_gsr_nfsv_gd_zs - sp_pop_65up_to_zs {
	notes `oldvar' : `oldvar'
}

*Batch rename
rename (bg_gsr_nfsv_gd_zs - sp_pop_65up_to_zs) v#, addnumber

format Year %ty

la val v* .

save "${apidata}/WBAPI_cleaned_renamed.dta", replace




