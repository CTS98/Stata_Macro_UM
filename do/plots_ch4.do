clear all
qui include "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do/paths.do"
**LOAD DATA INCL FRAMES


**************************
*CHAPTER 4 PLOTS & FIGURES
**************************

/*IDEAS

from syllabus: 
In the first part (which is the relatively longer of the two), you will study the monetary policy of your country. When you think of your country’s monetary policy, the Taylor rule is a standard way to describe the priorities of the Central Bank. Do your best to estimate it, and in any case be sure to add your own description of what your analysis means in terms of the monetary policy practice within the country. The information you use in this part may well build on your past chapters, when you find them useful (for example with the medium run target values of unemployment and inflation).

*/

graph set window fontface default

foreach frame in "frame JAPAN" "frame CHILE" {
	
	`frame' {

	cd "${output}/`: var label fr_id '/ch4/"
	
	if CC=="CHL" {
		graph set window fontface "Times New Roman"
		
	} 

***PLOT	
	qui levelsof RecYear, local(RY)
	qui sum Year
	local grtitle = "Filtered trends"
	tw tsline interest_trend unemp_trend gdp_trend infl_trend, nodraw ///
	lcolor(`: var label color_5')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%4.1fc)) xtitle("") ytitle("%", orientation(horizontal)) ///
	title(`grtitle', color(black) span) ///
	name(trendcomps, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(cols(4) ) ///
	xline(`RY' , lcolor(gs10%85)) 
	 
	
	qui levelsof RecYear, local(RY)
	qui sum Year
	local grtitle = "Cyclical components of trends"
	tw tsline interest_cyc unemp_cyc gdp_cyc infl_cyc , nodraw ///
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
	
	qui levelsof RecYear, local(RY)
	qui sum Year
	local grtitle = "Deviations from trends"
	tw tsline interest_dev unemp_dev gdp_dev infl_dev , nodraw ///
	lcolor(`: var label color_5')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%4.1fc)) xtitle("") ///
	ytitle("%", orientation(horizontal)) ///
	title(`grtitle', color(black) span) ///
	name(trenddevs, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(cols(4) ) ///
	xline(`RY' , lcolor(gs10%85)) ///
	yline(0, lcolor(gs10%85)) 
	
	gr combine trendcomps cyccomps trenddevs , ///
	rows(3) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) name(trendpanels, replace) ///
	xsize(7) scale(0.8) xcommon ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank))  ///
	note("vertical lines mark recession years" "${datasource}")
	
	gr export "HP Trends triple panel.png", replace
	gr close
	
	gr combine trendcomps  trenddevs , ///
	rows(3) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note(, nobox) name(trendpanelsslim, replace) ///
	xsize(7) scale(0.8) xcommon ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank))  
	gr close
	
	if CC=="JPN" {
	qui levelsof RecYear, local(RY)
	qui sum Year if taylor_93_0!=.
	local grtitle = "Taylor 1993"
	tw (tsline taylor_93_0  taylor_93_2 taylor_93_1 v276 if taylor_93_0!=., nodraw ///
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
	label(4 "Actual Nominal Lending Rate")) ///
	xline(`RY' , lcolor(gs10%85)) ) ///
	(rarea taylor_93_0 taylor_93_2 Year if taylor_93_0!=., sort ///
	color(gs10%80) fcolor(gs11%60) )
	}
	
	if CC=="CHL" {
	qui levelsof RecYear, local(RY)
	qui sum Year if taylor_93_0!=.
	local grtitle = "Taylor 1993"
	tw (tsline taylor_93_0  taylor_93_5 taylor_93_2  ///
	v276 if taylor_93_0!=., nodraw ///
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
	label(4 "Actual Nominal Lending Rate")) ///
	xline(`RY' , lcolor(gs10%85)) ) ///
	(rarea taylor_93_0 taylor_93_5 Year if taylor_93_0!=., sort ///
	color(gs10%80) fcolor(gs11%60) )
	}
	
	*****************
	*MONEY TARGETING
	*****************
	qui levelsof RecYear, local(RY)
	qui sum Year if taylor_93_0!=.
	local grtitle = "Money Supply"
	tw tsline v272 v288 if v288!=. , nodraw  ///
	lcolor(`: var label color_2' gs10%80 purple%90)  ${grs} ///
	lpattern(solid dash) ///
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
	note("vertical lines mark recession years" "${datasource}")
	
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
	"Trends are estimated using a Hodrick-Prescott Filter (cf. Wooldridge, 2020)" "${datasource}")
	
	gr export "Mega Graph.png", replace
	gr close
	
gr drop _all
	

	
	
	}
}


