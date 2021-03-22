clear all
qui include "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do/paths.do"
**LOAD DATA INCL FRAMES
run "${do}/data_prep.do"



**************************
*CHAPTER 4 PLOTS & FIGURES
**************************

/*IDEAS

from syllabus: 
In the first part (which is the relatively longer of the two), you will study the monetary policy of your country. When you think of your country’s monetary policy, the Taylor rule is a standard way to describe the priorities of the Central Bank. Do your best to estimate it, and in any case be sure to add your own description of what your analysis means in terms of the monetary policy practice within the country. The information you use in this part may well build on your past chapters, when you find them useful (for example with the medium run target values of unemployment and inflation).

*/



foreach frame in "frame JAPAN" "frame CHILE" {
	
	`frame' {

	cd "${output}/`: var label fr_id '/ch3/"
	
	if CC=="CHL" {
		graph set window fontface "Times New Roman"
	} 
	
gr drop _all
		
	}
}

