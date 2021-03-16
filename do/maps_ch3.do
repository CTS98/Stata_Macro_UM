clear all
qui include "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do/paths.do"


*****PREP SPMAP FILES
qui sysuse world-c, clear
save "${data}/world-c.dta", replace


clear
********************************
********************************
***ORES AND METALS
graph set window fontface "Times New Roman"

qui tempfile tmp

qui wbopendata, language(en - English) indicator(tx.val.mmtl.zs.un) long clear latest
ren tx_val_mmtl_zs_un metals
local labelvar "`r(varlabel1)'"

sort countrycode

save `tmp', replace

qui sysuse world-d, clear
*save "${data}/world-c.dta", replace
qui merge countrycode using `tmp'

qui sum year

local avg = string(`r(mean)',"%16.1f")

spmap metals using "${data}/world-c.dta", id(_ID) ///
clnumber(10) fcolor(Rainbow) ocolor(none ..)  ///
title("`labelvar'", size(*1.2)) legstyle(2) legend(ring(1) position(3)) ///
osize(vvthin vvthin vvthin vvthin) ndsize(vvthin) ndfcolor(gs10%30) ///
clmethod(custom) clbreaks(0 20 30 40 50 60 70) ///
title("Ores and metals exports (% of merchandise exports)", ///
color(black) span) ///
note("${datasource}") ///
saving("${output}/CHL/ch3/Metals Map.gph", replace) 
gr export  "${output}/CHL/ch3/Metals Map.png", replace

gr close

graph set window fontface default
clear
********************************
********************************
***AGE >65

qui tempfile tmp2

qui wbopendata, language(en - English) indicator(sp.pop.65up.to.zs) long clear latest
ren sp_pop_65up_to_zs age
local labelvar "`r(varlabel1)'"

sort countrycode

save `tmp2', replace

qui sysuse world-d, clear
*save "${data}/world-c.dta", replace
qui merge countrycode using `tmp2'

qui sum year

local avg = string(`r(mean)',"%16.1f")

spmap age using "${data}/world-c.dta", id(_ID) ///
fcolor(Rainbow) ocolor(none ..)  ///
title("`labelvar'", size(*1.0)) legstyle(2) legend(ring(1) position(3)) ///
osize(vvthin vvthin vvthin vvthin) ndsize(vvthin) ndfcolor(gs10%30) ///
clmethod(custom) clbreaks(0 5 10 15 20 25 30) ///
title("Population Ages 65 and above, % of total Population", ///
color(black) span) ///
 nodraw ///
saving("${output}/JPN/ch3/65+.gph", replace) 

gr close

clear
********************************
********************************
***C Gov Debt gc.dod.totl.gd.zs

qui tempfile tmp3

qui wbopendata, language(en - English) indicator(FM.AST.DOMS.CN; NY.GDP.MKTP.CN) long clear latest 
ren fm_ast_doms_cn NetCreditCurr
ren ny_gdp_mktp_cn GDPCurr
gen NetRealCredit = NetCreditCurr/GDPCurr 
la var NetRealCredit "Net Credit to GDP as a multiple"
local labelvar "`r(varlabel1)'"

sort countrycode

save `tmp3', replace

qui sysuse world-d, clear
*save "${data}/world-c.dta", replace
qui merge countrycode using `tmp3'

qui sum year

local avg = string(`r(mean)',"%16.1f")

spmap NetRealCredit using "${data}/world-c.dta", id(_ID) ///
fcolor(Rainbow) ocolor(none ..)  ///
title("`labelvar'", size(*1.0)) legstyle(2) legend(ring(1) position(3)) ///
osize(vvthin vvthin vvthin vvthin) ndsize(vvthin) ndfcolor(gs10%30) ///
clmethod(custom) clbreaks(-1 0  0.5 1 1.5 2 2.5 3) ///
title("`: var label NetRealCredit'", color(black) span) ///
subtitle("Calculated using WDI series FM.AST.DOMS.CN and NY.GDP.MKTP.CN", ///
tstyle(size(small)) span) ///
 nodraw ///
saving("${output}/JPN/ch3/CredittoGDP.gph", replace) 

gr close

clear
********************************
********************************
***si_pov_gini
qui tempfile tmp4

qui wbopendata, language(en - English) indicator(SI.POV.GINI) long clear latest
ren si_pov_gini Gini_orig

gen Gini = (Gini_orig/100)

la var Gini "Gini Coefficient"
local labelvar "`r(varlabel1)'"

sort countrycode

save `tmp4', replace

qui sysuse world-d, clear
*save "${data}/world-c.dta", replace
qui merge countrycode using `tmp4'

qui sum year

local avg = string(`r(mean)',"%16.1f")

spmap Gini using "${data}/world-c.dta", id(_ID) ///
fcolor(Spectral) ocolor(none ..)  ///
title("`labelvar'", size(*1.2)) legstyle(2) legend(ring(1) position(3)) ///
osize(thin vvthin vvthin vvthin) ndsize(vvthin) ndfcolor(gs10%30) ///
clmethod(custom) clbreaks(0 0.1 0.2 0.3  0.4 0.45 0.5 0.6 0.7 1) ///
title("`: var label Gini'", ///
color(black) span) ///
note("${datasource}", color(black) span) saving("${output}/Gini.gph", replace) 

gr export "${output}/Gini.png", replace

gr close

clear
********************************
********************************
*COMBINE
cd "${output}/JPN/ch3"

gr combine 65+.gph CredittoGDP.gph , ///
	rows(2) title(, color(black) nobox fcolor() ) subtitle(, nobox) ///
	caption(, nobox)  name(age_debt_map, replace) ///
	xsize(7)  scale(1) imargin(0 0 0 0) graphregion(margin(l=22 r=22))  ///
	graphregion(margin(zero) fcolor(white) ///
	lcolor(white%0) lpattern(blank) ifcolor(white) ilcolor(white%0) ///
	ilpattern(blank))  ///
	note("${datasource}", pos(6))
	gr export "Maps age credit.png", replace
	
	gr close
