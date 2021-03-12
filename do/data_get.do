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

save "${apidata}/WBAPI_T3_raw.dta", replace

**GET DATA FOR TOPIC 7: FINANCIAL SECTOR
clear
wbopendata, language(en - English) country() topics(7 - Financial Sector) indicator() long

save "${apidata}/WBAPI_T7_raw.dta", replace

**GET DATA FOR TOPIC 10: SOCIAL PROTECTION & LABOR
clear
wbopendata, language(en - English) country() topics( 10 - Social Protection & Labor) indicator() long

save "${apidata}/WBAPI_T10_raw.dta", replace
clear

**********************************
****PREPARE DATASETS FOR MARGING
**********************************
**T3
use "${apidata}/WBAPI_T3_raw", clear
**DROP SUPERFLUOUS METADATA
drop countryname region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename

**DROP OBS FOR ALL COUNTRIES EXCEPT JPN, CHL, TUR
keep if countrycode=="JPN" | countrycode=="CHL" | countrycode=="TUR"
**save for appending
save "${apidata}/WBAPI_T3_premerge.dta", replace

**T7
use "${apidata}/WBAPI_T7_raw", clear

**DROP SUPERFLUOUS METADATA
drop countryname region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename

**DROP OBS FOR ALL COUNTRIES EXCEPT JPN, CHL, TUR
keep if countrycode=="JPN" | countrycode=="CHL" | countrycode=="TUR"
**save for appending
save "${apidata}/WBAPI_T7_premerge.dta", replace

**T10
use "${apidata}/WBAPI_T10_raw", clear

**DROP SUPERFLUOUS METADATA
drop countryname region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename

**DROP OBS FOR ALL COUNTRIES EXCEPT JPN, CHL, TUR
keep if countrycode=="JPN" | countrycode=="CHL" | countrycode=="TUR"
**save for appending
save "${apidata}/WBAPI_T10_premerge.dta", replace
