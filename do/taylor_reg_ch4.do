clear all
qui include "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do/paths.do"
**LOAD DATA INCL FRAMES
run "${do}/setup_ch4.do"

/*
foreach frame in "frame JAPAN"  frame CHILE" {
	
	`frame' {

	cd "${output}/`: var label fr_id '/ch4/"
	
eststo m1: reg policy_rate infl_dev unemp_dev if Year>=1985 & Year <=1995 , r beta 
eststo m2: reg policy_rate infl_dev unemp_dev if Year>=1995 & Year <=2005 , r beta 
eststo m1: reg policy_rate infl_dev unemp_dev if Year>=2005 & Year <=2015 , r beta 


/*
eststo rr

esttab naive rr using "regresults.html", replace
*/
	}
}
*/

frame change JAPAN
rolling _b, window(6): reg policy_rate infl_dev unemp_dev, r beta
ren _b_infl_dev beta_inflation
ren  _b_unemp_dev beta_unemployment
ren _b_cons constant
list
tabout beta_inflation  using RREG_TABEL.html, replace ///
c(freq row col) f(0c 1p 1p) clab(_ _ _) ///  
 layout(rb) h3(nil) 
