version 16
cap log c
set more off

*****SET WD
cd "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata"

*****SET PATHS
global do "/Users/ts/Git/Stata_Macro_UM/do/"
global data "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/data"
global output "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/output"

*****SET PATH FOR WORLD BANK API DATA FOR DOFILE DATAGET
global apidata "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/data/api_data"

***SET DATASOURCE
global datasource "Data Retrieved 27/02/21 from World Bank DataBank"
global datasource2 "Data Retrieved 24/03/21 from World Bank Databank and Bank for International Settlements"

***SET GRAPH SCHEME
global grs "color(white) color(black) plotregion(fcolor(white)) graphregion(fcolor(white)) bgcolor(white)"

*graph set window fontface "Times New Roman"
graph set window fontface default
