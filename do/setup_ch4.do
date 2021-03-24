clear all
qui include "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do/paths.do"
******************************************
*GET POLICY RATE DATA FROM BIS SPREADSHEET
******************************************

import excel "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/data/cbpol_2103.xlsx", sheet("Monthly Series") firstrow
keep Backtomenu CentralbankpolicyratesChi CentralbankpolicyratesJap
ren Backtomenu date
encode CentralbankpolicyratesChi, gen(CBRateCHL)
encode CentralbankpolicyratesJap, gen(CBRateJPN)
drop Centralbank*
replace CBRateJPN =0 if CBRateJPN==.

gen day = date(date, "DMY")
format day %td
gen month = month(day)
format month %tm
gen Year = year(day)
format Year %ty
sort Year
drop if Year<1980 | Year>2016
frame copy default chile
frame copy default japan
frame chile{
	keep if month==6 
	sort Year
	tsset Year
	ren CBRateCHL policy_rate
	keep policy_rate Year
	tsfill
	save "${apidata}/CHL_rates.dta", replace
}
frame japan{
	set dp period
	keep if month==6
	sort Year
	tsset Year
	ren CBRateJPN policy_rate
	keep policy_rate Year
	tsfill
	save "${apidata}/JPN_rates.dta", replace
}

clear
****************************************************
****************************************************
****************************************************
**LOAD DATA INCL FRAMES
run "${do}/data_prep.do"


**************************
*SET UP HP TRENDS
**************************
*
foreach frame in "frame JAPAN" "frame CHILE"  {
	
	`frame' {

	cd "${output}/`: var label fr_id '/ch4/"
	
	if CC=="CHL" {
		replace v416 = (13.91-8.71)/2 if Year==1985
		replace v416 = (8.71-6.23)/2 if Year==1987
	} 
****MERGE IN POLICY RATE DATA
merge Year using "${apidata}/`: var label fr_id '_rates.dta"

la var policy_rate "Policy rate"
****GENERATE HP TRENDS
tsfilter hp interest_cyc = policy_rate , trend(interest_trend)

tsfilter hp gdp_cyc = v198 , trend(gdp_trend)

tsfilter hp unemp_cyc = v416 , trend (unemp_trend)

tsfilter hp infl_cyc = v288 , trend(infl_trend)

****GEN DEVIATIONS FROM HP TRENDS
gen interest_dev = policy_rate-interest_trend

gen gdp_dev = v198-gdp_trend

egen NAIRU_trend = mean(unemp_trend)

egen NAIRU = mean(v416)

*gen unemp_dev = v416-unemp_trend
gen unemp_dev = v416-NAIRU


gen infl_dev = v288-infl_trend

*gen gdptaylor = (((v198-gdp_trend)/gdp_trend)*100)

**LABEL AND ORDER
order interest* gdp* unemp* NAIR*, last

la var interest_cyc "Cyclical component of the policy rate"
la var interest_trend "Trend in policy rate (HP)"
la var unemp_trend "Trend in unemployment rate (HP)"
la var gdp_trend "Trend in GDP (HP)"
la var gdp_cyc "Cyclical component of GDP"
la var unemp_cyc "Cyclical component of unemployment"
la var NAIRU "Mean Unemployment Rate across period"
la var NAIRU_trend "Mean Unemployment Rate less cyclical"
la var interest_dev "Deviation from trend in policy rate"
la var gdp_dev "Deviation from trend in GDP"
la var unemp_dev "Deviation from trend in unemployment"

la var infl_cyc "Cyclical component of inflation"
la var infl_trend "Trend in inflation (HP)"
la var infl_dev "Deviation from trend in inflation"
****************************
*CREATE TAYLOR RULES VARS
****************************
gen taylor_93_0 = v288 + 0.5*gdp_trend + 0.5*(v288-0) +0 //TARGET=0%
gen taylor_93_1 = v288 + 0.5*gdp_trend + 0.5*(v288-1) +1 //TARGET=1%
gen taylor_93_2 = v288 + 0.5*gdp_trend + 0.5*(v288-2) +2 //TARGET=2%
gen taylor_93_5 = v288 + 0.5*gdp_trend + 0.5*(v288-5) +5 //TARGET=5%

la var taylor_93_0 "Policy rate of 1993 Taylor Rule, Target 0%, coefficients 0.5"
la var taylor_93_1 "Policy rate of 1993 Taylor Rule, Target 1%, coefficients 0.5"
la var taylor_93_2 "Policy rate of 1993 Taylor Rule, Target 2%, coefficients 0.5"
la var taylor_93_5 "Policy rate of 1993 Taylor Rule, Target 5%, coefficients 0.5"



save "${data}/`: var label fr_id '_FINAL.dta", replace

	}
	}
save "${data}/Final.dta", replace


