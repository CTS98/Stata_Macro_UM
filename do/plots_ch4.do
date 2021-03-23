clear all
qui include "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do/paths.do"
**LOAD DATA INCL FRAMES
run "${do}/data_prep.do"



**************************
*CHAPTER 4 PLOTS & FIGURES
**************************

/*IDEAS

from syllabus: 
In the first part (which is the relatively longer of the two), you will study the monetary policy of your country. When you think of your country’s monetary policy, the Taylor rule is a standard way to describe the priorities of the Central Bank. Do your best to estimate it, and in any case be sure to add your own description of what your analysis means in terms of the monetary policy practice within the country. The information you use in this part may well build on your past chapters, when you find them useful (for example with the medium run target values of unemployment and inflation).

*/
frame change JAPAN
des  v275 v276 v277 v278 v279 v291 v63 v186 v288 v416

****GENERATE HP TRENDS
tsfilter hp interest_cyc = v276 , trend(interest_trend)

tsfilter hp gdp_cyc = v198 , trend(gdp_trend)

tsfilter hp unemp_cyc = v416 , trend (unemp_trend)

****GEN DEVIATIONS FROM HP TRENDS
gen interest_dev = v276-interest_trend

gen gdp_dev = v198-gdp_trend

egen NAIRU_trend = mean(unemp_trend)

egen NAIRU = mean(v416)

gen unemp_dev = v416-unemp_trend




**LABEL AND ORDER
order interest* gdp* unemp* NAIR*, last

la var interest_cyc "Cyclical component of the interest rate"
la var interest_trend "Trend in lending rate (HP)"
la var unemp_trend "Trend in unemployment rate (HP)"
la var gdp_trend "Trend in GDP (HP)"
la var unemp_cyc "Cyclical unemployment (HP)"
la var NAIRU "Mean Unemployment Rate across period"
la var NAIRU_trend "Mean Unemployment Rate less cyclical"
la var interest_dev "Deviation from trend in interest rate"
la var gdp_dev "Deviation from trend in GDP"
la var unemp_dev "Deviation from trend in the unemployment rate"


***PLOT	
	qui levelsof RecYear, local(RY)
	qui sum Year
	local grtitle = "Filtered trends"
	tw tsline interest_trend unemp_trend NAIRU, nodraw ///
	lcolor(`: var label color_2' `: var label color_1')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) xtitle("") ytitle("%") ///
	title(`grtitle', color(black) span) ///
	name(trendcomps, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(cols(3) ) ///
	xline(`RY' , lcolor(gs10%85)) ///
	 
	
	qui levelsof RecYear, local(RY)
	qui sum Year
	local grtitle = "Cyclical components of trends"
	tw tsline interest_cyc unemp_cyc , nodraw ///
	lcolor(`: var label color_2' `: var label color_1')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%4.2fc)) xtitle("") ytitle("%") ///
	title(`grtitle', color(black) span) ///
	name(cyccomps, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(cols(3) ) ///
	xline(`RY' , lcolor(gs10%85)) ///
	yline(0, lcolor(gs10%85)) 
	
	qui levelsof RecYear, local(RY)
	qui sum Year
	local grtitle = "Deviations from trends"
	tw tsline interest_dev unemp_dev gdp_dev , nodraw ///
	lcolor(`: var label color_2' `: var label color_1')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) xtitle("") ytitle("%") ///
	title(`grtitle', color(black) span) ///
	name(trenddevs, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(cols(3) ) ///
	xline(`RY' , lcolor(gs10%85)) ///
	yline(0, lcolor(gs10%85)) 
	
	gr combine trendcomps cyccomps trenddevs , ///
	rows(3) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) name(trendpanels, replace) ///
	xsize(7) scale(0.8) ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank)) xcommon ///
	note("vertical lines mark recession years" "${datasource}")
	
/*
foreach frame in "frame JAPAN" "frame CHILE" {
	
	`frame' {

	cd "${output}/`: var label fr_id '/ch3/"
	
	if CC=="CHL" {
		graph set window fontface "Times New Roman"
	} 
	
gr drop _all
		
	}
}
*/
