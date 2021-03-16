clear all
qui include "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do/paths.do"


*****PREP SPMAP FILES
qui sysuse world-c, clear
save "${data}/world-c.dta", replace
clear


***ORES AND METALS
qui tempfile tmp

wbopendata, language(en - English) indicator(tx.val.mmtl.zs.un) long clear latest
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
clnumber(10) fcolor(Reds2) ocolor(none ..)  ///
title("`labelvar'", size(*1.2)) legstyle(3) legend(ring(1) position(3))

***AGE >65

qui tempfile tmp2

wbopendata, language(en - English) indicator(sp.pop.65up.to.zs) long clear latest
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
clnumber(10) fcolor(Reds2) ocolor(none ..)  ///
title("`labelvar'", size(*1.2)) legstyle(3) legend(ring(1) position(3))
