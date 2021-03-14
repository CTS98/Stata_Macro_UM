******
frame reset
******
***SET WORKING DIRECTORY
cd "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/"

include "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do/paths.do"
*LOAD DATA
use "${apidata}/WBAPI_cleaned_renamed.dta", clear

preserve

******REMOVE : FROM VAR LABELS TO PREVENT FILENAME ERRORS
labvarch v*, subst(":" ",")
******REMOVE "MODELED ILO ESTIMATE" from var labels
labvarch v*, subst("modeled ILO" "ILO")
******RELABEL MISC
label variable v277 "Interest rate spread (lending rate - deposit rate, %)"
*****************************
*GEN GDP UNIT CONVERSION VARS
*****************************

*generate converted variables (VC) in unit millions, billions, and Trillions
foreach v in  v194 v195 v196 v197 v199 v209 v210 v214 v215 v218 {
	gen float `v'm = `v' / 1e6
	copydesc `v' `v'm
	local lblm : var label `v'm
	label var `v'm "`lblm' in Millions"
	
	gen float `v'b = `v' / 1e9
	copydesc `v' `v'b
	local lblb : var label `v'b
	label var `v'b "`lblb' in Billions"
	
	gen float `v't = `v' / 1e12
	copydesc `v' `v't
	local lblt : var label `v't
	label var `v't "`lblt' in Trillions"
	}

******************************
*CONVERT GDP in B and T to log
******************************
foreach v in  v194b v195b v196b v197b v199b v209b v210b v214b v215b v218b {
	gen float `v'log = ln(`v')
	copydesc `v' `v'log
	local lbllog : var label `v'log
	label var `v'log "Log `lbllog'"
	
	}
	
foreach v in  v194t v195t v196t v197t v199t v209t v210t v214t v215t v218t {
	gen float `v'log = ln(`v')
	copydesc `v' `v'log
	local lbllog : var label `v'log
	label var `v'log "Log `lbllog'"
	
	}


	
*****GENERATE VARIABLES
gen double rec_ind_t = v199t if v198 < 0
replace rec_ind_t = 0 if rec_ind==.
la var rec_ind_t "Recession Indicator: Annual GDP Growth is Negative"
format rec_ind_t %20.4gc
order rec_ind_t, after(Year)

order v194m - v218tlog, after(rec_ind_t)

gen v73total = v732+v733
la var v73total "Patent applications, total"
order v73total, after(v733)

gen v482alt = (v482/v195)*100
la var v482alt "Interest payments as % of GDP"
order v482alt, after(v482)

gen v482t = (v482/1e12)
la var v482t "Interest payments in Trillions of LCU"

gen totalrev = (v457+473)/1e12
la var totalrev "Nominal total revenue in Trillions of LCU"
order totalrev, after(v457)

gen totalexpense = v487/1e12
la var totalexpense "Nominal total expense in Trillions of LCU"
order totalexpense, after(totalrev)

gen totalrevreal = (totalrev/v187)*100
la var totalrevreal "Total revenue in constant $T LCU"
order totalrevreal, after(v199t)

gen expensereal = (totalexpense/v187)*100
la var expensereal "Expense in constant $T LCU"
order expensereal, after(totalrevreal)

gen budgetdef = totalrev-totalexpense
la var budgetdef "Budget surplus, Trillions of current LCU"
order budgetdef, after(totalrevreal)

gen budgetdefreal = totalrevreal-expensereal
la var budgetdefreal "Budget Surplus, constant $T LCU"
order budgetdefreal, after(budgetdef)

*****GENERATE VARIABLE WITH VALUE LABEL TO USE AS PATH PREFIX
gen int fr_id =1 if CC=="JPN"
recode fr_id (.=2) if CC=="CHL"
recode fr_id (.=3) if CC=="TUR"
order fr_id, before(CC)
la var fr_id "Frame ID"

*****GENERATE VARIABLEs TO LABEL WITHIN FRAMES FOR DIFFERENT LINE COLORS
gen int color_1 =1
order color_1, after(Year)

gen int color_2 =1
order color_2, after(color_1)

gen int color_5 =1
order color_5, after(color_2)

gen int color_scat =1
order color_scat, after(color_5)

gen int color_s_line =1
order color_s_line, after(color_scat)


****REFORMAT ALL VARS TO SAME FMT
format v* %20.4gc
***SAVE WHOLE DATASET
save "${data}/data_cleaned.dta", replace

*************************************
*SEPARATE DATA INTO FRAMES BY COUNTRY
*************************************

***JPN
frame put if CC=="JPN", into(JAPAN)

***CHL
frame put if CC=="CHL", into(CHILE)

***TUR
*frame put if CC=="TUR", into(TURKEY)

