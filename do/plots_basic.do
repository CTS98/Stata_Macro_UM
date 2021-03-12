cd "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/"

include "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do/paths.do"

*LOAD DATA
use "${data}/data_prepared.dta", clear

**********************
*BASIC PLOTS
**********************

frame JAPAN {
	
		foreach v of varlist v* {
		qui sum Year
		clonevar `v'temp = `v'
		labvarch `v'temp, before(" (")
		tw tsline `v', ///
		lcolor(`: var label color_1') ${grs} ///
		ylabel(#5, nogrid angle(0) format(%20.0gc)) ytitle("") ///
		title("`: var label `v'temp'", color(black) span) ///
		name(`v', replace) ///
		tlabel(`r(min)'(5)`r(max)', angle(0) nogex ) nodraw ///
		note("`: var label `v''") graphregion(margin(tiny))
		
		gr save "${output}/`: var label fr_id '/basicplots/`v'", replace
		drop `v'temp
		
		}
		
}

frame CHILE {
	
		foreach v of varlist v* {
		qui sum Year
		clonevar `v'temp = `v'
		labvarch `v'temp, before(" (")
		tw tsline `v', ///
		lcolor(`: var label color_1') ${grs} ///
		ylabel(#5, nogrid angle(0) format(%20.0gc)) ytitle("") ///
		title("`: var label `v'temp'", color(black) span) ///
		name(`v', replace) ///
		tlabel(`r(min)'(5)`r(max)', angle(0) nogex ) nodraw ///
		note("`: var label `v''") graphregion(margin(tiny))
		
		gr save "${output}/`: var label fr_id '/basicplots/`v'", replace
		drop `v'temp
		}
	
}

