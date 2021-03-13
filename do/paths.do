
version 16
cap log c
set more off

*****SET WD
cd "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata"

*****SET PATHS
global do "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do"
global data "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/data"
global output "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/output"
global plots "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/plots"
*****SET PATH FOR WORLD BANK API DATA FOR DOFILE DATAGET
global apidata "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/data/api_data"

***SET DATASOURCE
global datasource "Data Retrieved 27/02/21 from World Bank DataBank"

***SET GRAPH SCHEME
global grs "color(white) color (black) plotregion(fcolor(white)) graphregion(fcolor(white)) bgcolor(white)"