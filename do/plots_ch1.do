cd "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/"

qui include "/Users/ts/Git/Stata_Macro_UM/do/paths.do"

*LOAD DATA
use "${data}/data_prepared.dta", clear

**********************
*PLOTS FOR CHAPTER 1
**********************

frame JAPAN {	local grtitle = "Real and Nominal GDP in Trillions"
	tw tsline v195t v199t, ///
	lcolor(red blue) color(black) ///
	graphregion(fcolor(white)) bgcolor(white) ///
	plotregion(fcolor(white)) ///
	ylabel(, nogrid angle(0) format(%16.0f)) ytitle("") ///
	title("`grtitle'", color(black) span) ///
	legend(rows(2)) ///
	nodraw name(v195t_v199t, replace)
	
	gr save "${output}/`: variable label fr_id '/ch1/`grtitle'",  replace
	
}