*******************
*******PREPARE DATA: CLEAN UP VAR LABELS, DECLARE AS TIME SERIES, ADJUST TIME HORIZON 
*******************
frame JAPAN {
***LABEL FRAME ID FOR OUTPUT PATHS
la var fr_id "JPN"

****SET COLORS FOR PLOT LINES
la var color_1 "navy"
la var color_2 "red blue"
la var color_5 "navy%80 magenta%80 dknavy%80 olive%80 maroon%80"
la var color_scat "navy%80"
la var color_s_line "red"

drop if Year<1984 | Year>2016

******DECLARE DATA TO BE TIME SERIES 
tsset Year

***REPLACE "LCU" by "JPY"
labvarch _all , subst("LCU" "JPY") 

****GEN LAGGED VARIABLES
gen budgetdefreal_pc = (100*D.budgetdefreal/L.budgetdefreal)
la var budgetdefreal_pc "Percentage Change in the Budget Surplus"
order budgetdefreal_pc, after(budgetdefreal)

gen v484_pc = (100*D.v484/L.v484)
la var v484_pc "% Change in Interest Payments as % of Expense"
order v484_pc, after(v484)

*****gen vars for percentage changes in unnemployment and inflation
labvarch v416 , to(")")
gen v416_pc_ch = (v416/L.v416-1)*100
la var v416_pc_ch "Percentage Point Change in Unemployment" 
order v416_pc_ch, after(v416)

gen v63_ch = (v63-L.v63-1)
replace v63_ch = 0 if v63_ch==.
la var v63_ch "Percentage Point Change in Inflation"
order v63_ch, after(v63)


*****gen vars for recession Years, used for xlines and scatterplot markers
gen int RecYear = Year if v217 < 0
la var RecYear "Recession Years"
order RecYear, after(Year)
tostring RecYear, gen(RYString)
replace RYString = "" if RYString=="."

****GEN OPPOSITE OF V367
gen double v367opp = 100-v367
order v367opp, after (v367)
la var v367opp "Labor force participation rate for ages 25+, total (%)"

la da "World Bank Economic Indicators, Japan, 1984-2016"
save "${data}/JPN_prepared.dta", replace
}

frame CHILE {
***LABEL FRAME ID FOR OUTPUT PATHS
la var fr_id "CHL"

****SET COLORS FOR PLOT LINES
la var color_1 "dkgreen"
la var color_2 "green orange"
la var color_5 "orange%80 dkgreen%80 midgreen%80 emerald%80 cranberry%80"
la var color_scat "dkgreen%80"
la var color_s_line "orange"

drop if Year<1979 | Year>2011

******DECLARE DATA TO BE TIME SERIES 
tsset Year

***REPLACE "LCU" by "CLP"
labvarch _all , subst("LCU" "CLP") 

****GEN LAGGED VARIABLES
gen budgetdefreal_pc = (100*D.budgetdefreal/L.budgetdefreal)
la var budgetdefreal_pc "Percentage Change in the Budget Surplus"
order budgetdefreal_pc, after(budgetdefreal)

gen v484_pc = (100*D.v484/L.v484)
la var v484_pc "% Change in Interest Payments as % of Expense"
order v484_pc, after(v484)

*****gen var for percentage change in unnemployment
labvarch v416 , to(")")
gen v416_pc_ch = (v416-L.v416-1)
la var v416_pc_ch "Percentage Point Change in Unemployment" 
order v416_pc_ch, after(v416)

gen v63_ch = (v63-L.v63-1)
replace v63_ch = 0 if v63_ch==.
la var v63_ch "Percentage Point Change in Inflation"
order v63_ch, after(v63)

*****gen var for recession Years
gen int RecYear = Year if v217 < 0
la var RecYear "Recession Years"
order RecYear, after(Year)
tostring RecYear, gen(RYString)
replace RYString = "" if RYString=="."

****GEN OPPOSITE OF V367
gen double v367opp = 100-v367
order v367opp, after (v367)
la var v367opp "Labor force participation rate for ages 25+, total (%)"


la da "World Bank Economic Indicators, Chile, 1979-2011"
save "${data}/CHL_prepared.dta", replace
}
/*
frame TURKEY {
*gen byte fr_id =3
la var fr_id "TUR"
order fr_id, before(CC)

drop if Year<1984 | Year>2013
***REPLACE "LCU" by "TL"
labvarch v* , subst("LCU" "TL") 
tsset Year
la da "World Bank Economic Indicators, Turkey, 1984-2013"
save "${data}/TUR_prepared.dta", replace
}
*/
save "${data}/data_prepared.dta", replace

restore

use "${data}/data_prepared", clear
