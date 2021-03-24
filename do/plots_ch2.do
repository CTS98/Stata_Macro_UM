
qui include "/Users/ts/Git/Stata_Macro_UM/do/paths.do"
**LOAD DATA INCL FRAMES
run "${do}/data_prep.do"



**************************
*CHAPTER 2 PLOTS & FIGURES
**************************

foreach frame in "frame JAPAN" "frame CHILE" {
	
	`frame' {

	cd "${output}/`: var label fr_id '/ch2/"
		

	
	**PRODUCE INDIVIDUAL PANELS
		
	*****LABOR MARKET DYNAMICS
	qui levelsof RecYear, local(RY)
	qui sum Year, detail
	local grtitle = "Labor Market Dynamics"
	tw tsline v416_pc_ch v416 , ///
	lcolor(`:var label color_2') lpattern(solid dash) ${grs} ///
	title(`grtitle', color(black) span) ///
	name(labmarketdyn, replace) ///
	ylabel(, nogrid angle(0)) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(2)) ///
	xline(`RY' , lcolor(gs9%85))  nodraw
	
	
	*****INFLATION DYNAMICS
	qui levelsof RecYear, local(RY)
	qui sum Year, detail
	local grtitle = "Inflation Dynamics"
	tw tsline v63 v186, ///
	lcolor(`: var label color_2') lpattern(solid dash) ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) ytitle("") ///
	title(`grtitle', color(black) span) ///
	name(infldyn, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(2)) ///
	xline(`RY' , lcolor(gs9%85))  nodraw
	
	
	*****PLOT OKUN'S LAW
	local grtitle = "Okun's Law"
	tw (scatter v416_pc_ch v198, mcolor(`: var label color_scat')  ///
	mlab(RYString) mlabp(3) mlabcolor(`: var label color_s_line') ///
	plotregion(fcolor(white)) yline(0, lcolor(gs12%90)  ) ///
	graphregion(fcolor(white)) bgcolor(white) ///
	ylabel(#8, nogrid angle(0) format(%4.2fc))  ///
	ytitle("Percentage Point Change in Unemployment") ///
	xlabel(#8, angle(0)  norescale format(%4.2fc)  ) ///
	title("`grtitle'", color(black) span) ///
	legend(off) name(okun, replace) ///
	xline(0, lcolor(gs12%90)) nodraw ) ///
	(lfit v416_pc_ch v198, lcolor(`: var label color_s_line')) 
	
	
	*****PC: inflation rate vs unemployment scatter w line
	local grtitle = "Phillips Curve"
	tw (scatter v63 v416_pc_ch, mcolor(`: var label color_scat') ///
	mlab(RYString) mlabp(3) mlabcolor(`: var label color_s_line') ///
	plotregion(fcolor(white)) yline(0, lcolor(gs12%90)  ) ///
	graphregion(fcolor(white)) bgcolor(white) ///
	ylabel(#8, nogrid angle(0) format(%4.2fc))  ///
	ytitle("Inflation Rate") ///
	xlabel(#8, angle(0)   format(%4.2fc)  ) ///
	title("`grtitle'", color(black) span) ///
	legend(off) name(PC_first, replace) ///
	xline(0, lcolor(gs12%90)) nodraw  ) ///
	(lfit v63 v416_pc_ch, lcolor(`: var label color_s_line')  ) 
	
	
	*****PC: inflation rate vs unemployment scatter w line
	local grtitle = "Augmented Phillips Curve"
	tw (scatter v63_ch v416_pc_ch, mcolor(`: var label color_scat') ///
	mlab(RYString) mlabp(3) mlabcolor(`: var label color_s_line') ///
	plotregion(fcolor(white)) yline(0, lcolor(gs12%90)  ) ///
	graphregion(fcolor(white)) bgcolor(white) ///
	ylabel(#8, nogrid angle(0) format(%4.2fc))  ///
	ytitle("Percentage Point Change in Inflation") ///
	xlabel(#8, angle(0)   format(%4.2fc)  ) ///
	title("`grtitle'", color(black) span) ///
	legend(off) name(PC, replace) ///
	xline(0, lcolor(gs12%90)) nodraw  ) ///
	(lfit v63_ch v416_pc_ch, lcolor(`: var label color_s_line')  ) 
	
	
	*****PC USING AAPLOT
	qui sum Year
	local grtitle = "Augmented Phillips Curve `r(min)' - `r(max)'"
	aaplot v63_ch v416_pc_ch, lopts(lcolor(`: var label color_s_line')) ///
	mcolor(`: var label color_scat') msymbol(D) ///
	mlab(RYString) mlabp(3) mlabcolor(`: var label color_s_line') ///
	plotregion(fcolor(white)) yline(0, lcolor(gs12%90)  ) ///
	graphregion(fcolor(white)) bgcolor(white) ///
	ylabel(#8, nogrid angle(0) format(%4.2fc))  ///
	ytitle("Percentage Point Change in Inflation") ///
	xlabel(#8, angle(0)   format(%4.2fc)  ) ///
	title("`grtitle'", color(black) span) ///
	legend(off) name(PCfit, replace) nodraw ///
	xline(0, lcolor(gs12%90))  subtitle(, tstyle(size(small) ////
	color(`: var label color_s_line') ) pos(2)ring(0)    )
	
	
	*****PC EXCL REC USING AAPLOT
	qui sum Year
	local grtitle = "Augmented Phillips Curve Excluding Recession Years"
	aaplot v63_ch v416_pc_ch if Year!=RecYear, lopts(lcolor(`: var label color_s_line')) ///
	mcolor(`: var label color_scat') msymbol(D) ///
	mlab(RYString) mlabp(3) mlabcolor(`: var label color_s_line') ///
	plotregion(fcolor(white)) yline(0, lcolor(gs12%90)  ) ///
	graphregion(fcolor(white)) bgcolor(white) ///
	ylabel(#8, nogrid angle(0) format(%4.2fc))  ///
	ytitle("Percentage Point Change in Inflation") ///
	xlabel(#8, angle(0)   format(%4.2fc)  ) ///
	title("`grtitle'", color(black) span) ///
	legend(off) name(PCexclry, replace) nodraw ///
	xline(0, lcolor(gs12%90))  subtitle(, tstyle(size(small) ///
	color(`: var label color_s_line') ) pos(2)ring(0)   )
	
	
**COMBINE GRAPHS INTO FIGURES

	gr combine labmarketdyn infldyn, ///
	rows(2) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) name(labor_infl, replace) ///
	xsize(7) scale(0.8) ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank)) xcommon note("vertical lines mark recession years" "${datasource}")
	
	gr export "Inflation and Labor Market Dynamics.png", replace
	
	gr combine okun PC, ///
	cols(2) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) name(okun_pc, replace) ///
	xsize(7) scale(0.8) ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank)) note("highlighted markers indicate recession years" "${datasource}")
	gr export "Okun's Law and the Phillips Curve.png", replace

	gr combine okun PC_first , ///
	cols(2) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) name(okun_pc_first, replace) ///
	xsize(7) scale(0.8) ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank)) note("highlighted markers indicate recession years" "${datasource}")
	gr export "Okun's Law and the Phillips Curve old.png", replace
	
	gr combine PC_first PC, ///
	cols(2) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) name(pcold_pcnew, replace) ///
	xsize(7) scale(0.8) ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank)) note("highlighted markers indicate recession years" "${datasource}") ///
	title("The Original and the Augmented Phillips Curve", color(black) span)
	
	gr export "The Original and the Augmented Phillips Curve.png", replace
	
	gr export "Fitted Phillips Curves.png", replace
	gr combine PCfit  PCexclry, ///
	cols(2) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) name(pcfit_pcexcl, replace) ///
	xsize(7) scale(0.8) ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank)) note("highlighted markers indicate recession years" "${datasource}")
	
	gr export "Fitted Phillips Curves.png", replace
	
	
***PC piecewise 
	
	qui sum Year, detail
	tw (scatter v63_ch v416_pc_ch if Year <`r(p25)', mcolor(`: var label color_scat') ///
	plotregion(fcolor(white)) yline(0, lcolor(gs12%90)  ) ///
	graphregion(fcolor(white)) bgcolor(white) ///
	ylabel(#8, nogrid angle(0) format(%4.2fc))  ///
	ytitle("Percentage Point Change in Inflation") ///
	xlabel(#8, angle(0)   format(%4.2fc)  ) ///
	title("`r(min)'-`r(p25)'", color(black) span)  ///
	legend(off) name(pcp1, replace) nodraw  )   ///
	(lfit v63_ch v416_pc_ch if Year <`r(p25)', lcolor(`: var label color_s_line'%40)  ) 
	
	
	qui sum Year, detail
	tw (scatter v63_ch v416_pc_ch if Year <`r(p50)' & Year >=`r(p25)', ///
	mcolor(`: var label color_scat') ///
	plotregion(fcolor(white)) yline(0, lcolor(gs12%90)  ) ///
	graphregion(fcolor(white)) bgcolor(white) ///
	ylabel(#8, nogrid angle(0) format(%4.2fc))  ///
	ytitle("Percentage Point Change in Inflation") ///
	xlabel(#8, angle(0)   format(%4.2fc)  ) ///
	title("`r(p25)'-`r(p50)'", color(black) span)  ///
	legend(off) name(pcp2, replace) nodraw ) ///
	(lfit v63_ch v416_pc_ch if Year <`r(p50)' & Year >=`r(p25)', lcolor(`: var label color_s_line'%40) ) 

	
	qui sum Year, detail
	tw (scatter v63_ch v416_pc_ch if Year <`r(p75)'& Year >=`r(p50)', ///
	mcolor(`: var label color_scat') ///
	plotregion(fcolor(white)) yline(0, lcolor(gs12%90)  ) ///
	graphregion(fcolor(white)) bgcolor(white) ///
	ylabel(#8, nogrid angle(0) format(%4.2fc))  ///
	ytitle("Percentage Point Change in Inflation") ///
	xlabel(#8, angle(0)   format(%4.2fc)  ) ///
	title("`r(p50)'-`r(p75)'", color(black) span)  ///
	legend(off) name(pcp3, replace) nodraw ) ///
	(lfit v63_ch v416_pc_ch if  Year <`r(p75)'& Year >=`r(p50)', lcolor(`: var label color_s_line'%40)  ) 
	
	
	qui sum Year, detail
	tw (scatter v63_ch v416_pc_ch if Year >=`r(p75)', ///
	mcolor(`: var label color_scat') ///
	plotregion(fcolor(white)) yline(0, lcolor(gs12%90)  ) ///
	graphregion(fcolor(white)) bgcolor(white) ///
	ylabel(#8, nogrid angle(0) format(%4.2fc))  ///
	ytitle("Percentage Point Change in Inflation") ///
	xlabel(#8, angle(0)   format(%4.2fc)  ) ///
	title("`r(p75)'-`r(max)'", color(black) span)  ///
	legend(off) name(pcp4, replace) nodraw ) ///
	(lfit v63_ch v416_pc_ch if Year >=`r(p75)', lcolor(`: var label color_s_line'%40)  ) 
	
	gr combine pcp1 pcp2 pcp3 pcp4, ///
	cols(2) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note($datasource, nobox) name(pc_piecewise, replace) ///
	xsize(7) scale(0.8) ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank)) 
	
	gr export "Phillips Curve x4.png", replace
	
	qui levelsof RecYear, local(RY)
	qui sum Year
	local grtitle = "Changes in Unemployment and Inflation"
	tw tsline v63_ch v416_pc_ch v198, ///
	lcolor(`: var label color_2' gs10%75) lpattern(solid dash longdash) ${grs} ///
	ylabel(#5, nogrid angle(0) format(%20.0gc)) ytitle("") ///
	title(`grtitle', color(black) span) ///
	name(pcchanges, replace) ///
	xline(`RY' , lcolor(gs9%85)) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	graphregion(margin(tiny)) ///
	legend(rows(3)) note("vertical lines mark recession years" "$datasource")
	gr export "${output}/`: var label fr_id'/ch2/`grtitle'.png", replace
	
	
	

*********************
*TREND ANALYSIS RBC
*********************
	
	***INFLATION
	qui levelsof RecYear, local(RY)
	qui sum Year
	local tspan = "`r(min)'(5)`r(max)'"
	local grtitle = "Change in the Inflation Rate"
	qui sum v63_ch if Year!=RecYear
	tw (tsline v63_ch if Year!=RecYear, cmissing(no) ///
	lcolor(`:var label color_1')  ${grs} ///
	title(`grtitle', color(black) span tstyle(size(medsmall)) ) ///
	name(infltrend, replace) ///
	ylabel(, nogrid angle(0)) ///
	tlabel(`tspan', angle(0) nogex )  ///
	graphregion(margin(zero)) ///
	ytitle("Percentage Points") xtitle("") yline(`r(mean)', lcolor(gs10%85) lpattern(dash)) ///
	note("Mean of `r(mean)'") nodraw  ///
	xline(`RY' , lcolor(gs9%85)) ) ///
	(lfit v63_ch Year if Year!=RecYear, lpattern(dash) lcolor(`: var label color_s_line') ///
	legend(label(2 "Linear trend")) )
	
	
	
	
	***UNEMP CHANGES
	qui levelsof RecYear, local(RY)
	qui sum Year
	local tspan = "`r(min)'(5)`r(max)'"
	local grtitle = "Unemployment Changes"
	qui sum v416_pc_ch if Year!=RecYear
	tw (tsline v416_pc_ch if Year!=RecYear, cmissing(no) ///
	lcolor(`:var label color_1')  ${grs} ///
	title(`grtitle', color(black) span tstyle(size(medsmall)) ) ///
	name(unempchtrend, replace) ///
	ylabel(, nogrid angle(0)) ///
	tlabel(`tspan', angle(0) nogex )  ///
	graphregion(margin(zero)) ///
	ytitle("Percentage Points") xtitle("")  yline(`r(mean)', lcolor(gs10%85) lpattern(dash)) ///
	note("Mean of `r(mean)'") nodraw  ///
	xline(`RY' , lcolor(gs9%85)) ) ///
	(lfit v416_pc_ch Year if Year!=RecYear, lpattern(dash) lcolor(`: var label color_s_line') ///
	legend(label(2 "Linear trend")) )
	
	
	
	***UNEMPLOYMENT
	qui levelsof RecYear, local(RY)
	qui sum Year
	local tspan = "`r(min)'(5)`r(max)'"
	local grtitle = "Unemployment Rate"
	qui sum v416 if Year!=RecYear
	tw (tsline v416 if Year!=RecYear, cmissing(no) ///
	lcolor(`:var label color_1')  ${grs} ///
	title(`grtitle', color(black) span tstyle(size(medsmall)) ) ///
	name(unemptrend, replace) ///
	ylabel(, nogrid angle(0)) ///
	tlabel(`tspan', angle(0) nogex )  ///
	graphregion(margin(zero)) ///
	ytitle("Unemployment in Percent") xtitle("") ///
	yline(0 , lcolor(gs9%85)) yline(`r(mean)', lcolor(gs10%85) lpattern(dash)) ///
	note("Mean of `r(mean)'") nodraw  ///
	xline(`RY' , lcolor(gs9%85)) ) ///
	(lfit v416 Year if Year!=RecYear, lpattern(dash) lcolor(`: var label color_s_line') ///
	legend(label(2 "Linear trend")) )
	
	
	
	
	*****labor force composition
	labvarch v384 v367 v367opp v378  , to(")")
	*labvarch v384 v367 v367opp v378 , subst("Labor force participation rate" "LFpr")
	qui levelsof RecYear, local(RY)
	local grtitle = "Labor Force participation rate"
	qui sum Year, detail
	tw tsline v384 v367 v367opp v378 if Year!=RecYear , ///
	lcolor(`: var label color_5') ${grs} ///
	ylabel(#7, nogrid angle(0) format(%20.0gc)) ytitle("") ///
	title(`grtitle', color(black) span tstyle(size(medsmall))) ///
	name(labforcecomp, replace) ///
	tlabel(`r(min)'(5)`r(max)', angle(0) nogex )  ///
	note("Percentages of total labor force" "${datasource}") ///
	graphregion(margin(tiny)) ///
	xline(`RY' , lcolor(gs9%85))  ///
	ytitle("Percent") xtitle("") ///
	legend( cols(4)  ///
	label(1 "% 15+") ///
	label(2 "% 15-24") ///
	label(3 "% 25+") ///
	label(4 "% female")) nodraw
		
	
	
	gr combine infltrend  unemptrend unempchtrend, ///
	rows(3) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note("Years with negative GDP growth excluded, dashed grey lines indicate mean" "vertical lines mark recession years" "$datasource", nobox) ///
	name(triple_trends, replace) ///
	xsize(7) ysize(9) scale(0.8) ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank)) ///
	title("Trends during non-recessionary Years", color(black)span tstyle(size(medsmall)))
	
	gr export "Triple Trends.png", replace
	
	gr combine infltrend  unemptrend unempchtrend labforcecomp, ///
	rows(4) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox) note("First 3 graphs: Years with negative GDP growth excluded, dashed grey lines indicate mean" "$datasource" , nobox) name(quadruple_trends, replace) ///
	xsize(7) ysize(10) scale(0.7) ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank)) xcommon ///
	title("Trends during non-recessionary Years", color(black)span tstyle(size(medsmall)))
	
	gr export "Quadruple Trends.png", replace
 
gr drop _all
		
	}
}

