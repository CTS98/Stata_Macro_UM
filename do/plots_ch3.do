clear all
qui include "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do/paths.do"
**LOAD DATA INCL FRAMES
run "${do}/data_prep.do"



**************************
*CHAPTER 3 PLOTS & FIGURES
**************************

/*IDEAS

from syllabus: In weeks 5 and 6, we discuss the long run and policy issues, including fiscal policy. Again, we focus on the changes in your country throughout the time period you are analyzing. 
This time (in the third chapter), we look at government debt and its dynamics. 
Has debt gone up or down? What about the different components of government debt? Now compare this debt dynamics to the long-run growth of the economy
DONE

. Remember from last week you can look at specific factors that may lead to higher long run growth. Compare the long run growth with what you found as government debt dynamics. Make an inference on the risk of your country based on this, as well as on the effect of the interest rate

central gov debt: v64, PV of current external debt: v53-55 short-term debt: v51
general gov final consumption expenditure: v67-v72
claims on central gov: v264, v280

maybe interesting: v423, v294

*/



foreach frame in "frame JAPAN" "frame CHILE" {
	
	`frame' {

	cd "${output}/`: var label fr_id '/ch3/"
	
	if CC=="CHL" {
		graph set window fontface "Times New Roman"
	} 
	
	**POPULATION GROWTH
	qui levelsof RecYear, local(RY)
	qui sum Year, detail
	local grtitle = "Population Growth"
	tw tsline v567 v573 v574, nodraw ///
	lcolor(`: var label color_2')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) xtitle("") ytitle("") ///
	title(`grtitle', color(black) span) ///
	name(popgrowth, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(3) ) ///
	xline(`RY' , lcolor(gs10%85)) ///
	yline(0, lcolor(gs10%85)) 
	
	**POPULATION GROWTH
	qui levelsof RecYear, local(RY)
	qui sum Year, detail
	local grtitle = "Population Composition"
	tw tsline v576 v572 v570, nodraw ///
	lcolor(`: var label color_2') lpattern(solid dash) ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) xtitle("") ytitle("") ///
	title(`grtitle', color(black) span) ///
	name(popcomp, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny) ) ///
	legend(rows(3) ) ///
	xline(`RY' , lcolor(gs9%85)) 
	
	**COMBINE POPULATION GRAPHS
	gr combine popgrowth popcomp, ///
	rows(2) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) name(labor_infl, replace) ///
	xsize(7) scale(0.8) ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank)) xcommon ///
	note("vertical lines mark recession years" "${datasource}")
	
	gr export "Population Growth and Composition.png", replace

************************************
************************************
if CC=="CHL" {
	**GOV INTEREST PAYMENTS
	qui levelsof RecYear, local(RY)
	qui sum Year, detail
	local grtitle = "Government Interest Payments"
	tw tsline v482alt v278 v277, nodraw ///
	lcolor(`: var label color_5')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) xtitle("") ytitle("") ///
	title(`grtitle', color(black) span) ///
	yline(0, lcolor(gs10%85)) ///
	name(govinterest, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(cols(2)  span)  ///
	xline(`RY' , lcolor(gs9%85)) 
	
	**Revenue, Expense, Deficit
	qui levelsof RecYear, local(RY)
	qui sum Year, detail
	local grtitle = "Revenue, Expense, and the Budget"
	tw tsline totalrevreal  expensereal budgetdefreal, nodraw ///
	lcolor(`: var label color_5')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) xtitle("") ytitle("") ///
	title("`grtitle'", color(black) span) ///
	yline(0, lcolor(gs10%85)) ///
	name(budgetdef, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(cols(2) span)  ///
	xline(`RY' , lcolor(gs9%85))  ///
	note("values calculated from WDI series gc_rev_gotr_cn, gc_tax_totl_cn, gc_xpn_totl_cn, ny_gdp_defl_zs") 
	
	**Change in GDP, Deficit, Interest Paid
	qui levelsof RecYear, local(RY)
	qui sum Year, detail
	local grtitle = "Changes in GDP and the Deficit"
	tw tsline v198 v456 v278 budgetdefreal_pc, nodraw ///
	lcolor(`: var label color_5')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) xtitle("") ytitle("") ///
	title("`grtitle'", color(black) span) ///
	lpattern(solid solid dash) ///
	yline(0, lcolor(gs10%85)) ///
	name(deficitch, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(cols(2) span)  ///
	xline(`RY' , lcolor(gs9%85)) 

	**COMBINE DEFICIT/INTEREST GRAPHS
	gr combine budgetdef govinterest deficitch, ///
	rows(3) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) name(govdebtdyn, replace) ///
	xsize(7) ysize(10) scale(0.8) ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank)) xcommon ///
	note("vertical lines mark recession years" "${datasource}")
	gr export "Chile Debt Dynamics.png", replace
}
************************************
************************************

	**R&D/Technology
	qui sum Year, detail
	local grtitle = "Patent Applications"
	tw tsline v732 v733 v73total, nodraw ///
	lcolor(`: var label color_2')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) xtitle("") ytitle("") ///
	title(`grtitle', color(black) span) ///
	name(patentapps, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(3) )  

	if CC=="CHL" {
		
	**Metals and Manufacturing
	qui sum Year, detail
	local grtitle = "Metals and Manufacturing"
	tw tsline v708 v709  , nodraw ///
	lcolor(`: var label color_5')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) xtitle("") ytitle("") ///
	title(`grtitle', color(black) span) ///
	name(metalsandmanuf, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(4) )  
	
	**COMBINE
	gr combine patentapps metalsandmanuf, ///
	cols(2) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) name(govdebtdyn, replace) ///
	xsize(7)  scale(0.8) ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank))  ///
	note("vertical lines mark recession years" "${datasource}")
	gr export "Metals and Manufacturing.png", replace
	**Government Debt, relative values v124 v125 v127
	qui sum Year, detail
	local grtitle = "Government Debt Dynamics"
	tw tsline v484 v483 v456 v66 v482alt, ///
	lcolor(`: var label color_5')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) xtitle("") ytitle("") ///
	title(`grtitle', color(black) span) ///
	yline(0, lcolor(gs10%85)) ///
	name(debtdyn, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(5))  
	}
************************************
************************************
*DEBT IN JAPAN ONLY:
	if CC=="JPN" {		
	
	qui levelsof RecYear, local(RY)
	qui sum Year, d
	local grtitle = "Government Debt"
	tw 	(lpolyci v280 Year, fintensity(inten10) alpattern(solid) ///
	lcolor(gs10%80) ///
	lpattern(dash) ) ///
	(lpolyci v64 Year, fintensity(inten10) alpattern(solid) lcolor(gs10%80) ///
	lpattern(dash) ) ///
	(tsline v280  v64 v72 , nodraw ///
	lcolor(`: var label color_2' green)  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) ytitle("%") ///
	title(`grtitle', color(black) span) ///
	yline(0, lcolor(gs10%85)) xline(`RY' , lcolor(gs9%85)) ///
	name(govvdebtdynjap, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) legend(rows(7) order( ///
	5 6 7  2 3) label(2 "Smooth Trend") label(4 "Smooth Trend"))  )
	
	qui levelsof RecYear, local(RY)
	qui sum Year, d
	local grtitle = "Private Sector Debt"
	tw 	(lpolyci v281 Year, fintensity(inten10) alpattern(solid) ///
	lcolor(gs10%80) ///
	lpattern(dash) ) ///
	(lpolyci v283 Year, fintensity(inten10) alpattern(solid) lcolor(gs10%80) ///
	lpattern(dash) ) ///
	(tsline v281  v283 v260 , nodraw ///
	lcolor(`: var label color_2' green)  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) ytitle("%") ///
	title(`grtitle', color(black) span) ///
	xline(`RY' , lcolor(gs9%85)) ///
	name(privdebtdynjap, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) legend(rows(6) order( ///
	5 6 7 2  1) label(2 "Smooth Trend") label(4 "Smooth Trend")) )  

	**COMBINE DEFICIT/INTEREST GRAPHS
	gr combine govvdebtdynjap privdebtdynjap, ///
	cols(2) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) name(govdebtdyn, replace) ///
	xsize(7)  scale(0.8) ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank))  ///
	note("vertical lines mark recession years" "${datasource}")
	gr export "Gov and Private Debt Dynamics.png", replace
	
	}
		
	***PERCENT CHANGES
	qui levelsof RecYear, local(RY) 
	qui sum Year, detail
	local grtitle = "Government Debt Dynamics"
	tw tsline v64_pc v283_pc v278 v277, nodraw ///
	lpattern(solid solid solid dash) ///
	lcolor(`: var label color_5')  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) xtitle("") ytitle("") ///
	title(`grtitle', color(black) span) ///
	yline(0, lcolor(gs10%85)) ///
	xline(`RY' , lcolor(gs9%85)) ///
	name(dyndebtpc, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(4))  
	
	***Interest and FX
	qui levelsof RecYear, local(RY) 
	qui sum Year, detail
	local grtitle = "Interest and Exchange Rates"
	tw tsline v278 v266_pc v283_pc  v291_pc	, nodraw ///
	lpattern(solid solid dash longdash) ///
	lcolor(`: var label color_2' green%60 teal%60)  ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) xtitle("") ytitle("") ///
	title(`grtitle', color(black) span) ///
	yline(0, lcolor(gs10%85)) ///
	xline(`RY' , lcolor(gs9%85)) ///
	name(irfx, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(5))  

	**COMBINE DEFICIT/INTEREST GRAPHS
	gr combine dyndebtpc irfx, ///
	cols(2) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) name(debtdyn_fx, replace) ///
	xsize(7)  scale(0.8) ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank))  ///
	note("vertical lines mark recession years" "${datasource}")
	gr export "IR&FX.png", replace

************************************
************************************
	**DEBT TO GDP
		
	qui levelsof RecYear, local(RY) 
	qui sum Year, detail
	local grtitle = "Debt to GDP"
	tw tsline debtogdp v198, nodraw   ///
	lpattern(solid solid dash longdash) ///
	lcolor(`: var label color_2' green%60 teal%60)  ${grs} ///
	ylabel(#7, nogrid angle(0) format(%5.0gc)) xtitle("") ytitle("") ///
	title(`grtitle', color(black) span) ///
	yline(0, lcolor(gs10%85)) ///
	xline(`RY' , lcolor(gs9%85)) ///
	name(debtto, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(2))  
	
	qui levelsof RecYear, local(RY) 
	qui sum Year, detail
	local grtitle = "Long-run growth"
	tw (lfitci v199t Year, fintensity(inten10) alpattern(solid) ///
	lcolor(gs10%80) lpattern(dash) ) ///
	(tsline  v199t , nodraw ///
	lpattern(solid solid dash longdash) ///
	lcolor(`: var label color_2' green%60 teal%60)  ${grs} ///
	ylabel(#7, nogrid angle(0) format(%5.0gc)) xtitle("") ytitle("") ///
	title(`grtitle', color(black) span) ///
	yline(0, lcolor(gs10%85)) ///
	xline(`RY' , lcolor(gs9%85)) ///
	name(LRgrowth, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(order(3 2 1) rows(2) label(2 "Linear Trend") ///
	label(1 "95% Confidence Interval of Linear Trend")) ) 
	
	gr combine debtto LRgrowth, ///
	cols(2) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) name(debtto_lrg, replace) ///
	xsize(7)  scale(0.8) ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank))  ///
	note("vertical lines mark recession years" "${datasource}")
	gr export "Debt to GDP and LR growth.png", replace
	
************************************
************************************
	*SAVING and INVESTMENT
	if CC=="CHL" {
	qui levelsof RecYear, local(RY) 
	qui sum Year, detail
	local grtitle = "Saving and Investment"
	tw (lpoly v117 Year, lcolor(green%60) lpattern(dash) ) ///
	(lpoly v211 Year, lcolor(orange%60) lpattern(dash) ) ///
	(tsline  v117 v211 , nodraw  ///
	lpattern(solid solid dash longdash) ///
	lcolor(`: var label color_2' green%60 teal%60)  ${grs} ///
	ylabel(#7, nogrid angle(0) format(%5.0gc)) xtitle("") ytitle("") ///
	title(`grtitle', color(black) span) ///
	xline(`RY' , lcolor(gs9%85)) ///
	name(savinginvest, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(2) label(1 "Smooth Trend, cap. formation") ///
	label(2 "Smooth Trend, saving") ///
	symxsize(3.5pt) ) )
	}
	if CC=="JPN" {
	qui levelsof RecYear, local(RY) 
	qui sum Year, detail
	local grtitle = "Saving and Investment"
	tw (lpoly v117 Year, lcolor(red%60) lpattern(dash) ) ///
	(lpoly v211 Year, lcolor(blue%60) lpattern(dash) ) ///
	(tsline  v117 v211 , nodraw  ///
	lpattern(solid solid dash longdash) ///
	lcolor(`: var label color_2' green%60 teal%60)  ${grs} ///
	ylabel(#7, nogrid angle(0) format(%5.0gc)) xtitle("") ytitle("") ///
	title(`grtitle', color(black) span) ///
	xline(`RY' , lcolor(gs9%85)) ///
	name(savinginvest, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(2) label(1 "Smooth Trend, cap. formation") ///
	label(2 "Smooth Trend, saving") ///
	symxsize(3.5pt) ) )
	}
	
	

************************************
************************************
	*INCOME INEQ
	if CC=="CHL" {
	
	qui levelsof RecYear if v740!=., local(RY) 
	qui sum Year if v740!=. , detail
	local grtitle = "Income Inequality"
	tw tsline v744 v746 v743 v747 v750 if Year>=`r(min)',    ///
	lpattern(solid solid dash longdash) ///
	lcolor(`: var label color_5' green%60 teal%60)  ${grs} ///
	ylabel(#7, nogrid angle(0) format(%5.0gc)) ytitle("%") xtitle("") ///
	title(`grtitle', color(black) span) ///
	yline(0, lcolor(gs10%85)) ///
	name(incomeineq_chl, replace) ///
	tlabel(1987(2)2011, angle(0) gmin)  ///
	graphregion(margin(tiny)) ///
	legend(rows(5) order(3 5 1 4 2))  
	
	******COMBINE
	gr combine savinginvest incomeineq_chl, ///
	cols(2) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) name(saving_incomeineq, replace) ///
	xsize(7)  scale(0.8) ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank))  ///
	note("vertical lines mark recession years" "${datasource}")
	gr export "Saving and Income Ineq.png", replace
	

	}
	
	if CC=="JPN" {
	
	
	*R&D
	qui levelsof RecYear, local(RY) 
	qui sum Year, detail
	local grtitle = "Research and Education"
	tw (lfit v730 Year, lcolor(red%60) lpattern(dash) ) ///
	(lfit v158 Year, lcolor(blue%60) lpattern(dash) ) ///
	(tsline   v730 v158,   ///
	lpattern(solid solid dash longdash) ///
	lcolor(`: var label color_2' green%60 teal%60)  ${grs} ///
	ylabel(#7, nogrid angle(0) format(%5.0gc)) xtitle("") ytitle("") ///
	title(`grtitle', color(black) span) ///
	xline(`RY' , lcolor(gs9%85)) ///
	name(randd, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(2) colfirst label(1 "Linear Trend") ///
	label(2 "Linear Trend") ///
	symxsize(3.5pt) ) )

	******COMBINE
	gr combine savinginvest randd, ///
	cols(2) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) name(saving_randd, replace) ///
	xsize(7)  scale(0.8) ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank))  ///
	note("vertical lines mark recession years" "${datasource}")
	gr export "Saving and Income Ineq.png", replace
	

	}
	* v16-v27 v33-v37 v61-v64 v67-v72 v101-v108 v266
gr drop _all
		
	}
}

