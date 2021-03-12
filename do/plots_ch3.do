
include "/Users/ts/OneDrive/Uni/UM OD/Year 1/Macro/stata/do/paths.do"
**LOAD DATA INCL FRAMES
run "${do}/data_prep.do"

frame change JAPAN

**************************
*CHAPTER 3 PLOTS & FIGURES
**************************

/*IDEAS

from syllabus: In weeks 5 and 6, we discuss the long run and policy issues, including fiscal policy. Again, we focus on the changes in your country throughout the time period you are analyzing. This time (in the third chapter), we look at government debt and its dynamics. Has debt gone up or down? What about the different components of government debt? Now compare this debt dynamics to the long-run growth of the economy. Remember from last week you can look at specific factors that may lead to higher long run growth. Compare the long run growth with what you found as government debt dynamics. Make an inference on the risk of your country based on this, as well as on the effect of the interest rate

central gov debt: v64, PV of current external debt: v53-55 short-term debt: v51
general gov final consumption expenditure: v67-v72
claims on central gov: v264, v280

maybe interesting: v423, v294

*/


/*
foreach frame in "frame JAPAN" "frame CHILE" {
	
	`frame' {

	cd "${output}/`: var label fr_id '/ch3/"
		

	
 
gr drop _all
		
	}
}

