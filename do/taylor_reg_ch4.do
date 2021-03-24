clear all
qui include "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do/paths.do"
**LOAD DATA INCL FRAMES
run "${do}/setup_ch4.do"


foreach frame in "frame JAPAN"  "frame CHILE" {
	
	`frame' {

	cd "${output}/`: var label fr_id '/ch4/"
	
preserve
rolling _b, window(6): reg policy_rate infl_dev unemp_dev, r beta
keep if _b_infl_dev>0 & _b_unemp_dev>0 & _b_infl_dev!=.
list
qui sum start
global t93min = `r(min)'

restore

preserve
rolling _b, window(6): reg policy_rate gdp_dev infl_dev, r beta
keep if _b_infl_dev>0 & _b_gdp_dev>0 & _b_infl_dev!=.
list
qui sum start
global trmin = `r(min)'

restore

eststo : reg policy_rate infl_dev gdp_dev, r beta
eststo : reg policy_rate infl_dev gdp_dev if Year>=${t93min}, r beta
eststo : reg policy_rate infl_dev unemp_dev , r beta
eststo : reg policy_rate infl_dev unemp_dev if Year>=${trmin}, r beta

esttab using "Regressions.html", replace ///
star  label wide lines ar2 obslast mtitles("Taylor 93, Naive" ///
"Taylor 93, Rolling" ///
"Taylor Rule, Naive" ///
"Taylor Rule, Rolling" span) ///
title("Estimated Coefficients of the Taylor Rule") ///
addnotes("Naive refers to Regressions over the entire period" ///
"Rolling refers to a two-stage estimation process that estimates coefficients over rolling 5-year intervals and keeps only years with positive coefficients" //
"Heteroskedasticity-robust std. errors used across all models" ///
"Standardized beta coefficients reported to facilitate cross-model comparisons")
eststo clear
	}
}


