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
local min = `r(min)'
qui sum end
scalar max = `r(max)'
restore

eststo : reg policy_rate infl_dev unemp_dev , r beta
eststo : reg policy_rate infl_dev unemp_dev if Year>=`min', r beta

esttab using "Regressions.html", replace ///
star  label lines ar2 obslast mtitles("Naive" "Rolling Regression") ///
title("Estimated Coefficients of the Taylor Rule") 
eststo clear
	}
}


