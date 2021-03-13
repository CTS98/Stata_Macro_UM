clear all
version 16
set more off
cap log close

***SET WORKING DIRECTORY
cd "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/"

qui include "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do/paths.do"

set checksum off
**GET DATA FOR TOPIC 3: ECONOMY
wbopendata, language(en - English) country() topics(3 - Economy & Growth) indicator() long

drop countryname region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename
ren year Year
ren countrycode CC

keep if CC=="JPN" | CC=="CHL" | CC=="TUR"

save "${apidata}/WBAPI_T3_premerge.dta", replace

**GET DATA FOR TOPIC 7: FINANCIAL SECTOR
clear
wbopendata, language(en - English) country() topics(7 - Financial Sector) indicator() long

drop countryname region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename
ren year Year
ren countrycode CC

keep if CC=="JPN" | CC=="CHL" | CC=="TUR"

save "${apidata}/WBAPI_T7_premerge.dta", replace

**GET DATA FOR TOPIC 10: SOCIAL PROTECTION & LABOR
clear
wbopendata, language(en - English) country() topics( 10 - Social Protection & Labor) indicator() long

drop countryname region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename
ren year Year
ren countrycode CC

keep if CC=="JPN" | CC=="CHL" | CC=="TUR"

save "${apidata}/WBAPI_T10_premerge.dta", replace
clear

**GET DATA FOR TOPIC 13: PUBLIC SECTOR
wbopendata, language(en - English) country() topics(13 - Public Sector) indicator() long 

drop countryname region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename
ren year Year
ren countrycode CC

keep if CC=="JPN" | CC=="CHL" | CC=="TUR"

save "${apidata}/WBAPI_T13_premerge.dta", replace
clear

**GET DATA FOR TOPIC 20: EXTERNAL DEBT
wbopendata, language(en - English) country() topics(20 - External Debt) indicator() long 

drop countryname region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename
ren year Year
ren countrycode CC
keep if CC=="JPN" | CC=="CHL" | CC=="TUR"

save "${apidata}/WBAPI_T20_premerge.dta", replace

clear

**GET DATA FOR TOPIC 14: Science and Technology
wbopendata, language(en - English) country() topics(14 - Science and Technology) indicator() long 

drop countryname region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename
ren year Year
ren countrycode CC
keep if CC=="JPN" | CC=="CHL" | CC=="TUR"

save "${apidata}/WBAPI_T14_premerge.dta", replace

clear

**GET DATA FOR TOPIC 11: Poverty
wbopendata, language(en - English) country() topics(11 - Poverty) indicator() long 

drop countryname region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename
ren year Year
ren countrycode CC
keep if CC=="JPN" | CC=="CHL" | CC=="TUR"

save "${apidata}/WBAPI_T11_premerge.dta", replace

clear

**GET DATA FOR TOPIC 12: Private Sector
wbopendata, language(en - English) country() topics(12 - Private Sector) indicator() long 

drop countryname region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename
ren year Year
ren countrycode CC
keep if CC=="JPN" | CC=="CHL" | CC=="TUR"

save "${apidata}/WBAPI_T12_premerge.dta", replace

clear

**GET DATA FOR POPULATION LEVEL/GROWTH
wbopendata, language(en - English) indicators( ///
SP.POP.GROW; SP.POP.TOTL; SP.POP.DPND; SP.POP.DPND.OL; SP.POP.DPND.YG; ///
SP.POP.TOTL.FE.ZS; SP.RUR.TOTL.ZG; SP.URB.GROW; SP.URB.TOTL.IN.ZS; SP.POP.65UP.TO.ZS)long projection nometadata clear

la var sp_pop_grow "Population Growth, annual %" 
la var sp_pop_totl "Population, total"
la var sp_pop_dpnd "Age Dependency Ratio (% of working-age population)"
la var sp_pop_dpnd_ol "Age Dependency Ratio, old (% of working-age population)"
la var sp_pop_dpnd_yg "Age Dependency Ratio, young (% of working-age population)"
la var sp_pop_totl_fe_zs "Population, female (%of total population)"
la var sp_rur_totl_zg "Rural population growth (annual %)"
la var sp_urb_grow "Urban population growth, annual %"
la var sp_urb_totl_in_zs "Urban population (% of total population)"
la var sp_pop_65up_to_zs "Population ages 65+ (% of total population)"

drop countryname region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename
ren year Year
ren countrycode CC
keep if CC=="JPN" | CC=="CHL" | CC=="TUR"

save "${apidata}/WBAPI_POP_premerge.dta"
