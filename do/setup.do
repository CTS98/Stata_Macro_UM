clear all
version 16
set more off
cap log close

*****SSC PACKAGES REQUIRED, CHECK INSTALL STATUS AND AUTO-INSTALL
*WB OPEN DATA
cap which wbopendata
if _rc != 0 {
	ssc install wbopendata
}

*HOI PACKAGE TO MAKE LONG-FORMAT WB OPENDATA INPUT WORK
cap which hoi
if _rc !=0 {
	ssc install hoi
}
* COPYDESC
cap which copydesc
if _rc != 0 {
	ssc install copydesc
}

* LABUTIL
cap which labutil
if _rc != 0 {
	ssc install labutil
}
* LABUTIL2
cap which labutil2
if _rc != 0 {
	ssc install labutil2
}

* AAPLOT
cap which aaplot
if _rc != 0 {
	ssc install aaplot
}

* WORLDSTAT
cap which worldstat
if _rc != 0 {
	ssc install worldstat
}

* tabout
cap which tabout
if _rc != 0 {
	ssc install tabout
}


