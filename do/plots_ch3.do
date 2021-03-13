
include "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do/paths.do"
**LOAD DATA INCL FRAMES
run "${do}/data_prep.do"

frame change CHILE

**************************
*CHAPTER 3 PLOTS & FIGURES
**************************

**R&D/Technology
	qui sum Year, detail
	local grtitle = "Patent Applications"
	tw tsline v732 v733 v73total, ///
	lcolor(`: var label color_2')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) ytitle("") ///
	title(`grtitle', color(black) span) ///
	name(patentapps, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(3))  
	
**Metals and Manufacturing
	qui sum Year, detail
	local grtitle = "Metals and Manufacturing"
	tw tsline v708 v709  , ///
	lcolor(`: var label color_5')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) ytitle("") ///
	title(`grtitle', color(black) span) ///
	name(metalsandmanuf, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(4))  
	
**Government Debt, relative values v124 v125 v127
	qui sum Year, detail
	local grtitle = "Government Debt Dynamics"
	tw tsline v484 v483 v456 v66 v482alt, ///
	lcolor(`: var label color_5')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) ytitle("") ///
	title(`grtitle', color(black) span) ///
	yline(0, lcolor(gs10%85)) ///
	name(debtdyn, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(5))  
	
**GOV INTEREST PAYMENTS
	qui sum Year, detail
	local grtitle = "Interest Payments"
	tw tsline v482t v195t, ///
	lcolor(`: var label color_2')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) ytitle("") ///
	title(`grtitle', color(black) span) ///
	yline(0, lcolor(gs10%85)) ///
	name(interest, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(2))  
	
*v456
** SAVINGS
*v231 
/*IDEAS

from syllabus: In weeks 5 and 6, we discuss the long run and policy issues, including fiscal policy. Again, we focus on the changes in your country throughout the time period you are analyzing. 
This time (in the third chapter), we look at government debt and its dynamics. Has debt gone up or down? What about the different components of government debt? Now compare this debt dynamics to the long-run growth of the economy. Remember from last week you can look at specific factors that may lead to higher long run growth. Compare the long run growth with what you found as government debt dynamics. Make an inference on the risk of your country based on this, as well as on the effect of the interest rate

central gov debt: v64, PV of current external debt: v53-55 short-term debt: v51
general gov final consumption expenditure: v67-v72
claims on central gov: v264, v280

maybe interesting: v423, v294

*/


/*
foreach frame in "frame JAPAN" "frame CHILE" {
	
	`frame' {
*/
	cd "${output}/`: var label fr_id '/ch3/"
		
	**POPULATION
	qui levelsof RecYear, local(RY)
	qui sum Year, detail
	local grtitle = "Population Growth"
	tw tsline v567 v573 v574, ///
	lcolor(`: var label color_2')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) ytitle("") ///
	title(`grtitle', color(black) span) ///
	name(popgrowth, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(3)) ///
	xline(`RY' , lcolor(gs10%85)) ///
	yline(0, lcolor(gs10%85) nodraw
	
	
	qui levelsof RecYear, local(RY)
	qui sum Year, detail
	local grtitle = "Population Composition"
	tw tsline v576 v572 v570, ///
	lcolor(`: var label color_2') lpattern(solid dash) ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) ytitle("") ///
	title(`grtitle', color(black) span) ///
	name(popcomp, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(3)) ///
	xline(`RY' , lcolor(gs9%85))  nodraw
	
	gr combine popgrowth popcomp, ///
	rows(2) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) name(labor_infl, replace) ///
	xsize(7) scale(0.8) ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank)) xcommon note("vertical lines mark recession years" "${datasource}")
	
	gr export "Population Growth and Composition.png", replace


	
/*
gr drop _all
		
	}
}

