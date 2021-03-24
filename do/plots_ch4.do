clear all
qui include "/Users/ts/Git/Stata_Macro_UM/do/paths.do"
**LOAD DATA INCL FRAMES
run "${do}/setup_ch4.do"

**************************
*CHAPTER 4 PLOTS & FIGURES
**************************

/*IDEAS

from syllabus: 
In the first part (which is the relatively longer of the two), you will study the monetary policy of your country. When you think of your country’s monetary policy, the Taylor rule is a standard way to describe the priorities of the Central Bank. Do your best to estimate it, and in any case be sure to add your own description of what your analysis means in terms of the monetary policy practice within the country. The information you use in this part may well build on your past chapters, when you find them useful (for example with the medium run target values of unemployment and inflation).

*/

graph set window fontface default

foreach frame in  "JAPAN" "CHILE" {
	
	frame change `frame' 

	cd "${output}/`: var label fr_id '/ch4/"
	
	if CC=="CHL" {
		graph set window fontface "Times New Roman"
		
	} 

***PLOT	
	qui levelsof RecYear, local(RY)
	qui sum Year
	local grtitle = "Filtered trends"
	tw tsline interest_trend unemp_trend gdp_trend infl_trend, nodraw ///
	lpattern(longdash solid dash solid) ///
	lcolor(`: var label color_5')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%4.1fc)) xtitle("") ///
	ytitle("%", orientation(horizontal)) ///
	title(`grtitle', color(black) span) ///
	name(trendcomps, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(cols(4) ) ///
	xline(`RY' , lcolor(gs10%85)) ///
	yline(0, lcolor(gs10%85))
	 
	
	qui levelsof RecYear, local(RY)
	qui sum Year
	local grtitle = "Cyclical Components / Deviations from trends"
	tw tsline interest_cyc unemp_cyc gdp_cyc infl_cyc , nodraw ///
	lpattern(longdash solid dash solid) ///
	lcolor(`: var label color_5')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%4.1fc)) xtitle("") ///
	ytitle("%", orientation(horizontal)) ///
	title(`grtitle', color(black) span) ///
	name(cyccomps, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(cols(4) ) ///
	xline(`RY' , lcolor(gs10%85)) ///
	yline(0, lcolor(gs10%85)) 
	
	
	gr combine trendcomps cyccomps  , ///
	rows(2) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) ///
	name(trendpanels, replace) ///
	xsize(7) scale(0.8) xcommon ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank))  ///
	note("vertical lines mark recession years" "${datasource}")
	
	gr export "HP Trends double panel.png", replace
	gr close
	
	gr combine trendcomps  cyccomps , ///
	rows(3) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox)  name(trendpanelsslim, replace) ///
	xsize(7) scale(0.8) xcommon ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank))  note("Trends are estimated using a Hodrick-Prescott Filter (cf. Wooldridge, 2020)")
	gr close
	

		
	qui levelsof RecYear, local(RY)
	qui sum Year if taylor_93_0!=. 
	local grtitle = "Taylor 1993"
	tw (tsline taylor_93_0  taylor_93_2 taylor_93_1 policy_rate ///
	if taylor_93_0!=., nodraw ///
	lcolor(`: var label color_2' gs10%80 purple%90)  ${grs} ///
	lpattern(solid solid dash longdash) ///
	ylabel(#5, nogrid angle(0) format(%4.1fc)) xtitle("") ///
	ytitle("%", orientation(horizontal)) ///
	title(`grtitle', color(black) span) ///
	name(taylor93_area, replace) ///
	saving("T93area.gph", replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(5) order (3 2 1 4 5) label(5 "Policy Rate Corridor") ///
	label(4 "Actual Policy Rate")) ///
	xline(`RY' , lcolor(gs10%85)) ) ///
	(rarea taylor_93_0 taylor_93_2 Year if taylor_93_0!=., sort ///
	color(gs10%80) fcolor(gs11%60) )
	
	gr save "T93area.gph", replace
if CC=="CHL" {
	qui levelsof RecYear, local(RY)
	qui sum Year if taylor_93_0!=. 
	local grtitle = "Taylor 1993"
	tw (tsline taylor_93_0  taylor_93_5 taylor_93_2  ///
	policy_rate if taylor_93_0!=., nodraw ///
	lcolor(`: var label color_2' gs10%80 purple%90)  ${grs} ///
	lpattern(solid solid dash dash longdash) ///
	ylabel(#5, nogrid angle(0) format(%4.1fc)) xtitle("") ///
	ytitle("%", orientation(horizontal)) ///
	title(`grtitle', color(black) span) ///
	name(taylor93_area, replace) ///
	saving("T93area.gph", replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(5) order (4 2 3 1 5) label(5 "Policy Rate Corridor") ///
	label(4 "Actual Policy Rate")) ///
	xline(`RY' , lcolor(gs10%85)) ) ///
	(rarea taylor_93_0 taylor_93_5 Year if taylor_93_0!=., sort ///
	color(gs10%80) fcolor(gs11%60) )
	
	gr save "T93area.gph", replace
}
	
	*****************
	*MONEY TARGETING
	*****************
	qui levelsof RecYear, local(RY)
	qui sum Year if taylor_93_0!=.
	local grtitle = "Money Supply"
	tw tsline v272 v288 policy_rate if v288!=. , nodraw  ///
	lcolor(`: var label color_2'  purple%90)  ${grs} ///
	lpattern(solid dash longdash) ///
	ylabel(#5, nogrid angle(0) format(%4.1fc)) xtitle("") ///
	ytitle("%", orientation(horizontal)) ///
	title(`grtitle', color(black) span) ///
	name(moneytarg, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(2) ) ///
	xline(`RY' , lcolor(gs10%85)) ///
	yline(0, lcolor(gs10%85)) 
	
	********
	*COMBINE
	********
	gr combine moneytarg "T93area.gph", ///
	cols(2) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) name(targeting, replace) ///
	xsize(7) scale(0.8)  ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank))  ///
	note("vertical lines mark recession years" "${datasource2}")
	
	gr export "Money and Inflation Targeting.png", replace
	gr close
	
	gr combine trendpanelsslim moneytarg "T93area.gph", ///
	rows(5) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) name(mega, replace) ///
	xsize(10) ysize(14) scale(0.8)  ///
	imargin(zero) ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank))  ///
	note("vertical lines mark recession years; functional form of Taylor Rule adopted from Taylor (1993)" ///
	"Trends are estimated using a Hodrick-Prescott Filter (cf. Wooldridge, 2020)" "${datasource2}")
	
	gr export "Mega Graph.png", replace
	gr close
	
*****************************
**TR WITH ESTIMATED >0 COEFFS
*****************************
	
preserve
rolling _b, window(6): reg policy_rate infl_dev unemp_dev, r beta
keep if _b_infl_dev>0 & _b_unemp_dev>0 & _b_infl_dev!=.
list
qui sum start
local trmin = `r(min)'

restore

if CC!="CHL" {
preserve
rolling _b, window(6): reg policy_rate gdp_dev infl_dev , r beta
keep if _b_infl_dev>0 & _b_gdp_dev>0 & _b_infl_dev!=.
list
qui sum start
local t93min = `r(min)'

restore
}



eststo : reg policy_rate infl_dev gdp_dev, r beta
eststo : reg policy_rate infl_dev gdp_dev if Year>=`t93min', r beta
eststo : reg policy_rate infl_dev unemp_dev , r beta
eststo : reg policy_rate infl_dev unemp_dev if Year>=`trmin', r beta

esttab using "Regressions.html", replace ///
star  label wide lines ar2 obslast mtitles("Taylor 93, Naive" ///
"Taylor 93, Rolling" ///
"Taylor Rule, Naive" ///
"Taylor Rule, Rolling" span) ///
title("Estimated Coefficients of the Taylor Rule") ///
addnotes("Naive refers to Regressions over the entire period" ///
"Rolling refers to a two-stage estimation process that estimates coefficients over rolling 5-year intervals and keeps only years with positive coefficients" ///
"Heteroskedasticity-robust std. errors used across all models" ///
"Standardized beta coefficients reported to facilitate cross-model comparisons")
eststo clear


if CC=="CHL" {
eststo : reg policy_rate infl_dev gdp_dev, r beta

eststo : reg policy_rate infl_dev unemp_dev , r beta
eststo : reg policy_rate infl_dev unemp_dev if Year>=`trmin', r beta

esttab using "Regressions.html", replace ///
star  label wide lines ar2 obslast mtitles("Taylor 93, Naive" ///
"Taylor Rule, Naive" ///
"Taylor Rule, Rolling" span) ///
title("Estimated Coefficients of the Taylor Rule") ///
addnotes("Naive Regressions have the entire period as their sample" ///
"Rolling regressions first estimate coefficients over successive 5-year-periods and then discard years in which both coefficients are not positive" ///
"Standardized beta coefficients reported")
eststo clear
}
qui reg policy_rate infl_dev unemp_dev if Year>=`trmin', r beta


gen taylor_est_2 = 2+ _b[_cons] + _b[infl_dev]*infl_dev + ///
_b[unemp_dev]*(v288-2) //TARGET=2%
gen taylor_est_0 = _b[_cons] + _b[infl_dev]*infl_dev + ///
_b[unemp_dev]*(v288-0) //TARGET=0%
gen taylor_est_1 = _b[_cons] + _b[infl_dev]*infl_dev + ///
_b[unemp_dev]*(v288-1) +1 //TARGET=1%

la var taylor_est_2 "Policy rate according to the estimated Taylor Rule, Target 2% "
la var taylor_est_0 "Policy rate according to the estimated Taylor Rule, Target 0% "
la var taylor_est_1 "Policy rate according to the estimated Taylor Rule, Target 1% "

	local beta1hat : di %3.2f _b[infl_dev]
	local beta2hat : di %3.2f _b[unemp_dev]
	
	qui levelsof RecYear, local(RY)
	qui sum Year if taylor_93_0!=.
	local grtitle = "Estimated Taylor Rule"
	tw (tsline taylor_est_2  taylor_est_0 taylor_est_1 policy_rate ///
	if taylor_93_0!=., nodraw ///
	lcolor(`: var label color_2' gs12%85 purple%90)  ${grs} ///
	lpattern(solid solid dash longdash) ///
	ylabel(#5, nogrid angle(0) format(%4.1fc)) xtitle("") ///
	ytitle("%", orientation(horizontal)) ///
	title(`grtitle', color(black) span) ///
	name(taylor_area, replace) ///
	saving("Taylorarea.gph", replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(6) order(4 1  2 5) ///
	label(5 "Policy rate corridor (Target 0,1,2 %)") ///
	label(4 "Actual Policy Rate")) ///
	xline(`RY' , lcolor(gs10%85)) yline(0, lcolor(gs10%85)) ///
	note("Estimated Taylor Rule Coefficients are `beta1hat' for inflation, `beta2hat' for unemployment", span size(*1.5))) ///
	(rarea taylor_est_0 taylor_est_2 Year if taylor_est_0!=., sort ///
	color(gs10%80) fcolor(gs11%60) ) 
	

*********************
*COMBINE TAYLOR RULES
*********************


	gr combine "T93area.gph" taylor_area, ///
	cols(2) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) name(taylorcomp, replace) ///
	xsize(7) scale(0.8)  ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank))  ///
	note("vertical lines mark recession years, ${datasource2}")
	
	gr export "Taylor Comp.png", replace
	gr close


	gr combine trendpanelsslim  taylorcomp, ///
	rows(2) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox)  name(mega2, replace) ///
	xsize(7) scale(0.8)  ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank)) 
	
	gr export "Mega Graph 2.png", replace 
	gr close
	

****************
*MONEYBASE/IR/FX policy_rate v271_pc v272 v278 v291
****************

	

	qui levelsof RecYear, local(RY)
	qui sum Year
	local grtitle = "Broad Money"
	tw tsline  v272 v271_pc , nodraw ///
	lpattern(longdash solid dash solid) ///
	lcolor(`: var label color_2' `: var label color_scat')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%4.1fc)) xtitle("") ///
	ytitle("%", orientation(horizontal)) ///
	title("`grtitle'", color(black) span) ///
	name(broadmoney, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(2) ) ///
	xline(`RY' , lcolor(gs10%85)) ///
	yline(0, lcolor(gs10%85))
	
	qui levelsof RecYear, local(RY)
	qui sum Year
	local grtitle = "Interest Rates"
	tw tsline policy_rate v278 v277, nodraw ///
	lpattern(longdash solid dash solid) ///
	lcolor(`: var label color_2' `: var label color_scat')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%4.1fc)) xtitle("") ///
	ytitle("%", orientation(horizontal)) ///
	title("`grtitle'", color(black) span) ///
	name(rates, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(2) ) ///
	xline(`RY' , lcolor(gs10%85)) ///
	yline(0, lcolor(gs10%85))
	
	qui levelsof RecYear, local(RY)
	qui sum Year
	local grtitle = "Exchange Rate and capital flows"
	tw tsline  v291_pc v17 v13 , nodraw ///
	lpattern(longdash solid dash solid) ///
	lcolor(`: var label color_2' `: var label color_scat')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%4.1fc)) xtitle("") ///
	ytitle("%", orientation(horizontal)) ///
	title("`grtitle'", color(black) span) ///
	name(fx, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(2) symxsize(2.8pt)) ///
	xline(`RY' , lcolor(gs10%85)) ///
	yline(0, lcolor(gs10%85))
	
	********
	*COMBINE
	********
	
	gr combine fx rates  broadmoney, ///
	rows(3) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox)  name(moneyratesfx, replace) ///
	xsize(7) ysize(10) scale(0.8)  xcommon ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank))  ///
	note("vertical lines mark recession years "${datasource2}")
	
	gr export "money rates fx.png", replace
	gr close
	
	gr drop _all
	
******DELETE GPH GRAPHS
erase T93area.gph
erase Taylorarea.gph
	
	save "${data}/`: var label fr_id '_FINAL.dta", replace
	}


