clear all
version 16
set more off
cap log close

***SET WORKING DIRECTORY
cd "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/"

qui include "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do/paths.do"

set checksum off
**GET DATA FOR TOPIC 13: PUBLIC SECTOR
wbopendata, language(en - English) country() topics(13 - Public Sector) indicator() long 

drop countryname region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename
ren year Year
ren countrycode CC

keep if CC=="JPN" | CC=="CHL" | CC=="TUR"

save "${apidata}/WBAPI_T13_premerge.dta", replace

clear

**GET DATA FOR TOPIC 20: EXTERNAL DEBT
wbopendata, language(en - English) country() topics(20 - External Debt) indicator() long projection

drop countryname region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename
ren year Year
ren countrycode CC
keep if CC=="JPN" | CC=="CHL" | CC=="TUR"

save "${apidata}/WBAPI_T20_premerge.dta", replace





